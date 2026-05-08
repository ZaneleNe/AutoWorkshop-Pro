<?php
include("../auth/auth_check.php");
include("../config/db.php");
include("../includes/po_functions.php");

$user_id = $_SESSION['user_id'];

/* Fetch suppliers */
$suppliers = $conn->query("SELECT id, company_name FROM suppliers ORDER BY company_name ASC");

/* Fetch stock items */
$stock_items = $conn->query("SELECT id, part_name, manufacturer, unit_price FROM stock ORDER BY part_name ASC");

/* Handle Form Submission */
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $supplier_id   = $_POST['supplier_id'];
    $order_date    = $_POST['order_date'];
    $expected_date = $_POST['expected_date'];

    $items      = $_POST['item_id'];
    $quantities = $_POST['quantity'];
    $prices     = $_POST['unit_price'];

    $po_number = generatePONumber($conn);
    $subtotal = 0;

    // Calculate subtotal
    for ($i = 0; $i < count($items); $i++) {
        if (!empty($items[$i])) {
            $subtotal += $quantities[$i] * $prices[$i];
        }
    }

    $vat   = $subtotal * 0.15;
    $total = $subtotal + $vat;

    // ----------------------------
    // Insert Purchase Order (safe)
    // ----------------------------
    $sql = "INSERT INTO purchase_orders 
            (po_number, supplier_id, order_date, expected_date, subtotal, vat, total, status, created_by)
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending', ?)";
    $stmt = $conn->prepare($sql);
    if (!$stmt) die("Prepare failed: ".$conn->error);
    $stmt->bind_param("sissdddi", $po_number, $supplier_id, $order_date, $expected_date, $subtotal, $vat, $total, $user_id);
    if (!$stmt->execute()) die("Execute failed: ".$stmt->error);

    $purchase_order_id = $stmt->insert_id;

    // ----------------------------
    // Insert Items
    // ----------------------------
    for ($i = 0; $i < count($items); $i++) {
        if (!empty($items[$i])) {
            $line_total = $quantities[$i] * $prices[$i];
            $sql_item = "INSERT INTO purchase_order_items
                         (purchase_order_id, stock_id, quantity, unit_price, total, received_qty)
                         VALUES (?, ?, ?, ?, ?, 0)";
            $stmt_item = $conn->prepare($sql_item);
            if (!$stmt_item) die("Prepare failed (item): ".$conn->error);
            $stmt_item->bind_param("iiidd", $purchase_order_id, $items[$i], $quantities[$i], $prices[$i], $line_total);
            if (!$stmt_item->execute()) die("Execute failed (item): ".$stmt_item->error);
        }
    }

    header("Location: view_po.php?id=$purchase_order_id&created=1");
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Create Purchase Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white">
            <h4>Create Purchase Order</h4>
        </div>
        <div class="card-body">
            <form method="POST">

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Supplier</label>
                        <select name="supplier_id" class="form-select" required>
                            <option value="">Select Supplier</option>
                            <?php while($supplier = $suppliers->fetch_assoc()): ?>
                                <option value="<?= $supplier['id'] ?>"><?= $supplier['company_name'] ?></option>
                            <?php endwhile; ?>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Order Date</label>
                        <input type="date" name="order_date" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Expected Date</label>
                        <input type="date" name="expected_date" class="form-control">
                    </div>
                </div>

                <hr>
                <h5>Items</h5>

                <table class="table table-bordered" id="itemsTable">
                    <thead class="table-light">
                        <tr>
                            <th>Item</th>
                            <th>Manufacturer</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <select name="item_id[]" class="form-select stock_select">
                                    <option value="">Select Item</option>
                                    <?php 
                                    $stock_items->data_seek(0);
                                    while($stock = $stock_items->fetch_assoc()): ?>
                                        <option value="<?= $stock['id'] ?>"
                                                data-price="<?= $stock['unit_price'] ?>"
                                                data-manufacturer="<?= $stock['manufacturer'] ?>">
                                            <?= $stock['part_name'] ?>
                                        </option>
                                    <?php endwhile; ?>
                                </select>
                            </td>
                            <td><input type="text" class="form-control manufacturer" readonly></td>
                            <td><input type="number" step="0.01" name="quantity[]" class="form-control qty"></td>
                            <td><input type="number" step="0.01" name="unit_price[]" class="form-control price"></td>
                            <td><input type="text" class="form-control total" readonly></td>
                            <td class="text-center"><button type="button" class="btn btn-danger btn-sm removeRow">X</button></td>
                        </tr>
                    </tbody>
                </table>

                <div class="text-end mb-3">
                    <button type="button" id="addRow" class="btn btn-secondary">Add Item</button>
                </div>

                <div class="text-end">
                    <h5>Subtotal: R <span id="subtotal">0.00</span></h5>
                    <h5>VAT (15%): R <span id="vat">0.00</span></h5>
                    <h4>Total: R <span id="grandTotal">0.00</span></h4>
                </div>

                <div class="text-end mt-3">
                    <button type="submit" class="btn btn-success">Save Purchase Order</button>
                </div>

            </form>
        </div>
    </div>
</div>

<script>
function calculateTotals() {
    let subtotal = 0;
    document.querySelectorAll('#itemsTable tbody tr').forEach(row => {
        const qty = parseFloat(row.querySelector('.qty').value) || 0;
        const price = parseFloat(row.querySelector('.price').value) || 0;
        const total = qty * price;
        row.querySelector('.total').value = total.toFixed(2);
        subtotal += total;
    });
    const vat = subtotal * 0.15;
    const grandTotal = subtotal + vat;
    document.getElementById('subtotal').innerText = subtotal.toFixed(2);
    document.getElementById('vat').innerText = vat.toFixed(2);
    document.getElementById('grandTotal').innerText = grandTotal.toFixed(2);
}

function attachRowEvents(row){
    row.querySelector('.stock_select').addEventListener('change', function() {
        const price = parseFloat(this.selectedOptions[0].dataset.price) || 0;
        const manufacturer = this.selectedOptions[0].dataset.manufacturer || '';
        row.querySelector('.price').value = price.toFixed(2);
        row.querySelector('.manufacturer').value = manufacturer;
        calculateTotals();
    });

    row.querySelector('.qty').addEventListener('input', calculateTotals);
    row.querySelector('.price').addEventListener('input', calculateTotals);

    row.querySelector('.removeRow').addEventListener('click', function(){
        row.remove();
        calculateTotals();
    });
}

// Attach events to initial row
document.querySelectorAll('#itemsTable tbody tr').forEach(row => attachRowEvents(row));

// Add new row dynamically
document.getElementById('addRow').addEventListener('click', function(){
    const table = document.getElementById('itemsTable').getElementsByTagName('tbody')[0];
    const newRow = table.rows[0].cloneNode(true);
    newRow.querySelectorAll('input').forEach(input => input.value = '');
    newRow.querySelector('.stock_select').selectedIndex = 0;
    table.appendChild(newRow);
    attachRowEvents(newRow);
});
</script>

</body>
</html>
