<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int currentUserId = (Integer) session.getAttribute("userId");

    String resourceIdParam = request.getParameter("resourceId");

    if (resourceIdParam == null || resourceIdParam.trim().isEmpty()) {
        response.sendRedirect("resources.jsp");
        return;
    }

    int resourceId;

    try {
        resourceId = Integer.parseInt(resourceIdParam);
    } catch (Exception e) {
        response.sendRedirect("resources.jsp");
        return;
    }

    String resourceName = "";
    String category = "";
    String description = "";
    String sellerName = "";
    double price = 0;
    int availableQuantity = 0;
    int sellerId = 0;
    String status = "";

    boolean resourceFound = false;
    String errorMessage = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/campus_resource",
            "root",
            "Chither@2006"
        );

        String sql =
            "SELECT r.id, r.student_id, r.resource_name, r.category, " +
            "r.description, r.price, r.available_quantity, r.status, " +
            "s.name AS seller_name " +
            "FROM resources r " +
            "JOIN students s ON r.student_id = s.id " +
            "WHERE r.id = ?";

        ps = con.prepareStatement(sql);
        ps.setInt(1, resourceId);

        rs = ps.executeQuery();

        if (rs.next()) {

            resourceFound = true;

            sellerId = rs.getInt("student_id");
            resourceName = rs.getString("resource_name");
            category = rs.getString("category");
            description = rs.getString("description");
            price = rs.getDouble("price");
            availableQuantity = rs.getInt("available_quantity");
            status = rs.getString("status");
            sellerName = rs.getString("seller_name");

            if (sellerId == currentUserId) {
                errorMessage = "You cannot purchase your own resource.";
            } else if (!"ACTIVE".equalsIgnoreCase(status)) {
                errorMessage = "This resource is not available for purchase.";
            } else if (availableQuantity <= 0) {
                errorMessage = "This resource is out of stock.";
            }
        }

    } catch (Exception e) {
        errorMessage = "Database error: " + e.getMessage();
    } finally {
        try {
            if (rs != null) rs.close();
        } catch (Exception e) {}

        try {
            if (ps != null) ps.close();
        } catch (Exception e) {}

        try {
            if (con != null) con.close();
        } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>

    <title>Purchase Resource</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .navbar {
            background: #222;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h2 {
            margin: 0;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
        }

        .container {
            width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.12);
        }

        h1 {
            margin-top: 0;
        }

        .details {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .row {
            margin: 10px 0;
        }

        .label {
            font-weight: bold;
        }

        .price {
            font-size: 22px;
            font-weight: bold;
            color: #198754;
        }

        input[type="number"] {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            margin-bottom: 15px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            width: 100%;
            padding: 13px;
            background: #198754;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #157347;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #333;
        }

        .error {
            background: #f8d7da;
            color: #842029;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .total {
            background: #e9f7ef;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 18px;
        }

    </style>

</head>

<body>

<div class="navbar">

    <h2>Campus Resource Marketplace</h2>

    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="resources.jsp">Resources</a>
        <a href="purchase-history.jsp">My Purchases</a>
        <a href="LogoutServlet">Logout</a>
    </div>

</div>


<div class="container">

<%
    if (!resourceFound) {
%>

    <div class="error">
        Resource not found.
    </div>

    <a class="back" href="resources.jsp">
        ? Back to Resources
    </a>

<%
    } else {
%>

    <h1>Purchase Resource</h1>

<%
        if (!errorMessage.isEmpty()) {
%>

        <div class="error">
            <%= errorMessage %>
        </div>

        <a class="back" href="resources.jsp">
            ? Back to Resources
        </a>

<%
        } else {
%>

        <div class="details">

            <div class="row">
                <span class="label">Resource:</span>
                <%= resourceName %>
            </div>

            <div class="row">
                <span class="label">Category:</span>
                <%= category %>
            </div>

            <div class="row">
                <span class="label">Description:</span>
                <%= description == null ? "" : description %>
            </div>

            <div class="row">
                <span class="label">Seller:</span>
                <%= sellerName %>
            </div>

            <div class="row">
                <span class="label">Price:</span>

                <span class="price">
                    ?<%= String.format("%.2f", price) %>
                </span>
            </div>

            <div class="row">
                <span class="label">Available Quantity:</span>
                <%= availableQuantity %>
            </div>

        </div>


        <form action="PurchaseServlet" method="post">

            <input
                type="hidden"
                name="resourceId"
                value="<%= resourceId %>"
            >

            <label>
                <b>Quantity to Purchase</b>
            </label>

            <input
                type="number"
                id="quantity"
                name="quantity"
                min="1"
                max="<%= availableQuantity %>"
                value="1"
                required
                oninput="calculateTotal()"
            >

            <div class="total">
                Total Amount:
                ?<span id="totalAmount">
                    <%= String.format("%.2f", price) %>
                </span>
            </div>

            <button type="submit">
                Confirm Purchase
            </button>

        </form>

        <a class="back" href="resources.jsp">
            ? Cancel
        </a>

<%
        }
    }
%>

</div>


<script>

    const price = <%= price %>;

    function calculateTotal() {

        let quantity =
            parseInt(document.getElementById("quantity").value);

        if (isNaN(quantity) || quantity < 1) {
            quantity = 1;
        }

        let total = price * quantity;

        document.getElementById("totalAmount").innerText =
            total.toFixed(2);
    }

</script>

</body>
</html>