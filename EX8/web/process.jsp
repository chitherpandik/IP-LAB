<%-- 
    Document   : process
    Created on : 3 Sep, 2026, 2:11:29 PM
    Author     : 24uad076
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration Details</title>
    </head>
    <body>
        <h1>User Registration Details</h1>
        <%
            
        String UserName=request.getParameter("username");
        String Password=request.getParameter("password");
        String Email=request.getParameter("email");
        String Creditcard=request.getParameter("ccn");
        String PhoneNumber=request.getParameter("phone");
        
            %>
            <p><strong>User Name:</strong><%=UserName%></p>
            <p><strong>Password:</strong><%=Password%></p>
            <p><strong>Email:</strong><%=Email%></p>
            <p><strong>Credit card Number:</strong><%=Creditcard%></p>
            <p><strong>Phone Number:</strong><%=PhoneNumber%></p>
            
    </body>
</html>
