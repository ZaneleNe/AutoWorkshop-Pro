<?php
include("../auth/auth_check.php");
include("../config/db.php");

// Get quotation ID
if (!isset($_GET['id'])) die("Quotation ID missing.");

$quotation_id = (int)$_GET['id'];

// Fetch quotation
$stmt = $conn->prepare("
    SELECT q.*, 
           c.name AS customer_name, c.phone AS customer_phone, c.email AS customer_email, c.address AS customer_address,
           v.make AS vehicle_make, v.model AS vehicle_model, v.colour AS vehicle_colour, v.vin_number, v.registration_number
    FROM quotations q
    LEFT JOIN customers c ON q.customer_id = c.id
    LEFT JOIN vehicles v ON q.vehicle_id = v.id
    WHERE q.id = ?
");
if (!$stmt) die("Prepare failed: (" . $conn->errno . ") " . $conn->error);
$stmt->bind_param("i", $quotation_id);
$stmt->execute();
$q = $stmt->get_result()->fetch_assoc();
if (!$q) die("Quotation not found.");

// Fetch items
$stmt_items = $conn->prepare("SELECT * FROM quotation_items WHERE quotation_id = ?");
$stmt_items->bind_param("i", $quotation_id);
$stmt_items->execute();
$items = $stmt_items->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Quotation <?= htmlspecialchars($q['quotation_number']) ?></title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; font-size: 13px; }
        h1 { text-align: center; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #000; padding: 8px; }
        th { background-color: #f2f2f2; }
        .right { text-align: right; }
        .no-border td { border: none; padding: 4px; }
        .totals { width: 300px; float: right; margin-top: 20px; border: 1px solid #000; }
        .totals td { border: none; padding: 4px; }
        .totals td.right { text-align: right; font-weight: bold; }
        .section-title { margin-top: 20px; font-weight: bold; text-decoration: underline; }
    </style>
</head>
<body onload="window.print()">

<h1>QUOTATION</h1>

<table class="no-border">
<tr>
<td>
<strong>Customer:</strong><br>
<?= htmlspecialchars($q['customer_name'] ?? '-') ?><br>
<?= htmlspecialchars($q['customer_address'] ?? '-') ?><br>
<?= htmlspecialchars($q['customer_phone'] ?? '-') ?><br>
<?= htmlspecialchars($q['customer_email'] ?? '-') ?>
</td>
<td class="right">
<strong>Quotation No:</strong> <?= $q['quotation_number'] ?><br>
<strong>Date:</strong> <?= $q['quotation_date'] ?><br>
<strong>Valid Until:</strong> <?= $q['valid_until'] ?>
</td>
</tr>
</table>

<div class="section-title">Vehicle Info</div>
<p>
Make & Model: <?= htmlspecialchars($q['vehicle_make'] ?? '-') ?> <?= htmlspecialchars($q['vehicle_model'] ?? '-') ?><br>
Colour: <?= htmlspecialchars($q['vehicle_colour'] ?? '-') ?><br>
VIN: <?= htmlspecialchars($q['vin_number'] ?? '-') ?><br>
Registration: <?= htmlspecialchars($q['registration_number'] ?? '-') ?>
</p>

<div class="section-title">Items</div>
<table>
<tr>
<th>#</th>
<th>Description</th>
<th>Quantity</th>
<th>Unit Price</th>
<th>Total</th>
</tr>
<?php $i = 1; while ($item = $items->fetch_assoc()): ?>
<tr>
<td><?= $i++ ?></td>
<td><?= htmlspecialchars($item['description']) ?></td>
<td class="right"><?= $item['quantity'] ?></td>
<td class="right">R <?= number_format($item['unit_price'], 2) ?></td>
<td class="right">R <?= number_format($item['total'], 2) ?></td>
</tr>
<?php endwhile; ?>
</table>

<table class="totals">
<tr><td>Subtotal</td><td class="right">R <?= number_format($q['subtotal'], 2) ?></td></tr>
<tr><td>VAT (<?= number_format($q['vat'], 2) ?>%)</td><td class="right">R <?= number_format(($q['subtotal'] * $q['vat']/100), 2) ?></td></tr>
<tr><td>Discount</td><td class="right">R <?= number_format($q['discount'], 2) ?></td></tr>
<tr><td>Total</td><td class="right">R <?= number_format($q['total'], 2) ?></td></tr>
</table>

<div style="clear: both;"></div>

<div class="section-title">Notes</div>
<p><?= nl2br(htmlspecialchars($q['notes'] ?? '-')) ?></p>

</body>
</html>
