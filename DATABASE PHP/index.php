<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Order Details</title>
    </head>
    <body>
        
        <?php
        // 1. Added the database name as the 4th parameter (change 'your_database' to your actual DB name)
        $conn = new mysqli("localhost", "root", "test@123", "mysql");
        if ($conn->connect_error) {
            die("Connection Failed: " . $conn->connect_error);
        }

        // 2. Fixed the $_['phone'] typo to $_POST['phone']
        $name = $_POST['name'];
        $email = $_POST['email'];
        $phone = $_POST['phone'];
        $address = $_POST['address'];
        $price = $_POST['price'];
        

        echo '<h2>Entered Order Details</h2>';
        echo 'Customer Name: ' . $name . "<br>";
        echo 'Email: ' . $email . "<br>";
        echo 'Address: ' . $address . "<br>";
        echo 'Price: ' . $price . "<br>";
        
        
        // 3. Added single quotes ('') around values in the SQL string
        // 4. Made column names consistent (using 'phone' to match your table)
        $sql = "INSERT INTO order2 (name, email, phone, address, price) VALUES ('$name', '$email', '$phone', '$address', '$price')";
        
        if ($conn->query($sql) === TRUE) {
            echo "<h3>Order Stored Successfully</h3>";
        } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
         
        // 5. Fixed the SELECT query execution (removed the redundant mysqli_query wrapper)
        $result = $conn->query("SELECT * FROM order2");

        echo "<h2>All Orders</h2>";

        echo "<table border='1' cellpadding='10' cellspacing='0'>";
        echo "<tr>
           
            <th>Customer Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Address</th>
            <th>Price</th>
            
        </tr>";

        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            // 6. Added $row['id'] for the ID column so data aligns properly with table headers
            
            echo "<td>" . $row['name'] . "</td>";
            echo "<td>" . $row['email'] . "</td>";
            echo "<td>" . $row['phone'] . "</td>"; // Matches the 'phone' column in DB
            echo "<td>" . $row['address'] . "</td>";
            echo "<td>" . $row['price'] . "</td>";
            
            echo "</tr>";
        }

        echo "</table>";

        $conn->close();
        ?>
    </body>
</html>