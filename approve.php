<?php
include("../auth/auth_check.php");
include("../config/db.php");
?>

<!DOCTYPE html>
<html>
<head>
    <title>All Quotations</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">All Quotations</h2>

    <div class="row">
        <?php
        $query = "SELECT q.*, c.name AS customer_name 
                  FROM quotations q 
                  LEFT JOIN customers c ON q.customer_id = c.id 
                  ORDER BY q.id DESC";
        $result = $conn->query($query);

        if($result->num_rows == 0){
            echo "<p class='text-muted'>No quotations found.</p>";
        }

        while($row = $result->fetch_assoc()){
            // Status badge
            switch($row['status']){
                case 'Draft': $badge='secondary'; break;
                case 'Sent': $badge='primary'; break;
                case 'Approved': $badge='success'; break;
                case 'Rejected': $badge='danger'; break;
                default: $badge='secondary';
            }

            echo "<div class='col-md-4 mb-4'>
                    <div class='card shadow-sm h-100'>
                        <div class='card-body'>
                            <h5 class='card-title'>{$row['quotation_number']}</h5>
                            <p class='card-text'><strong>Customer:</strong> {$row['customer_name']}</p>
                            <p class='card-text'><strong>Vehicle:</strong> {$row['vehicle_text']}</p>
                            <p class='card-text'><strong>Date:</strong> {$row['quotation_date']}</p>
                            <span class='badge bg-{$badge}'>{$row['status']}</span>
                        </div>
                        <div class='card-footer text-end'>
                            <a href='view.php?id={$row['id']}' class='btn btn-sm btn-info'>View</a>
                        </div>
                    </div>
                  </div>";
        }
        ?>
    </div>

    <a href="../dashboard/index.php" class="btn btn-secondary mt-3">⬅ Back to Dashboard</a>
</div>
</body>
</html>
