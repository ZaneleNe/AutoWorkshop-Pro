<?php
include("../auth/auth_check.php");
include("../config/db.php");

if(!isset($_GET['po_id'])) die("PO not specified");

$po_id = (int)$_GET['po_id'];

/* Fetch PO and items */
$po_res = $conn->query("SELECT po.*, s.company_name AS supplier_name FROM purchase_orders po LEFT JOIN suppliers s ON po.supplier_id=s.id WHERE po.id=$po_id");
$po = $po_res->fetch_assoc();

$items_res = $conn->query("
    SELECT poi.*, s.part_name, s.manufacturer
    FROM purchase_order_items poi
    LEFT JOIN stock s ON poi.stock_id=s.id
    WHERE purchase_order_id=$po_id
");

$invoice_number = "INV-".date('YmdHis');
?>

<!DOCTYPE html>
<html>
<head>
    <title>Invoice <?= $invoice_number ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white">
            <h4>Invoice: <?= $invoice_number ?></h4>
        </div>
        <div class="card-body">
            <p><strong>Supplier:</strong> <?= $po['supplier_name'] ?></p>
            <p><strong>PO Number:</strong> <?= $po['po_number'] ?></p>
            <p><strong>Date:</strong> <?= date('Y-m-d') ?></p>

            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Item</th>
                        <th>Manufacturer</th>
                        <th>Qty</th>
                        <th>Unit Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <?php while($item=$items_res->fetch_assoc()): ?>
                        <tr>
                            <td><?= $item['part_name'] ?></td>
                            <td><?= $item['manufacturer'] ?></td>
                            <td><?= $item['quantity'] ?></td>
                            <td>R <?= number_format($item['unit_price'],2) ?></td>
                            <td>R <?= number_format($item['total'],2) ?></td>
                        </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>

            <div class="text-end">
                <h5>Subtotal: R <?= number_format($po['subtotal'],2) ?></h5>
                <h5>VAT (15%): R <?= number_format($po['vat'],2) ?></h5>
                <h4>Total: R <?= number_format($po['total'],2) ?></h4>
            </div>

            <div class="text-end mt-3">
                <button class="btn btn-success" onclick="window.print()">Print Invoice</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
