<?php
include("../auth/auth_check.php");
include("../config/db.php");

// Make sure an ID is provided
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    header("Location: list_po.php");
    exit();
}

$po_id = (int)$_GET['id'];

// First, optionally delete all items related to this PO
$conn->query("DELETE FROM purchase_order_items WHERE purchase_order_id = $po_id");

// Then delete the PO itself
if ($conn->query("DELETE FROM purchase_orders WHERE id = $po_id")) {
    // Redirect back with success message
    header("Location: list_po.php?msg=Purchase Order deleted successfully");
    exit();
} else {
    // Redirect back with error message
    header("Location: list_po.php?msg=Error deleting Purchase Order");
    exit();
}
?>