<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (Integer) session.getAttribute("userId");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>

<head>

    <title>My Purchases</title>

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
            width: 90%;
            margin: 40px auto;
        }

        h1 {
            margin-bottom: 20px;
        }

        .success {
            background: #d1e7dd;
            color: #0f5132;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .table-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.10);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #222;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .status {
            background: #d1e7dd;
            color: #0f5132;
            padding: 6px 10px;
            border-radius: 5px;
            font-size: 13px;
        }

        .empty {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #222;
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

    <h1>My Purchases</h1>

<%
    if (success != null && !success.isEmpty()) {
%>

    <div class="success">
        <%= success %>
    </div>

<%
    }
%>


<div class="table-box">

<table>

    <tr>
        <th>ID</th>
        <th>Resource</th>
        <th>Category</th>
        <th>Seller</th>
        <th>Quantity</th>
        <th>Price</th>
        <th>Total Amount</th>
        <th>Status</th>
    </tr>

<%
    boolean hasPurchases = false;

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");

        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/campus_resource",
            "root",
            "Chither@2006"
        );

        String sql =
            "SELECT p.id, " +
            "r.resource_name, " +
            "r.category, " +
            "s.name AS seller_name, " +
            "p.quantity, " +
            "p.price, " +
            "p.total_amount, " +
            "p.status " +
            "FROM purchases p " +
            "JOIN resources r ON p.resource_id = r.id " +
            "JOIN students s ON r.student_id = s.id " +
            "WHERE p.buyer_id = ? " +
            "ORDER BY p.id DESC";

        ps = con.prepareStatement(sql);

        ps.setInt(1, userId);

        rs = ps.executeQuery();

        while (rs.next()) {

            hasPurchases = true;
%>

    <tr>

        <td>
            <%= rs.getInt("id") %>
        </td>

        <td>
            <%= rs.getString("resource_name") %>
        </td>

        <td>
            <%= rs.getString("category") %>
        </td>

        <td>
            <%= rs.getString("seller_name") %>
        </td>

        <td>
            <%= rs.getInt("quantity") %>
        </td>

        <td>
            ?<%= String.format("%.2f", rs.getDouble("price")) %>
        </td>

        <td>
            ?<%= String.format("%.2f", rs.getDouble("total_amount")) %>
        </td>

        <td>
            <span class="status">
                <%= rs.getString("status") %>
            </span>
        </td>

    </tr>

<%
        }

        if (!hasPurchases) {
%>

    <tr>
        <td colspan="8" class="empty">
            You have not purchased any resources yet.
        </td>
    </tr>

<%
        }

    } catch (Exception e) {
%>

    <tr>
        <td colspan="8" class="empty">
            Database error: <%= e.getMessage() %>
        </td>
    </tr>

<%
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

</table>

</div>


<a class="back" href="resources.jsp">
    ? Back to Resources
</a>

</div>

</body>

</html>