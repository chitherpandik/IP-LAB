<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String studentName =
            (String) session.getAttribute("studentName");

    String email =
            (String) session.getAttribute("email");

    String department =
            (String) session.getAttribute("department");

    String year =
            (String) session.getAttribute("year");

    String userType =
            (String) session.getAttribute("userType");

    if (studentName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <title>Student Dashboard</title>

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

        .welcome {
            background: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.10);
        }

        .welcome h1 {
            margin-top: 0;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.10);
        }

        .card h3 {
            margin-top: 0;
        }

        .card p {
            color: #666;
        }

        .card a {
            display: inline-block;
            margin-top: 10px;
            padding: 10px 15px;
            background: #198754;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .card a:hover {
            background: #157347;
        }

        .profile {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.10);
        }

        .profile h2 {
            margin-top: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        .label {
            font-weight: bold;
            width: 200px;
        }

        @media (max-width: 800px) {

            .cards {
                grid-template-columns: 1fr;
            }

            .navbar {
                flex-direction: column;
                gap: 10px;
            }

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

    <div class="welcome">

        <h1>
            Welcome, <%= studentName %>!
        </h1>

        <p>
            Welcome to the Campus Resource Marketplace.
            You can buy and sell resources with other students.
        </p>

    </div>


    <div class="cards">

        <!-- Browse Resources -->

        <div class="card">

            <h3>Browse Resources</h3>

            <p>
                View resources available from other students.
            </p>

            <a href="resources.jsp">
                Browse Resources
            </a>

        </div>


        <!-- Sell Resource -->

        <div class="card">

            <h3>Sell a Resource</h3>

            <p>
                Add your books, notes or other resources
                for sale.
            </p>

            <a href="add-resource.jsp">
                Add Resource
            </a>

        </div>


        <!-- Purchase History -->

        <div class="card">

            <h3>My Purchases</h3>

            <p>
                View all resources you have purchased.
            </p>

            <a href="purchase-history.jsp">
                View Purchases
            </a>

        </div>

    </div>


    <!-- My Resources -->

    <div class="card" style="margin-bottom: 30px;">

        <h3>My Resources</h3>

        <p>
            View the resources that you have added
            to the marketplace.
        </p>

        <a href="resources.jsp?mine=true">
            My Resources
        </a>

    </div>


    <!-- Profile -->

    <div class="profile">

        <h2>My Profile</h2>

        <table>

            <tr>

                <td class="label">
                    Name
                </td>

                <td>
                    <%= studentName %>
                </td>

            </tr>


            <tr>

                <td class="label">
                    Email
                </td>

                <td>
                    <%= email %>
                </td>

            </tr>


            <tr>

                <td class="label">
                    Department
                </td>

                <td>
                    <%= department != null ? department : "-" %>
                </td>

            </tr>


            <tr>

                <td class="label">
                    Year
                </td>

                <td>
                    <%= year != null ? year : "-" %>
                </td>

            </tr>


            <tr>

                <td class="label">
                    Account Type
                </td>

                <td>
                    <%= userType != null ? userType : "STUDENT" %>
                </td>

            </tr>

        </table>

    </div>

</div>

</body>

</html>