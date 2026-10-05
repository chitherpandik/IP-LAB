<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
    </head>
    <body>
        <html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<?php
$xml = simplexml_load_file("books.xml") or die ("Error: Cannot load XML File");
echo "<center>";
echo "<h1>Book Details</h1>";
echo "<table border='1' cellpadding='8'>";
echo "<th>Book ID</th>";
echo "<th>Book Name</th>";
echo "<th>Author</th>";
echo "<th>Price</th>";
echo "</tr>";
foreach ($xml->books->book as $book){
echo "<tr>";
echo "<td>".$book->bid."</td>";
echo "<td>".$book->bname."</td>";
echo "<td>".$book->author."</td>";
echo "<td>".$book->price."</td>";
echo "</tr>";
}
echo "</table>";
echo "</center>";
?>
</body>
</html>
    </body>
</html>
