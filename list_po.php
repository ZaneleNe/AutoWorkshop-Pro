<?php
include("../auth/auth_check.php");
include("../config/db.php");

/* Fetch all POs with supplier */
$pos = $conn->query("
    SELECT po.*, s.company_name AS supplier_name
    FROM purchase_orders po
    LEFT JOIN suppliers s ON po.supplier_id = s.id
    ORDER BY po.id DESC
");
?>

<!DOCTYPE html>
<html>
<head>
    <title>Purchase Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>Purchase Orders</h3>
        <a href="create_po.php" class="btn btn-success">+ Create New PO</a>
    </div>

    <!-- Success message after deletion -->
    <?php if(isset($_GET['msg'])): ?>
        <div class="alert alert-success"><?= htmlspecialchars($_GET['msg']) ?></div>
    <?php endif; ?>

    <table class="table table-bordered table-hover">
        <thead class="table-light">
            <tr>
                <th>PO Number</th>
                <th>Supplier</th>
                <th>Order Date</th>
                <th>Expected Date</th>
                <th>Status</th>
                <th>Total</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <?php while($po = $pos->fetch_assoc()): ?>
                <tr>
                    <td><?= htmlspecialchars($po['po_number']) ?></td>
                    <td><?= htmlspecialchars($po['supplier_name']) ?></td>
                    <td><?= htmlspecialchars($po['order_date']) ?></td>
                    <td><?= htmlspecialchars($po['expected_date']) ?></td>
                    <td>
                        <?php
                        switch($po['status']){
                            case 'Pending':
                                echo '<span class="badge bg-warning">Pending</span>';
                                break;
                            case 'Partially Received':
                                echo '<span class="badge bg-info">Partially Received</span>';
                                break;
                            case 'Received':
                                echo '<span class="badge bg-success">Received</span>';
                                break;
                            default:
                                echo '<span class="badge bg-secondary">'.htmlspecialchars($po['status']).'</span>';
                        }
                        ?>
                    </td>
                    <td>R <?= number_format($po['total'],2) ?></td>
                    <td>
                        <a href="view_po.php?id=<?= $po['id'] ?>" class="btn btn-primary btn-sm mb-1">View</a>
                        <a href="edit_po.php?id=<?= $po['id'] ?>" class="btn btn-warning btn-sm mb-1">Edit</a>
                        <a href="delete.php?id=<?= $po['id'] ?>" 
                           onclick="return confirm('Are you sure you want to delete this Purchase Order?');" 
                           class="btn btn-danger btn-sm mb-1">Delete</a>
                    </td>
                </tr>
            <?php endwhile; ?>
        </tbody>
    </table>
</div>

</body>
</html>