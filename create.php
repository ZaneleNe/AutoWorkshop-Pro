<?php
include("../auth/auth_check.php");
include("../config/db.php");

$user_id = $_SESSION['user_id'];

// Handle POST submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // --- CUSTOMER ---
    $customer_name    = trim($_POST['customer_name'] ?? '');
    $customer_phone   = trim($_POST['customer_phone'] ?? '');
    $customer_address = trim($_POST['customer_address'] ?? '');
    $customer_email   = trim($_POST['customer_email'] ?? '');
    if (!$customer_name) die("Customer name is required.");

    // Check if customer exists
    $stmt = $conn->prepare("SELECT id FROM customers WHERE name=? LIMIT 1");
    $stmt->bind_param("s", $customer_name);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($row = $result->fetch_assoc()) {
        $customer_id = $row['id'];
    } else {
        $stmt = $conn->prepare("INSERT INTO customers (name, phone, address, email) VALUES (?,?,?,?)");
        $stmt->bind_param("ssss", $customer_name, $customer_phone, $customer_address, $customer_email);
        $stmt->execute();
        $customer_id = $stmt->insert_id;
    }

    // --- VEHICLE ---
    $vehicle_make         = trim($_POST['vehicle_make'] ?? '');
    $vehicle_model        = trim($_POST['vehicle_model'] ?? '');
    $vehicle_colour       = trim($_POST['vehicle_colour'] ?? '');
    $vin_number           = trim($_POST['vin_number'] ?? '');
    $registration_number  = trim($_POST['registration_number'] ?? '');
    if (!$vehicle_make) die("Vehicle make is required.");

    $stmt = $conn->prepare("SELECT id FROM vehicles WHERE make=? AND model=? AND customer_id=? LIMIT 1");
    $stmt->bind_param("ssi", $vehicle_make, $vehicle_model, $customer_id);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($row = $result->fetch_assoc()) {
        $vehicle_id = $row['id'];
        // Update existing vehicle
        $stmt_up = $conn->prepare("UPDATE vehicles SET colour=?, vin_number=?, registration_number=? WHERE id=?");
        $stmt_up->bind_param("sssi", $vehicle_colour, $vin_number, $registration_number, $vehicle_id);
        $stmt_up->execute();
    } else {
        $stmt = $conn->prepare("INSERT INTO vehicles (make, model, customer_id, colour, vin_number, registration_number) VALUES (?,?,?,?,?,?)");
        $stmt->bind_param("ssisss", $vehicle_make, $vehicle_model, $customer_id, $vehicle_colour, $vin_number, $registration_number);
        $stmt->execute();
        $vehicle_id = $stmt->insert_id;
    }

    // --- JOBCARD ---
    $stmt = $conn->prepare("SELECT id FROM jobcards WHERE created_by=? AND id NOT IN (SELECT jobcard_id FROM quotations) LIMIT 1");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($jobcard = $result->fetch_assoc()) {
        $jobcard_id = $jobcard['id'];
    } else {
        $jobcard_number = 'JC-' . time();
        $problem_description = 'Auto-created for quotation';
        $stmt = $conn->prepare("INSERT INTO jobcards (jobcard_number, created_by, customer_id, vehicle_id, problem_description) VALUES (?,?,?,?,?)");
        $stmt->bind_param("siiss", $jobcard_number, $user_id, $customer_id, $vehicle_id, $problem_description);
        $stmt->execute();
        $jobcard_id = $stmt->insert_id;
    }

    // --- QUOTATION ---
    $quotation_date = $_POST['quotation_date'] ?? date('Y-m-d');
    $valid_until    = $_POST['valid_until'] ?? date('Y-m-d', strtotime('+7 days'));
    $status         = $_POST['status'] ?? 'Draft';
    $notes          = $_POST['notes'] ?? '';
    $vat            = isset($_POST['vat']) ? (float)$_POST['vat'] : 0;
    $discount       = isset($_POST['discount']) ? (float)$_POST['discount'] : 0;

    $descriptions = $_POST['description'] ?? [];
    $quantities   = $_POST['quantity'] ?? [];
    $unit_prices  = $_POST['unit_price'] ?? [];

    $subtotal = 0;
    $items_data = [];
    for ($i = 0; $i < count($descriptions); $i++) {
        $desc  = trim($descriptions[$i]);
        $qty   = (float)$quantities[$i];
        $price = (float)$unit_prices[$i];
        $total = $qty * $price;
        $subtotal += $total;
        $items_data[] = ['description'=>$desc,'quantity'=>$qty,'unit_price'=>$price,'total'=>$total];
    }
    $total = $subtotal + ($subtotal*$vat/100) - $discount;

    // Insert quotation
    $quotation_number = 'Q-' . time();
    $stmt = $conn->prepare("INSERT INTO quotations (quotation_number, customer_id, vehicle_id, quotation_date, valid_until, status, created_by, jobcard_id, notes, subtotal, vat, discount, total, created_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,NOW())");
    $stmt->bind_param("siisssiisdddd",$quotation_number,$customer_id,$vehicle_id,$quotation_date,$valid_until,$status,$user_id,$jobcard_id,$notes,$subtotal,$vat,$discount,$total);
    $stmt->execute();
    $quotation_id = $stmt->insert_id;

    // Insert quotation items
    $stmt_item = $conn->prepare("INSERT INTO quotation_items (quotation_id, description, quantity, unit_price, total) VALUES (?,?,?,?,?)");
    foreach($items_data as $item){
        $stmt_item->bind_param("isddd",$quotation_id,$item['description'],$item['quantity'],$item['unit_price'],$item['total']);
        $stmt_item->execute();
    }

    header("Location: view_quotation.php?id=".$quotation_id);
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Create Quotation</title>
    <style>
        body{font-family:Arial;margin:20px;}
        input, select, textarea, button{padding:5px;margin:5px 0;width:300px;}
        table{border-collapse:collapse;width:100%;margin-top:10px;}
        table, th, td{border:1px solid #ccc;}
        th, td{padding:5px;text-align:left;}
        .remove-btn{cursor:pointer;color:red;}
    </style>
</head>
<body>

<h2>Create Quotation</h2>

<form method="POST" action="create.php">

    <!-- CUSTOMER -->
    <h3>Customer</h3>
    Name:<br>
    <input type="text" name="customer_name" id="customerName" list="customersList" required>
    <datalist id="customersList">
        <?php
        $res = $conn->query("SELECT name FROM customers ORDER BY name");
        while($row = $res->fetch_assoc()){
            echo '<option value="'.htmlspecialchars($row['name']).'">';
        }
        ?>
    </datalist><br>
    Phone:<br><input type="text" name="customer_phone"><br>
    Address:<br><input type="text" name="customer_address"><br>
    Email:<br><input type="email" name="customer_email"><br><br>

    <!-- VEHICLE -->
    <h3>Vehicle</h3>
    Make:<br>
    <input type="text" name="vehicle_make" id="vehicleMake" list="vehiclesMakeList" required>
    <datalist id="vehiclesMakeList">
        <?php
        $res = $conn->query("SELECT DISTINCT make FROM vehicles ORDER BY make");
        while($row = $res->fetch_assoc()){
            echo '<option value="'.htmlspecialchars($row['make']).'">';
        }
        ?>
    </datalist><br>

    Model:<br>
    <input type="text" name="vehicle_model" id="vehicleModel" list="vehiclesModelList">
    <datalist id="vehiclesModelList">
        <?php
        $res = $conn->query("SELECT DISTINCT model FROM vehicles ORDER BY model");
        while($row = $res->fetch_assoc()){
            echo '<option value="'.htmlspecialchars($row['model']).'">';
        }
        ?>
    </datalist><br>

    Colour:<br>
    <input type="text" name="vehicle_colour"><br>
    VIN Number:<br>
    <input type="text" name="vin_number"><br>
    Registration Number:<br>
    <input type="text" name="registration_number"><br><br>

    <!-- QUOTATION INFO -->
    Quotation Date:<br><input type="date" name="quotation_date" value="<?=date('Y-m-d')?>" required><br>
    Valid Until:<br><input type="date" name="valid_until" required><br>
    Status:<br>
    <select name="status">
        <option value="Draft">Draft</option>
        <option value="Sent">Sent</option>
    </select><br><br>

    Notes:<br><textarea name="notes" rows="3"></textarea><br><br>
    VAT (%):<br><input type="number" name="vat" value="15" step="0.01"><br>
    Discount:<br><input type="number" name="discount" value="0" step="0.01"><br><br>

    <!-- QUOTATION ITEMS -->
    <h3>Quotation Items</h3>
    <table id="itemsTable">
        <tr>
            <th>Description</th>
            <th>Qty</th>
            <th>Unit Price</th>
            <th>Total</th>
            <th>Action</th>
        </tr>
        <tr>
            <td><input type="text" name="description[]" required></td>
            <td><input type="number" name="quantity[]" value="1" min="1" step="1" required></td>
            <td><input type="number" name="unit_price[]" value="0" step="0.01" required></td>
            <td><input type="number" name="item_total[]" value="0" step="0.01" readonly></td>
            <td><span class="remove-btn" onclick="removeRow(this)">x</span></td>
        </tr>
    </table>
    <button type="button" onclick="addRow()">+ Add Item</button><br><br>

    <button type="submit">Create Quotation</button>
</form>

<script>
// ITEM ROW DYNAMICS
function addRow(){
    const table=document.getElementById('itemsTable');
    const row=table.insertRow();
    row.innerHTML=`<td><input type="text" name="description[]" required></td>
    <td><input type="number" name="quantity[]" value="1" min="1" step="1" required></td>
    <td><input type="number" name="unit_price[]" value="0" step="0.01" required></td>
    <td><input type="number" name="item_total[]" value="0" step="0.01" readonly></td>
    <td><span class="remove-btn" onclick="removeRow(this)">x</span></td>`;
    attachEvents();
}
function removeRow(el){ el.closest('tr').remove(); }

function attachEvents(){
    const rows=document.querySelectorAll('#itemsTable tr');
    rows.forEach((row,index)=>{
        if(index===0) return;
        const qty=row.querySelector('input[name="quantity[]"]');
        const price=row.querySelector('input[name="unit_price[]"]');
        const total=row.querySelector('input[name="item_total[]"]');
        [qty,price].forEach(input=>{
            input.oninput=function(){ total.value=(parseFloat(qty.value)||0)*(parseFloat(price.value)||0); }
        });
    });
}
attachEvents();

// AUTOFILL CUSTOMER DATA
document.getElementById('customerName').addEventListener('change', function(){
    const name = this.value;
    if(!name) return;
    fetch('ajax_get_customer.php?name=' + encodeURIComponent(name))
    .then(res=>res.json())
    .then(data=>{
        if(data.success){
            document.querySelector('input[name="customer_phone"]').value = data.phone;
            document.querySelector('input[name="customer_address"]').value = data.address;
            document.querySelector('input[name="customer_email"]').value = data.email;
        }
    });
});
</script>

</body>
</html>
