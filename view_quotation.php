<?php
include("../auth/auth_check.php");
include("../config/db.php");

// Get quotation ID
if (!isset($_GET['id'])) {
    die("Quotation ID missing.");
}

$quotation_id = (int)$_GET['id'];

// Fetch quotation with full vehicle info
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

// Fetch quotation items
$stmt_items = $conn->prepare("SELECT * FROM quotation_items WHERE quotation_id = ?");
$stmt_items->bind_param("i", $quotation_id);
$stmt_items->execute();
$items_result = $stmt_items->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>View Quotation <?= htmlspecialchars($q['quotation_number']) ?></title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 10px; }
        table, th, td { border: 1px solid #ccc; }
        th, td { padding: 5px; text-align: left; }
        h2, h3 { margin-top: 20px; }
        .approve-btn { margin-top: 10px; padding: 8px 12px; background-color: green; color: white; border: none; cursor: pointer; }
        .print-btn { margin-bottom: 20px; padding: 8px 12px; background-color: #007bff; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>

<!-- Print button -->
<a href="print_quotation.php?id=<?= $q['id'] ?>" target="_blank">
    <button class="print-btn">Print Quotation</button>
</a>

<h2>Quotation: <?= htmlspecialchars($q['quotation_number']) ?></h2>
<p>
    <strong>Status:</strong> <?= htmlspecialchars($q['status'] ?? '-') ?><br>
    <strong>Quotation Date:</strong> <?= htmlspecialchars($q['quotation_date'] ?? '-') ?><br>
    <strong>Valid Until:</strong> <?= htmlspecialchars($q['valid_until'] ?? '-') ?><br>
</p>

<h3>Customer Info</h3>
<p>
    <?= htmlspecialchars($q['customer_name'] ?? '-') ?><br>
    <?= htmlspecialchars($q['customer_phone'] ?? '-') ?><br>
    <?= htmlspecialchars($q['customer_email'] ?? '-') ?><br>
    <?= htmlspecialchars($q['customer_address'] ?? '-') ?><br>
</p>

<h3>Vehicle Info</h3>
<p>
    Make & Model: <?= htmlspecialchars($q['vehicle_make'] ?? '-') ?> <?= htmlspecialchars($q['vehicle_model'] ?? '-') ?><br>
    Colour: <?= htmlspecialchars($q['vehicle_colour'] ?? '-') ?><br>
    VIN: <?= htmlspecialchars($q['vin_number'] ?? '-') ?><br>
    Registration: <?= htmlspecialchars($q['registration_number'] ?? '-') ?><br>
</p>

<h3>Notes</h3>
<p><?= nl2br(htmlspecialchars($q['notes'] ?? '-')) ?></p>

<h3>Items</h3>
<table>
    <tr>
        <th>#</th>
        <th>Description</th>
        <th>Quantity</th>
        <th>Unit Price</th>
        <th>Total</th>
    </tr>
    <?php 
    $count = 1; 
    while ($item = $items_result->fetch_assoc()): 
    ?>
    <tr>
        <td><?= $count++ ?></td>
        <td><?= htmlspecialchars($item['description']) ?></td>
        <td><?= $item['quantity'] ?></td>
        <td><?= number_format($item['unit_price'], 2) ?></td>
        <td><?= number_format($item['total'], 2) ?></td>
    </tr>
    <?php endwhile; ?>
</table>

<h3>Totals</h3>
<p>
    Subtotal: R <?= number_format($q['subtotal'], 2) ?><br>
    VAT (<?= number_format($q['vat'], 2) ?>%): R <?= number_format(($q['subtotal'] * $q['vat']/100), 2) ?><br>
    Discount: R <?= number_format($q['discount'], 2) ?><br>
    <strong>Total: R <?= number_format($q['total'], 2) ?></strong>
</p>

<?php if($q['status'] !== 'Approved'): ?>
<a href="approve_quotation.php?id=<?= $q['id'] ?>">
    <button class="approve-btn">Approve Quotation</button>
</a>
<?php endif; ?>

</body>
</html>
