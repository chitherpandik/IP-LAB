<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Register - Campus Resource Marketplace</title>

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
            width: 550px;
            max-width: 92%;
            margin: 35px auto;
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

        .row {
            display: flex;
            gap: 15px;
        }

        .field {
            flex: 1;
        }

        label {
            display: block;
            margin-bottom: 7px;
            color: #333;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 11px;
            margin-bottom: 16px;
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
            margin-bottom: 18px;
            border-radius: 5px;
            text-align: center;
            background: #ffe5e5;
            color: #c62828;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
        }

        .login-link a {
            color: #1f3c88;
            text-decoration: none;
            font-weight: bold;
        }

        .login-link a:hover {
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

        @media (max-width: 600px) {

            .row {
                display: block;
            }

        }

    </style>

</head>

<body>


<div class="header">

    <h1>Campus Resource Marketplace</h1>

    <p>Create your student account</p>

</div>


<div class="container">

    <div class="card">

        <h2>Student Registration</h2>


        <%
            String error =
                    request.getParameter("error");

            if (error != null) {
        %>

            <div class="message">
                <%= error %>
            </div>

        <%
            }
        %>


        <form action="RegisterServlet" method="post">


            <label for="name">
                Full Name
            </label>

            <input
                type="text"
                id="name"
                name="name"
                placeholder="Enter your full name"
                required
            >


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
                placeholder="Create a password"
                required
            >


            <label for="department">
                Department
            </label>

            <input
                type="text"
                id="department"
                name="department"
                placeholder="Example: AIDS"
                required
            >


            <div class="row">

                <div class="field">

                    <label for="year">
                        Year
                    </label>

                    <input
                        type="number"
                        id="year"
                        name="year"
                        min="1"
                        max="6"
                        placeholder="2"
                        required
                    >

                </div>


                <div class="field">

                    <label for="phone">
                        Phone Number
                    </label>

                    <input
                        type="tel"
                        id="phone"
                        name="phone"
                        placeholder="Enter phone number"
                        required
                    >

                </div>

            </div>


            <button type="submit">
                Create Account
            </button>

        </form>


        <div class="login-link">

            Already have an account?

            <a href="login.jsp">
                Login
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