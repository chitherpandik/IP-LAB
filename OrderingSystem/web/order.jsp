<%-- 
    Document   : order
    Created on : 3 Sep, 2026, 2:59:23 PM
    Author     : 24uad076
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Order Details</title>
</head>

<body>

<h2>Order Details</h2>

<%

    Connection con = null;
    PreparedStatement pstmt = null;
    Statement stmt = null;
    ResultSet rs = null;

    try
    {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        String price = request.getParameter("price");

        String payment = request.getParameter("payment");


        Class.forName("com.mysql.cj.jdbc.Driver");


        con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mysql?useSSL=false&allowPublicKeyRetrieval=true",
                "root",
                "test@123"
        );


        String sql =
                "INSERT INTO `order` " +
                "(name,email,phone,address,price,payment) " +
                "VALUES (?,?,?,?,?,?)";


        pstmt = con.prepareStatement(sql);


        pstmt.setString(1, name);
        pstmt.setString(2, email);
        pstmt.setString(3, phone);
        pstmt.setString(4, address);
        pstmt.setInt(5, Integer.parseInt(price));
        pstmt.setString(6, payment);


        int res = pstmt.executeUpdate();


        if (res > 0)
        {
            out.println("<h1>Order Placed Successfully</h1>");
            out.println("<h2>Order Details</h2>");
            out.println("<p>Name: " + name + "</p>");
            out.println("<p>Email: " + email + "</p>");
            out.println("<p>Phone Number: " + phone + "</p>");
            out.println("<p>Address: " + address + "</p>");
            out.println("<p>Order Price: ₹" + price + "</p>");
            out.println("<p>Payment Type: " + payment + "</p>");
        }
        out.println("<hr>");
        out.println("<h2>All Order Details</h2>");
        stmt = con.createStatement();
        rs = stmt.executeQuery("SELECT * FROM `order`");
        out.println("<table border='1' cellpadding='5'>");
        out.println("<tr>");
        out.println("<th>User Name</th>");
        out.println("<th>Email</th>");
        out.println("<th>Phone Number</th>");
        out.println("<th>Address</th>");
        out.println("<th>Order Price</th>");
        out.println("<th>Payment Type</th>");
        out.println("</tr>");
        while (rs.next())
        {
            String Name =rs.getString("name");
            String Email =rs.getString("email");
            String PhoneNumber =rs.getString("phone");
            String Address =rs.getString("address");
            int PriceAmount =rs.getInt("price");
            String PaymentType =rs.getString("payment");
            out.println("<tr>");
            out.println("<td>" + Name + "</td>");
            out.println("<td>" + Email + "</td>");
            out.println("<td>" + PhoneNumber + "</td>");
            out.println("<td>" + Address + "</td>");
            out.println("<td>₹" + PriceAmount + "</td>");
            out.println("<td>" + PaymentType + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
        out.println("<br><br>");
        out.println(
                "<a href='index.html'>Place Another Order</a>"
        );


    }

    catch (ClassNotFoundException e)
    {

        out.println("<h2>Driver Error</h2>");

        out.println(
                "<p>" + e.getMessage() + "</p>"
        );

    }

    catch (NumberFormatException e)
    {

        out.println("<h2>Price Error</h2>");

        out.println(
                "<p>Please enter a valid price.</p>"
        );

    }

    catch (SQLException e)
    {

        out.println("<h2>Database Error</h2>");

        out.println(
                "<p>" + e.getMessage() + "</p>"
        );

    }

    finally
    {

        try
        {

            if (rs != null)
            {
                rs.close();
            }

            if (stmt != null)
            {
                stmt.close();
            }

            if (pstmt != null)
            {
                pstmt.close();
            }

            if (con != null)
            {
                con.close();
            }

        }

        catch (SQLException e)
        {

            out.println(
                    "<p>" + e.getMessage() + "</p>"
            );

        }

    }

%>

</body>

</html>