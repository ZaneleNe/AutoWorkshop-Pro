<?php
include("../auth/auth_check.php");
include("../config/db.php");

/* Get search term */
$search = trim($_GET['search'] ?? '');

$sql = "
    SELECT 
        q.id,
        q.quotation_number,
        q.quotation_date,
        q.status,
        q.total,
        c.name AS customer_name
    FROM quotations q
    LEFT JOIN customers c ON q.customer_id = c.id
";

$params = [];
$types  = "";

if ($search !== '') {
    $sql .= "
        WHERE 
            q.quotation_number LIKE ?
            OR c.name LIKE ?
            OR q.status LIKE ?
    ";
    $like = "%$search%";
    $params = [$like, $like, $like];
    $types = "sss";
}

$sql .= " ORDER BY q.id DESC";

$stmt = $conn->prepare($sql);

if (!empty($params)) {
    $stmt->bind_param($types, ...$params);
}

$stmt->execute();
$result = $stmt->get_result();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Quotations</title>
    <style>
        body { font-family: Arial, sans-serif; margin:20px; }
        table { width:100%; border-collapse: collapse; margin-top:10px; }
        table, th, td { border:1px solid #ccc; }
        th, td { padding:8px; text-align:left; }
        .btn { padding:5px 10px; text-decoration:none; border:1px solid #333; margin-right:4px; }
        .view { background:#007bff; color:#fff; }
        .approve { background:#28a745; color:#fff; }
        .draft { color:#d39e00; font-weight:bold; }
        .approved { color:#28a745; font-weight:bold; }

        .search-box {
            margin-bottom: 10px;
        }
        .search-box input {
            padding:6px;
            width:250px;
        }
        .search-box button {
            padding:6px 10px;
        }
    </style>
</head>
<body>

<h2>Quotations</h2>

<!-- SEARCH BAR -->
<form method="get" class="search-box">
    <input 
        type="text" 
        name="search" 
        placeholder="Search quotation, customer or status..."
        value="<?= htmlspecialchars($search) ?>"
    >
    <button type="submit">Search</button>

    <?php if ($search !== ''): ?>
        <a href="list_quotations.php">Clear</a>
    <?php endif; ?>
</form>

<table>
    <tr>
        <th>#</th>
        <th>Quotation No</th>
        <th>Date</th>
        <th>Customer</th>
        <th>Status</th>
        <th>Total</th>
        <th>Action</th>
    </tr>

    <?php if ($result->num_rows === 0): ?>
        <tr>
            <td colspan="7">No quotations found.</td>
        </tr>
    <?php endif; ?>

    <?php while ($row = $result->fetch_assoc()): ?>
    <tr>
        <td><?= $row['id'] ?></td>
        <td><?= htmlspecialchars($row['quotation_number']) ?></td>
        <td><?= htmlspecialchars($row['quotation_date']) ?></td>
        <td><?= htmlspecialchars($row['customer_name'] ?? 'N/A') ?></td>
        <td class="<?= strtolower($row['status']) ?>">
            <?= htmlspecialchars($row['status']) ?>
        </td>
        <td>R <?= number_format($row['total'], 2) ?></td>
        <td>
            <a class="btn view" href="view_quotation.php?id=<?= $row['id'] ?>">View</a>

            <?php if ($row['status'] === 'Draft'): ?>
                <a class="btn approve"
                   href="approve_quotation.php?id=<?= $row['id'] ?>"
                   onclick="return confirm('Approve this quotation?')">
                   Approve
                </a>
            <?php endif; ?>
        </td>
    </tr>
    <?php endwhile; ?>
</table>

</body>
</html>
