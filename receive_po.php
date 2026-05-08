<?php
include("../auth/auth_check.php");
include("../config/db.php");

// Get PO ID
if (!isset($_GET['id'])) {
    die("Purchase Order ID missing");
}
$po_id = (int)$_GET['id'];

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $receive_qty = $_POST['receive_qty'] ?? []; // keyed by purchase_order_item id

    // Fetch PO items
    $items_query = $conn->query("
        SELECT poi.*, st.id AS stock_id
        FROM purchase_order_items poi
        LEFT JOIN stock st ON poi.stock_id = st.id
        WHERE poi.purchase_order_id = $po_id
    ");

    $all_received = true; // flag to track if all items fully received

    while ($item = $items_query->fetch_assoc()) {
        $item_id = $item['id'];
        $receive_now = (int)($receive_qty[$item_id] ?? 0);
        $new_received = $item['received_qty'];

        if ($receive_now > 0) {
            $new_received += $receive_now;

            // Update received_qty
            $stmt = $conn->prepare("UPDATE purchase_order_items SET received_qty = ? WHERE id = ?");
            $stmt->bind_param("ii", $new_received, $item_id);
            $stmt->execute();

            // Update stock quantity
            $stmt2 = $conn->prepare("UPDATE stock SET quantity = quantity + ? WHERE id = ?");
            $stmt2->bind_param("ii", $receive_now, $item['stock_id']);
            $stmt2->execute();
        }

        // Check if fully received
        if ($new_received < $item['quantity']) {
            $all_received = false;
        }
    }

    // Update PO status
    $status = $all_received ? 'Received' : 'Partially Received';
    $stmt3 = $conn->prepare("UPDATE purchase_orders SET status = ? WHERE id = ?");
    $stmt3->bind_param("si", $status, $po_id);
    $stmt3->execute();

    // Redirect back to view
    header("Location: view_po.php?id=$po_id&received=1");
    exit;
}

// Fetch PO info
$po_query = $conn->query("
    SELECT po.*, s.company_name AS supplier_name
    FROM purchase_orders po
    LEFT JOIN suppliers s ON po.supplier_id = s.id
    WHERE po.id = $po_id
");
$po = $po_query->fetch_assoc();
if (!$po) die("Purchase Order not found");

// Fetch PO items
$items_query = $conn->query("
    SELECT poi.*, st.part_name, st.manufacturer
    FROM purchase_order_items poi
    LEFT JOIN stock st ON poi.stock_id = st.id
    WHERE poi.purchase_order_id = $po_id
");
?>

<!DOCTYPE html>
<html>
<head>
    <title>Receive Purchase Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">

    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white">
            <h4>Receive Purchase Order</h4>
        </div>
        <div class="card-body">

            <h5>PO Number: <?= $po['po_number'] ?></h5>
            <p>
                Supplier: <?= $po['supplier_name'] ?><br>
                Order Date: <?= $po['order_date'] ?><br>
                Expected Date: <?= $po['expected_date'] ?><br>
                Status: <?= $po['status'] ?>
            </p>

            <form method="POST">
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Item</th>
                            <th>Manufacturer</th>
                            <th>Ordered Qty</th>
                            <th>Already Received</th>
                            <th>Receive Now</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php while($item = $items_query->fetch_assoc()): ?>
                        <tr>
                            <td><?= $item['part_name'] ?></td>
                            <td><?= $item['manufacturer'] ?></td>
                            <td><?= $item['quantity'] ?></td>
                            <td><?= $item['received_qty'] ?></td>
                            <td>
                                <input type="number" min="0" max="<?= $item['quantity'] - $item['received_qty'] ?>" 
                                       name="receive_qty[<?= $item['id'] ?>]" 
                                       class="form-control" value="0">
                            </td>
                        </tr>
                        <?php endwhile; ?>
                    </tbody>
                </table>

                <div class="text-end mt-3">
                    <button type="submit" class="btn btn-success">Mark as Received</button>
                </div>
            </form>

        </div>
    </div>
</div>
</body>
</html>
