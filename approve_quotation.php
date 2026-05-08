<?php
include("../auth/auth_check.php");
include("../config/db.php");

// 1️⃣ Get quotation ID
if (!isset($_GET['id'])) {
    die("Quotation ID missing.");
}

$quotation_id = (int)$_GET['id'];
$approved_by = $_SESSION['user_id'];
$approval_date = date('Y-m-d');

// 2️⃣ Update quotation
$stmt = $conn->prepare("
    UPDATE quotations 
    SET approved_by = ?, approval_date = ?, status = 'Approved'
    WHERE id = ?
");

if (!$stmt) {
    die("Prepare failed: " . $conn->error);
}

$stmt->bind_param("isi", $approved_by, $approval_date, $quotation_id);

if ($stmt->execute()) {
    // 3️⃣ Redirect back to view_quotation
    header("Location: view_quotation.php?id=" . $quotation_id);
    exit;
} else {
    die("Error approving quotation: " . $stmt->error);
}
