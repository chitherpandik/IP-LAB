<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int currentUserId =
            (Integer) session.getAttribute("userId");

    String currentUserName =
            (String) session.getAttribute("studentName");

    String mine =
            request.getParameter("mine");

    boolean showMyResources =
            "true".equalsIgnoreCase(mine);


    String dbURL =
            "jdbc:mysql://localhost:3306/campus_resource";

    String dbUser = "root";

    String dbPassword = "Chither@2006";


    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        <%= showMyResources ? "My Resources" : "Campus Resources" %>
    </title>


    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }


        .header {
            background: #1f3c88;
            color: white;
            padding: 18px 5%;

            display: flex;
            justify-content: space-between;
            align-items: center;
        }


        .header h1 {
            margin: 0;
            font-size: 24px;
        }


        .nav a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
            padding: 8px 14px;
            border-radius: 5px;
        }


        .nav a:hover {
            background: rgba(255,255,255,0.15);
        }


        .container {
            width: 92%;
            max-width: 1200px;
            margin: 30px auto;
        }


        .top-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }


        .top-section h2 {
            margin: 0;
            color: #333;
        }


        .actions a {
            display: inline-block;
            padding: 10px 15px;
            margin-left: 5px;
            background: #1f3c88;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }


        .actions a:hover {
            background: #162d66;
        }


        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }


        .success {
            background: #e5f7e5;
            color: #218838;
        }


        .error {
            background: #ffe5e5;
            color: #c62828;
        }


        .table-container {
            background: white;
            border-radius: 8px;
            overflow-x: auto;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }


        table {
            width: 100%;
            border-collapse: collapse;
        }


        th {
            background: #1f3c88;
            color: white;
            padding: 13px;
            text-align: center;
            white-space: nowrap;
        }


        td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }


        tr:hover {
            background: #f8f9fa;
        }


        .price {
            font-weight: bold;
            color: #1f3c88;
        }


        .available {
            color: #218838;
            font-weight: bold;
        }


        .out-stock {
            color: #dc3545;
            font-weight: bold;
        }


        .buy-btn {
            background: #28a745;
            color: white;
            padding: 7px 14px;
            text-decoration: none;
            border-radius: 4px;
        }


        .buy-btn:hover {
            background: #218838;
        }


        .own-resource {
            color: #666;
            font-size: 14px;
            font-weight: bold;
        }


        .removed {
            color: #dc3545;
            font-weight: bold;
        }


        .empty {
            padding: 35px;
            text-align: center;
            color: #666;
        }


        .description {
            max-width: 220px;
            margin: auto;
            color: #666;
            font-size: 14px;
        }


        @media (max-width: 700px) {

            .header {
                display: block;
                text-align: center;
            }

            .nav {
                margin-top: 15px;
            }

            .nav a {
                margin: 3px;
            }

        }

    </style>

</head>


<body>


<!-- HEADER -->

<div class="header">

    <h1>
        Campus Resource Marketplace
    </h1>


    <div class="nav">

        <a href="dashboard.jsp">
            Dashboard
        </a>

        <a href="add-resource.jsp">
            Sell Resource
        </a>

        <a href="purchase-history.jsp">
            My Purchases
        </a>

        <a href="LogoutServlet">
            Logout
        </a>

    </div>

</div>


<div class="container">


    <!-- TOP SECTION -->

    <div class="top-section">

        <h2>

            <%
                if (showMyResources) {
            %>

                My Resources

            <%
                } else {
            %>

                Campus Resources

            <%
                }
            %>

        </h2>


        <div class="actions">

            <% if (showMyResources) { %>

                <a href="resources.jsp">
                    All Resources
                </a>

            <% } else { %>

                <a href="resources.jsp?mine=true">
                    My Resources
                </a>

            <% } %>


            <a href="add-resource.jsp">
                + Add Resource
            </a>

        </div>

    </div>


    <!-- MESSAGES -->

    <%

        String success =
                request.getParameter("success");

        String error =
                request.getParameter("error");


        if (success != null) {

    %>

        <div class="message success">
            <%= success %>
        </div>

    <%

        }


        if (error != null) {

    %>

        <div class="message error">
            <%= error %>
        </div>

    <%

        }

    %>


    <!-- RESOURCE TABLE -->

    <div class="table-container">

        <table>

            <tr>

                <th>ID</th>

                <th>Resource</th>

                <th>Category</th>

                <th>Description</th>

                <th>Seller</th>

                <th>Price</th>

                <th>Total</th>

                <th>Available</th>

                <th>Status</th>

                <th>Action</th>

            </tr>


            <%

                try {

                    Class.forName(
                        "com.mysql.cj.jdbc.Driver"
                    );


                    con =
                        DriverManager.getConnection(
                            dbURL,
                            dbUser,
                            dbPassword
                        );


                    String sql;


                    /*
                     * Show only current student's resources
                     * when ?mine=true is used.
                     */

                    if (showMyResources) {

                        sql =
                            "SELECT r.id, " +
                            "r.resource_name, " +
                            "r.category, " +
                            "r.description, " +
                            "r.price, " +
                            "r.quantity, " +
                            "r.available_quantity, " +
                            "r.status, " +
                            "s.name AS seller_name " +
                            "FROM resources r " +
                            "JOIN students s " +
                            "ON r.student_id = s.id " +
                            "WHERE r.student_id = ? " +
                            "ORDER BY r.id DESC";

                        ps =
                            con.prepareStatement(sql);

                        ps.setInt(
                            1,
                            currentUserId
                        );

                    } else {

                        sql =
                            "SELECT r.id, " +
                            "r.resource_name, " +
                            "r.category, " +
                            "r.description, " +
                            "r.price, " +
                            "r.quantity, " +
                            "r.available_quantity, " +
                            "r.status, " +
                            "s.name AS seller_name " +
                            "FROM resources r " +
                            "JOIN students s " +
                            "ON r.student_id = s.id " +
                            "WHERE r.status <> 'REMOVED' " +
                            "ORDER BY r.id DESC";

                        ps =
                            con.prepareStatement(sql);
                    }


                    rs =
                        ps.executeQuery();


                    boolean hasData = false;


                    while (rs.next()) {

                        hasData = true;


                        int resourceId =
                            rs.getInt("id");


                        String resourceName =
                            rs.getString(
                                "resource_name"
                            );


                        String category =
                            rs.getString(
                                "category"
                            );


                        String description =
                            rs.getString(
                                "description"
                            );


                        String sellerName =
                            rs.getString(
                                "seller_name"
                            );


                        double price =
                            rs.getDouble("price");


                        int quantity =
                            rs.getInt("quantity");


                        int available =
                            rs.getInt(
                                "available_quantity"
                            );


                        String status =
                            rs.getString("status");


                        boolean isOwner =
                            currentUserId ==
                            rs.getInt(
                                "id"
                            );

            %>


            <tr>


                <!-- ID -->

                <td>
                    <%= resourceId %>
                </td>


                <!-- RESOURCE -->

                <td>
                    <strong>
                        <%= resourceName %>
                    </strong>
                </td>


                <!-- CATEGORY -->

                <td>
                    <%= category %>
                </td>


                <!-- DESCRIPTION -->

                <td>

                    <div class="description">

                        <%
                            if (description != null &&
                                !description.trim().isEmpty()) {
                        %>

                            <%= description %>

                        <%
                            } else {
                        %>

                            No description

                        <%
                            }
                        %>

                    </div>

                </td>


                <!-- SELLER -->

                <td>
                    <%= sellerName %>
                </td>


                <!-- PRICE -->

                <td class="price">

                    ?<%= String.format(
                        "%.2f",
                        price
                    ) %>

                </td>


                <!-- TOTAL QUANTITY -->

                <td>
                    <%= quantity %>
                </td>


                <!-- AVAILABLE -->

                <td>

                    <%
                        if (available > 0) {
                    %>

                        <span class="available">
                            <%= available %>
                        </span>

                    <%
                        } else {
                    %>

                        <span class="out-stock">
                            0
                        </span>

                    <%
                        }
                    %>

                </td>


                <!-- STATUS -->

                <td>

                    <%
                        if ("OUT_OF_STOCK"
                            .equalsIgnoreCase(status)) {
                    %>

                        <span class="out-stock">
                            Out of Stock
                        </span>

                    <%
                        } else if ("ACTIVE"
                                   .equalsIgnoreCase(status)) {
                    %>

                        <span class="available">
                            Available
                        </span>

                    <%
                        } else {
                    %>

                        <span class="removed">
                            <%= status %>
                        </span>

                    <%
                        }
                    %>

                </td>


                <!-- ACTION -->

                <td>


                    <%
                        /*
                         * Student's own resource
                         */
                        if (currentUserId ==
                            getStudentId(
                                con,
                                resourceId
                            )) {
                    %>

                        <span class="own-resource">
                            Your Resource
                        </span>


                    <%
                        /*
                         * Resource available for purchase
                         */
                        } else if (
                            available > 0 &&
                            "ACTIVE".equalsIgnoreCase(status)
                        ) {
                    %>

                        <a
                            href="purchase.jsp?resourceId=<%= resourceId %>"
                            class="buy-btn">

                            Buy

                        </a>


                    <%
                        /*
                         * Resource unavailable
                         */
                        } else {
                    %>

                        <span class="out-stock">
                            Not Available
                        </span>

                    <%
                        }
                    %>


                </td>


            </tr>


            <%

                    }


                    if (!hasData) {

            %>


            <tr>

                <td
                    colspan="10"
                    class="empty">

                    <%
                        if (showMyResources) {
                    %>

                        You have not added
                        any resources yet.

                    <%
                        } else {
                    %>

                        No resources are
                        currently available.

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

                <td
                    colspan="10"
                    class="error">

                    Database Error:
                    <%= e.getMessage() %>

                </td>

            </tr>


            <%

                } finally {


                    try {

                        if (rs != null) {
                            rs.close();
                        }

                    } catch (Exception ignored) {}


                    try {

                        if (ps != null) {
                            ps.close();
                        }

                    } catch (Exception ignored) {}


                    try {

                        if (con != null) {
                            con.close();
                        }

                    } catch (Exception ignored) {}

                }

            %>


        </table>

    </div>

</div>

</body>

</html>


<%!

    /*
     * Get seller/student ID for a resource.
     *
     * This is used to prevent a student
     * from buying their own resource.
     */

    private int getStudentId(
            Connection con,
            int resourceId) throws Exception {

        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            String sql =
                "SELECT student_id " +
                "FROM resources " +
                "WHERE id = ?";

            ps =
                con.prepareStatement(sql);

            ps.setInt(
                1,
                resourceId
            );

            rs =
                ps.executeQuery();


            if (rs.next()) {

                return rs.getInt(
                    "student_id"
                );
            }


            return -1;

        } finally {

            try {

                if (rs != null) {
                    rs.close();
                }

            } catch (Exception ignored) {}


            try {

                if (ps != null) {
                    ps.close();
                }

            } catch (Exception ignored) {}
        }
    }

%>