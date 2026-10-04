import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Check empty fields
        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {

            response.sendRedirect(
                "admin-login.jsp?error=Please enter email and password"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            // Connect to MySQL
            con = DBConnection.getConnection();

            // Check only ADMIN account
            String sql =
                "SELECT id, name, email, department, year, phone, role " +
                "FROM students " +
                "WHERE email = ? AND password = ? AND role = 'ADMIN'";

            ps = con.prepareStatement(sql);

            ps.setString(1, email.trim());
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {

                // Create session
                HttpSession session = request.getSession();

                session.setAttribute(
                    "userId",
                    rs.getInt("id")
                );

                session.setAttribute(
                    "studentName",
                    rs.getString("name")
                );

                session.setAttribute(
                    "email",
                    rs.getString("email")
                );

                session.setAttribute(
                    "department",
                    rs.getString("department")
                );

                // Your database year column is INTEGER,
                // so getString() safely converts it to String.
                session.setAttribute(
                    "year",
                    rs.getString("year")
                );

                session.setAttribute(
                    "userType",
                    "ADMIN"
                );

                // Login successful
                response.sendRedirect("admin.jsp");

            } else {

                // Invalid admin login
                response.sendRedirect(
                    "admin-login.jsp?error=Invalid admin email or password"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin-login.jsp?error=Database error. Please try again."
            );

        } finally {

            // Close ResultSet
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }

            // Close PreparedStatement
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }

            // Close Connection
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // If someone opens AdminLoginServlet directly,
        // show the admin login page.
        response.sendRedirect("admin-login.jsp");
    }
}