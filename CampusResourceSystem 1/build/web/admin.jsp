<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userType = (String) session.getAttribute("userType");

    if (userType == null || !"ADMIN".equalsIgnoreCase(userType)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html>

<head>

    <title>Admin Dashboard</title>

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
            width: 94%;
            margin: 35px auto;
        }

        h1 {
            margin-bottom: 25px;
        }

        .message {
            background: #d1e7dd;
            color: #0f5132;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .cards {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            flex: 1;
            box-shadow: 0 3px 10px rgba(0,0,0,0.10);
        }

        .card h3 {
            margin-top: 0;
        }

        .table-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.10);
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
            padding: 11px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .remove-btn {
            background: #dc3545;
            color: white;
            border: none;
            padding: 7px 12px;
            border-radius: 5px;
            cursor: pointer;
        }

        .remove-btn:hover {
            background: #bb2d3b;
        }

        .status-active {
            color: #198754;
            font-weight: bold;
        }

        .status-removed {
            color: #dc3545;
            font-weight: bold;
        }

        .status-stock {
            color: #fd7e14;
            font-weight: bold;
        }

    </style>

</head>

<body>


<div class="navbar">

    <h2>Campus Resource Marketplace - Admin</h2>

    <div>
        <a href="admin.jsp">Admin Home</a>
        <a href="LogoutServlet">Logout</a>
    </div>

</div>


<div class="container">

    <h1>Admin Dashboard</h1>


<%
    if (message != null && !message.isEmpty()) {
%>

    <div class="message">
        <%= message %>
    </div>

<%
    }
%>


    <!-- STUDENT SECTION -->

    <h2>Student Details</h2>

    <div class="table-box">

        <table>

            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Department</th>
                <th>Year</th>
                <th>Phone</th>
                <th>Role</th>
            </tr>

<%
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

        String studentSql =
            "SELECT id, name, email, department, year, phone, role " +
            "FROM students ORDER BY id DESC";

        ps = con.prepareStatement(studentSql);

        rs = ps.executeQuery();

        while (rs.next()) {
%>

            <tr>

                <td>
                    <%= rs.getInt("id") %>
                </td>

                <td>
                    <%= rs.getString("name") %>
                </td>

                <td>
                    <%= rs.getString("email") %>
                </td>

                <td>
                    <%= rs.getString("department") %>
                </td>

                <td>
                    <%= rs.getString("year") %>
                </td>

                <td>
                    <%= rs.getString("phone") %>
                </td>

                <td>
                    <%= rs.getString("role") %>
                </td>

            </tr>

<%
        }

    } catch (Exception e) {
%>

            <tr>
                <td colspan="7">
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


    <!-- RESOURCE SECTION -->

    <h2>All Resources</h2>

    <div class="table-box">

        <table>

            <tr>
                <th>ID</th>
                <th>Resource</th>
                <th>Category</th>
                <th>Seller</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Available</th>
                <th>Status</th>
                <th>Action</th>
            </tr>


<%
    Connection con2 = null;
    PreparedStatement ps2 = null;
    ResultSet rs2 = null;

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");

        con2 = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/campus_resource",
            "root",
            "Chither@2006"
        );

        String resourceSql =
            "SELECT r.id, r.resource_name, r.category, " +
            "r.price, r.quantity, r.available_quantity, r.status, " +
            "s.name AS seller_name " +
            "FROM resources r " +
            "JOIN students s ON r.student_id = s.id " +
            "ORDER BY r.id DESC";

        ps2 = con2.prepareStatement(resourceSql);

        rs2 = ps2.executeQuery();

        while (rs2.next()) {

            String resourceStatus = rs2.getString("status");

%>

            <tr>

                <td>
                    <%= rs2.getInt("id") %>
                </td>

                <td>
                    <%= rs2.getString("resource_name") %>
                </td>

                <td>
                    <%= rs2.getString("category") %>
                </td>

                <td>
                    <%= rs2.getString("seller_name") %>
                </td>

                <td>
                    ?<%= String.format("%.2f",
                        rs2.getDouble("price")) %>
                </td>

                <td>
                    <%= rs2.getInt("quantity") %>
                </td>

                <td>
                    <%= rs2.getInt("available_quantity") %>
                </td>

                <td>

<%
                if ("ACTIVE".equalsIgnoreCase(resourceStatus)) {
%>

                    <span class="status-active">
                        ACTIVE
                    </span>

<%
                } else if ("REMOVED".equalsIgnoreCase(resourceStatus)) {
%>

                    <span class="status-removed">
                        REMOVED
                    </span>

<%
                } else {
%>

                    <span class="status-stock">
                        <%= resourceStatus %>
                    </span>

<%
                }
%>

                </td>

                <td>

<%
                if (!"REMOVED".equalsIgnoreCase(resourceStatus)) {
%>

                    <form action="DeleteResourceServlet" method="post"
                            onsubmit="return confirm('Are you sure you want to remove this resource?');">

                            <input type="hidden"
                                    name="id"
                                    value="<%= rs.getInt("id") %>">

                            <button type="submit">
                                            Remove
                            </button>

                    </form>

<%
                } else {
%>

                    Removed

<%
                }
%>

                </td>

            </tr>

<%
        }

    } catch (Exception e) {
%>

            <tr>
                <td colspan="9">
                    Database error: <%= e.getMessage() %>
                </td>
            </tr>

<%
    } finally {

        try {
            if (rs2 != null) rs2.close();
        } catch (Exception e) {}

        try {
            if (ps2 != null) ps2.close();
        } catch (Exception e) {}

        try {
            if (con2 != null) con2.close();
        } catch (Exception e) {}

    }
%>

        </table>

    </div>

</div>

</body>

</html>