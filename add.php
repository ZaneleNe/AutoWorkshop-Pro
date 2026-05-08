<?php
include("../auth/auth_check.php");
include("../config/db.php");

// Logged-in staff
$user_id = $_SESSION['user_id'];

// Fetch the staff's active jobcard without a quotation yet
$sql = "
    SELECT 
        j.id AS jobcard_id,
        j.customer_id,
        j.vehicle_id,
        j.jobcard_number
    FROM jobcards j
    WHERE j.created_by = ?
    AND j.id NOT IN (
        SELECT jobcard_id 
        FROM quotations 
        WHERE jobcard_id IS NOT NULL
    )
    ORDER BY j.id DESC
    LIMIT 1
";

$stmt = $conn->prepare($sql);
if (!$stmt) {
    die("Prepare failed: " . $conn->error);
}

$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$jobcard = $result->fetch_assoc();
if (!$jobcard) {
    die("No active jobcards available for your account.");
}

// Assign to variables
$jobcard_id = $jobcard['jobcard_id'];
$customer_id = $jobcard['customer_id']; // may be 0
$vehicle_id = $jobcard['vehicle_id'];   // may be NULL
?>

<!DOCTYPE html>
<html>
<head>
    <title>Create Quotation</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        input, select, textarea, button { padding:5px; margin:5px 0; width:300px; }
        table { border-collapse: collapse; width: 100%; margin-top:10px; }
        table, th, td { border:1px solid #ccc; }
        th, td { padding:5px; text-align:left; }
        .remove-btn { cursor:pointer; color:red; }
    </style>
</head>
<body>

<h2>Create Quotation for Jobcard: <?= htmlspecialchars($jobcard['jobcard_number']) ?></h2>

<form method="POST" action="create.php" id="quotationForm">

    <!-- Hidden fields -->
    <input type="hidden" name="jobcard_id" value="<?= $jobcard_id ?>">
    <input type="hidden" name="customer_id" value="<?= $customer_id ?>">
    <input type="hidden" name="vehicle_id" value="<?= $vehicle_id ?>">

    Quotation Date:<br>
    <input type="date" name="quotation_date" value="<?= date('Y-m-d') ?>" required><br><br>

    Valid Until:<br>
    <input type="date" name="valid_until" required><br><br>

    Status:<br>
    <select name="status">
        <option value="Draft">Draft</option>
        <option value="Sent">Sent</option>
    </select><br><br>

    Notes:<br>
    <textarea name="notes" rows="3"></textarea><br><br>

    VAT (%):<br>
    <input type="number" name="vat" value="15" step="0.01"><br><br>

    Discount:<br>
    <input type="number" name="discount" value="0" step="0.01"><br><br>

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
// Dynamic item rows
function addRow() {
    const table = document.getElementById('itemsTable');
    const row = table.insertRow();
    row.innerHTML = `
        <td><input type="text" name="description[]" required></td>
        <td><input type="number" name="quantity[]" value="1" min="1" step="1" required></td>
        <td><input type="number" name="unit_price[]" value="0" step="0.01" required></td>
        <td><input type="number" name="item_total[]" value="0" step="0.01" readonly></td>
        <td><span class="remove-btn" onclick="removeRow(this)">x</span></td>
    `;
    attachEvents();
}

function removeRow(el){
    const row = el.closest('tr');
    row.remove();
}

function attachEvents(){
    const rows = document.querySelectorAll('#itemsTable tr');
    rows.forEach((row,index)=>{
        if(index === 0) return; // skip header
        const qty = row.querySelector('input[name="quantity[]"]');
        const price = row.querySelector('input[name="unit_price[]"]');
        const total = row.querySelector('input[name="item_total[]"]');
        [qty,price].forEach(input=>{
            input.oninput = function(){
                total.value = (parseFloat(qty.value)||0)*(parseFloat(price.value)||0);
            }
        });
    });
}
attachEvents();
</script>

</body>
</html>
