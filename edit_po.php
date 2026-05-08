<?php
include("../auth/auth_check.php");
include("../config/db.php");
include("../includes/po_functions.php");

if(!isset($_GET['id'])) die("PO not found");

$po_id = (int)$_GET['id'];

/* Fetch PO header */
$po_res = $conn->query("SELECT * FROM purchase_orders WHERE id = $po_id");
$po = $po_res->fetch_assoc();

/* Fetch PO items */
$items_res = $conn->query("
    SELECT poi.*, s.part_name, s.manufacturer, s.unit_price
    FROM purchase_order_items poi
    LEFT JOIN stock s ON poi.stock_id = s.id
    WHERE purchase_order_id = $po_id
");

/* Fetch suppliers & stock items for dropdowns */
$suppliers = $conn->query("SELECT id, company_name FROM suppliers ORDER BY company_name ASC");
$stock_items = $conn->query("SELECT id, part_name, manufacturer, unit_price FROM stock ORDER BY part_name ASC");

/* Handle update submission */
if($_SERVER['REQUEST_METHOD'] === 'POST'){

    $supplier_id   = $_POST['supplier_id'];
    $order_date    = $_POST['order_date'];
    $expected_date = $_POST['expected_date'];
    $status        = $_POST['status'];
    $items         = $_POST['item_id'];
    $quantities    = $_POST['quantity'];
    $prices        = $_POST['unit_price'];

    $subtotal = 0;
    $valid_items = [];

    for ($i=0; $i<count($items); $i++){
        if(!empty($items[$i])){
            $line_total = $quantities[$i]*$prices[$i];
            $subtotal += $line_total;
            $valid_items[] = [
                'stock_id'=>$items[$i],
                'quantity'=>$quantities[$i],
                'unit_price'=>$prices[$i],
                'total'=>$line_total
            ];
        }
    }

    if(count($valid_items)>0){
        $vat = $subtotal*0.15;
        $total = $subtotal+$vat;

        /* Update PO */
        $stmt = $conn->prepare("
            UPDATE purchase_orders
            SET supplier_id=?, order_date=?, expected_date=?, subtotal=?, vat=?, total=?, status=?
            WHERE id=?
        ");
        $stmt->bind_param("issddssi", $supplier_id, $order_date, $expected_date, $subtotal, $vat, $total, $status, $po_id);
        $stmt->execute();

        /* Delete old items */
        $conn->query("DELETE FROM purchase_order_items WHERE purchase_order_id=$po_id");

        /* Insert new items */
        $stmt_item = $conn->prepare("
            INSERT INTO purchase_order_items
            (purchase_order_id, stock_id, quantity, unit_price, total)
            VALUES (?, ?, ?, ?, ?)
        ");
        foreach($valid_items as $item){
            $stmt_item->bind_param(
                "iiddi",
                $po_id,
                $item['stock_id'],
                $item['quantity'],
                $item['unit_price'],
                $item['total']
            );
            $stmt_item->execute();
        }

        header("Location: list_po.php?success=1");
        exit;
    } else {
        $error = "Please select at least one item.";
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Edit PO <?= $po['po_number'] ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="card shadow-lg">
        <div class="card-header bg-warning text-white d-flex justify-content-between">
            <h4>Edit PO: <?= $po['po_number'] ?></h4>
            <a href="list_po.php" class="btn btn-light btn-sm">Back to List</a>
        </div>
        <div class="card-body">

            <?php if(!empty($error)): ?>
                <div class="alert alert-danger"><?= $error ?></div>
            <?php endif; ?>

            <form method="POST">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Supplier</label>
                        <select name="supplier_id" class="form-select" required>
                            <option value="">Select Supplier</option>
                            <?php while($s = $suppliers->fetch_assoc()): ?>
                                <option value="<?= $s['id'] ?>" <?= $s['id']==$po['supplier_id']?'selected':'' ?>>
                                    <?= $s['company_name'] ?>
                                </option>
                            <?php endwhile; ?>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Order Date</label>
                        <input type="date" name="order_date" class="form-control" value="<?= $po['order_date'] ?>" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Expected Date</label>
                        <input type="date" name="expected_date" class="form-control" value="<?= $po['expected_date'] ?>">
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select" required>
                            <option value="Pending" <?= $po['status']=='Pending'?'selected':'' ?>>Pending</option>
                            <option value="Partially Received" <?= $po['status']=='Partially Received'?'selected':'' ?>>Partially Received</option>
                            <option value="Received" <?= $po['status']=='Received'?'selected':'' ?>>Received</option>
                        </select>
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
                        <?php
                        if($items_res->num_rows>0){
                            while($item=$items_res->fetch_assoc()): ?>
                                <tr>
                                    <td>
                                        <select name="item_id[]" class="form-select stock_select" required>
                                            <option value="">Select Item</option>
                                            <?php $stock_items->data_seek(0);
                                            while($s=$stock_items->fetch_assoc()): ?>
                                                <option value="<?= $s['id'] ?>"
                                                        data-price="<?= $s['unit_price'] ?>"
                                                        data-manufacturer="<?= $s['manufacturer'] ?>"
                                                        <?= $s['id']==$item['stock_id']?'selected':'' ?>>
                                                    <?= $s['part_name'] ?>
                                                </option>
                                            <?php endwhile; ?>
                                        </select>
                                    </td>
                                    <td><input type="text" class="form-control manufacturer" readonly value="<?= $item['manufacturer'] ?>"></td>
                                    <td><input type="number" step="0.01" name="quantity[]" class="form-control qty" value="<?= $item['quantity'] ?>" required></td>
                                    <td><input type="number" step="0.01" name="unit_price[]" class="form-control price" value="<?= $item['unit_price'] ?>" required></td>
                                    <td><input type="text" class="form-control total" readonly value="<?= $item['total'] ?>"></td>
                                    <td><button type="button" class="btn btn-danger btn-sm removeRow">X</button></td>
                                </tr>
                            <?php endwhile;
                        } ?>
                    </tbody>
                </table>

                <button type="button" id="addRow" class="btn btn-secondary mb-3">+ Add Item</button>

                <div class="text-end">
                    <h5>Subtotal: R <span id="subtotal"><?= number_format($po['subtotal'],2) ?></span></h5>
                    <h5>VAT (15%): R <span id="vat"><?= number_format($po['vat'],2) ?></span></h5>
                    <h4>Total: R <span id="grandTotal"><?= number_format($po['total'],2) ?></span></h4>
                </div>

                <div class="text-end mt-3">
                    <button type="submit" class="btn btn-success">Update Purchase Order</button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>
// Dynamic JS same as create_po.php
function updateRow(select){
    const row = select.closest('tr');
    const price = select.selectedOptions[0].dataset.price || 0;
    const manufacturer = select.selectedOptions[0].dataset.manufacturer || '';
    row.querySelector('.price').value = parseFloat(price).toFixed(2);
    row.querySelector('.manufacturer').value = manufacturer;
    calculateTotals();
}

function calculateTotals(){
    let subtotal=0;
    document.querySelectorAll('#itemsTable tbody tr').forEach(row=>{
        let qty=parseFloat(row.querySelector('.qty').value)||0;
        let price=parseFloat(row.querySelector('.price').value)||0;
        let total=qty*price;
        row.querySelector('.total').value=total.toFixed(2);
        subtotal+=total;
    });
    let vat=subtotal*0.15;
    let grandTotal=subtotal+vat;
    document.getElementById('subtotal').innerText=subtotal.toFixed(2);
    document.getElementById('vat').innerText=vat.toFixed(2);
    document.getElementById('grandTotal').innerText=grandTotal.toFixed(2);
}

document.querySelector('#itemsTable').addEventListener('change', function(e){
    if(e.target.classList.contains('stock_select')) updateRow(e.target);
});
document.querySelector('#itemsTable').addEventListener('input', function(e){
    if(e.target.classList.contains('qty')||e.target.classList.contains('price')) calculateTotals();
});
document.querySelector('#itemsTable').addEventListener('click', function(e){
    if(e.target.classList.contains('removeRow')){ e.target.closest('tr').remove(); calculateTotals(); }
});

document.getElementById('addRow').addEventListener('click', function(){
    const tbody=document.querySelector('#itemsTable tbody');
    const firstRow=tbody.querySelector('tr');
    const newRow=firstRow.cloneNode(true);
    newRow.querySelector('.stock_select').selectedIndex=0;
    newRow.querySelector('.manufacturer').value='';
    newRow.querySelector('.qty').value='';
    newRow.querySelector('.price').value='';
    newRow.querySelector('.total').value='';
    tbody.appendChild(newRow);
});
</script>

</body>
</html>
