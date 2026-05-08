<?php
include("../auth/auth_check.php");
include("../config/db.php");

// Get quotation ID from URL
$quotation_id = $_GET['id'] ?? null;
if (!$quotation_id) {
    exit("Quotation ID missing.");
}

// Update the quotation status to 'Accepted'
$stmt = $conn->prepare("UPDATE quotations SET status='Accepted' WHERE id=?");
$stmt->bind_param("i", $quotation_id);

if ($stmt->execute()) {
    header("Location: view.php?success=1");
    exit();
} else {
    die("Failed to accept quotation: " . $stmt->error);
}
