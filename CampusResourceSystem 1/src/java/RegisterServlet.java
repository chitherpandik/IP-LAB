import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String department = request.getParameter("department");
        String yearValue = request.getParameter("year");
        String phone = request.getParameter("phone");


        // Check required fields
        if (name == null || email == null ||
            password == null || department == null ||
            yearValue == null || phone == null ||
            name.trim().isEmpty() ||
            email.trim().isEmpty() ||
            password.trim().isEmpty() ||
            department.trim().isEmpty() ||
            yearValue.trim().isEmpty() ||
            phone.trim().isEmpty()) {

            response.sendRedirect(
                    "register.jsp?error=Please fill all fields"
            );

            return;
        }


        int year;

        try {

            year = Integer.parseInt(yearValue);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "register.jsp?error=Invalid year"
            );

            return;
        }


        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;

        try {

            con = DBConnection.getConnection();


            // Check whether email already exists
            String checkSql =
                    "SELECT id FROM students WHERE email = ?";

            checkPs = con.prepareStatement(checkSql);

            checkPs.setString(1, email);

            java.sql.ResultSet rs =
                    checkPs.executeQuery();


            if (rs.next()) {

                rs.close();

                response.sendRedirect(
                        "register.jsp?error=Email already registered"
                );

                return;
            }

            rs.close();


            // Insert new student
            String insertSql =
                    "INSERT INTO students " +
                    "(name, email, password, department, year, phone, role) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 'STUDENT')";


            insertPs = con.prepareStatement(insertSql);

            insertPs.setString(1, name);
            insertPs.setString(2, email);
            insertPs.setString(3, password);
            insertPs.setString(4, department);
            insertPs.setInt(5, year);
            insertPs.setString(6, phone);


            int result =
                    insertPs.executeUpdate();


            if (result > 0) {

                response.sendRedirect(
                        "login.jsp?success=Registration successful"
                );

            } else {

                response.sendRedirect(
                        "register.jsp?error=Registration failed"
                );
            }


        } catch (Exception e) {

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Registration Error</h2>"
            );

            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>"
            );

            response.getWriter().println(
                    "<a href='register.jsp'>Back to Register</a>"
            );


        } finally {

            try {

                if (checkPs != null) {
                    checkPs.close();
                }

            } catch (Exception ignored) {}


            try {

                if (insertPs != null) {
                    insertPs.close();
                }

            } catch (Exception ignored) {}


            try {

                if (con != null) {
                    con.close();
                }

            } catch (Exception ignored) {}
        }
    }
}