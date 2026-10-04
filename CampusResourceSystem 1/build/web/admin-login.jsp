<!DOCTYPE html>
<html>

<head>

    <title>Admin Login</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .container {
            width: 400px;
            margin: 100px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.15);
        }

        h1 {
            text-align: center;
            margin-bottom: 10px;
        }

        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 7px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            width: 100%;
            padding: 13px;
            margin-top: 25px;
            background: #222;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #000;
        }

        .error {
            background: #f8d7da;
            color: #842029;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #333;
            text-decoration: none;
        }

    </style>

</head>

<body>


<div class="container">

    <h1>Admin Login</h1>

    <div class="subtitle">
        Campus Resource Marketplace
    </div>


<%
    String error = request.getParameter("error");

    if (error != null && !error.isEmpty()) {
%>

    <div class="error">
        <%= error %>
    </div>

<%
    }
%>


    <form action="AdminLoginServlet" method="post">

        <label for="email">
            Admin Email
        </label>

        <input
            type="email"
            id="email"
            name="email"
            placeholder="Enter admin email"
            required
        >


        <label for="password">
            Password
        </label>

        <input
            type="password"
            id="password"
            name="password"
            placeholder="Enter admin password"
            required
        >


        <button type="submit">
            Admin Login
        </button>

    </form>


    <a class="back" href="login.jsp">
        ? Student Login
    </a>

</div>


</body>

</html>