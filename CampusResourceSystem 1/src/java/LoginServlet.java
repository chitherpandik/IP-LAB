import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {

            response.sendRedirect("login.jsp?error=Please enter email and password");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            String sql =
                "SELECT id, name, email, department, year, role " +
                "FROM students " +
                "WHERE email = ? AND password = ?";

            ps = con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            rs = ps.executeQuery();

            if (rs.next()) {

                int userId = rs.getInt("id");

                String name = rs.getString("name");
                String userEmail = rs.getString("email");
                String department = rs.getString("department");
                String year = rs.getString("year");
                String role = rs.getString("role");

                HttpSession session = request.getSession();

                session.setAttribute("userId", userId);
                session.setAttribute("studentName", name);
                session.setAttribute("email", userEmail);
                session.setAttribute("department", department);
                session.setAttribute("year", year);
                session.setAttribute("userType", role);

                if ("ADMIN".equalsIgnoreCase(role)) {

                    response.sendRedirect("admin.jsp");

                } else {

                    response.sendRedirect("dashboard.jsp");
                }

            } else {

                response.sendRedirect(
                    "login.jsp?error=Invalid email or password"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "login.jsp?error=Database error. Please try again."
            );

        } finally {

            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {}

            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {}

            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {}
        }
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("login.jsp");
    }
}