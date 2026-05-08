<?php
include("../auth/auth_check.php");
include("../config/db.php");

if(!isset($_GET['id'])) die("PO not found");

$po_id = (int)$_GET['id'];

/* Fetch PO with supplier */
$po_res = $conn->query("
    SELECT po.*, s.company_name AS supplier_name
    FROM purchase_orders po
    LEFT JOIN suppliers s ON po.supplier_id = s.id
    WHERE po.id=$po_id
");
$po = $po_res->fetch_assoc();

/* Fetch items */
$items_res = $conn->query("
    SELECT poi.*, s.part_name, s.manufacturer
    FROM purchase_order_items poi
    LEFT JOIN stock s ON poi.stock_id=s.id
    WHERE purchase_order_id=$po_id
");
?>

<!DOCTYPE html>
<html>
<head>
    <title>View PO <?= $po['po_number'] ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h4>Purchase Order: <?= $po['po_number'] ?></h4>
            <a href="list_po.php" class="btn btn-light btn-sm">Back to List</a>
        </div>
        <div class="card-body">

            <p><strong>Supplier:</strong> <?= $po['supplier_name'] ?></p>
            <p><strong>Order Date:</strong> <?= $po['order_date'] ?></p>
            <p><strong>Expected Date:</strong> <?= $po['expected_date'] ?></p>
            <p><strong>Status:</strong>
                <?php
                    switch($po['status']){
                        case 'Pending': echo '<span class="badge bg-warning">Pending</span>'; break;
                        case 'Partially Received': echo '<span class="badge bg-info">Partially Received</span>'; break;
                        case 'Received': echo '<span class="badge bg-success">Received</span>'; break;
                        default: echo '<span class="badge bg-secondary">'.$po['status'].'</span>';
                    }
                ?>
            </p>

            <?php if($po['status'] != 'Received'): ?>
    <a href="receive_po.php?id=<?= $po['id'] ?>" class="btn btn-success mb-3"
       onclick="return confirm('Mark this PO as Received?')">Mark as Received</a>
<?php endif; ?>

            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Item</th>
                        <th>Manufacturer</th>
                        <th>Quantity</th>
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

        </div>
    </div>
</div>
</body>
</html>
