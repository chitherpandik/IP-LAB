<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Login - Campus Resource Marketplace</title>

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
            padding: 20px;
            text-align: center;
        }

        .header h1 {
            margin: 0;
        }

        .header p {
            margin: 8px 0 0;
        }

        .container {
            width: 400px;
            max-width: 90%;
            margin: 60px auto;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.12);
        }

        .card h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            color: #333;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
        }

        input:focus {
            border-color: #1f3c88;
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #1f3c88;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #162d66;
        }

        .message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            text-align: center;
        }

        .error {
            background: #ffe5e5;
            color: #c62828;
        }

        .success {
            background: #e5f7e5;
            color: #218838;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
        }

        .register-link a {
            color: #1f3c88;
            text-decoration: none;
            font-weight: bold;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .back {
            text-align: center;
            margin-top: 15px;
        }

        .back a {
            color: #555;
            text-decoration: none;
        }

    </style>

</head>

<body>


<div class="header">

    <h1>Campus Resource Marketplace</h1>

    <p>Buy and Sell Resources Within Your Campus</p>

</div>


<div class="container">

    <div class="card">

        <h2>Student Login</h2>


        <%
            String error =
                    request.getParameter("error");

            String success =
                    request.getParameter("success");


            if (error != null) {
        %>

            <div class="message error">
                <%= error %>
            </div>

        <%
            }


            if (success != null) {
        %>

            <div class="message success">
                <%= success %>
            </div>

        <%
            }
        %>


        <form action="LoginServlet" method="post">


            <label for="email">
                Email
            </label>

            <input
                type="email"
                id="email"
                name="email"
                placeholder="Enter your email"
                required
            >


            <label for="password">
                Password
            </label>

            <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter your password"
                required
            >


            <button type="submit">
                Login
            </button>

        </form>


        <div class="register-link">

            Don't have an account?

            <a href="register.jsp">
                Register
            </a>

        </div>


        <div class="back">

            <a href="index.html">
                ? Back to Home
            </a>

        </div>

    </div>

</div>

</body>
</html>