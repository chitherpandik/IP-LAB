<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>

<head>

    <title>Add Resource</title>

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
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.12);
        }

        h1 {
            margin-top: 0;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 12px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        textarea {
            height: 100px;
            resize: vertical;
        }

        button {
            width: 100%;
            margin-top: 25px;
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

        .error {
            background: #f8d7da;
            color: #842029;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 18px;
            color: #333;
            text-decoration: none;
        }

        .note {
            background: #f8f9fa;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            color: #555;
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

    <h1>Add Resource for Sale</h1>

    <div class="note">
        Add a resource that you want to sell to other students.
    </div>


<%
    if (error != null && !error.isEmpty()) {
%>

    <div class="error">
        <%= error %>
    </div>

<%
    }
%>


    <form action="AddResourceServlet" method="post">

        <label for="resourceName">
            Resource Name
        </label>

        <input
            type="text"
            id="resourceName"
            name="resourceName"
            placeholder="Example: Java Programming Book"
            required
        >


        <label for="category">
            Category
        </label>

        <select
            id="category"
            name="category"
            required
        >

            <option value="">Select Category</option>

            <option value="Books">
                Books
            </option>

            <option value="Notes">
                Notes
            </option>

            <option value="Electronics">
                Electronics
            </option>

            <option value="Lab Equipment">
                Lab Equipment
            </option>

            <option value="Stationery">
                Stationery
            </option>

            <option value="Other">
                Other
            </option>

        </select>


        <label for="description">
            Description
        </label>

        <textarea
            id="description"
            name="description"
            placeholder="Enter a short description"
            required
        ></textarea>


        <label for="price">
            Price per Item (?)
        </label>

        <input
            type="number"
            id="price"
            name="price"
            min="0"
            step="0.01"
            placeholder="Example: 250"
            required
        >


        <label for="quantity">
            Quantity
        </label>

        <input
            type="number"
            id="quantity"
            name="quantity"
            min="1"
            placeholder="Example: 5"
            required
        >


        <button type="submit">
            Add Resource
        </button>

    </form>


    <a class="back" href="resources.jsp">
        ? Back to Resources
    </a>

</div>

</body>

</html>