<?php
include("../auth/auth_check.php");
include("../config/db.php");

if(!isset($_GET['po_id'])) die("PO not specified");

$po_id = (int)$_GET['po_id'];

/* Fetch PO */
$po_res = $conn->query("SELECT * FROM purchase_orders WHERE id=$po_id");
$po = $po_res->fetch_assoc();

if(!$po) die("PO not found");

/* Handle payment */
if($_SERVER['REQUEST_METHOD']==='POST'){
    $amount = (float)$_POST['amount'];
    $method = $_POST['method'];

    if($amount>0){
        $stmt = $conn->prepare("INSERT INTO payments (po_id, amount, method, paid_by) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("idss", $po_id, $amount, $method, $_SESSION['user_id']);
        $stmt->execute();

        // Update PO paid total
        $conn->query("UPDATE purchase_orders SET paid = IFNULL(paid,0)+$amount WHERE id=$po_id");

        header("Location: view_po.php?id=$po_id&paid=1");
        exit;
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Record Payment for PO <?= $po['po_number'] ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white">
            <h4>Record Payment: <?= $po['po_number'] ?></h4>
        </div>
        <div class="card-body">
            <form method="POST">
                <div class="mb-3">
                    <label>Amount</label>
                    <input type="number" name="amount" step="0.01" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Payment Method</label>
                    <select name="method" class="form-select" required>
                        <option value="">Select Method</option>
                        <option value="Cash">Cash</option>
                        <option value="Card">Card</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                    </select>
                </div>
                <div class="text-end">
                    <button type="submit" class="btn btn-success">Record Payment</button>
                    <a href="view_po.php?id=<?= $po_id ?>" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
