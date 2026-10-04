import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DeleteResourceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check admin login
        if (session == null ||
            !"ADMIN".equalsIgnoreCase(
                String.valueOf(session.getAttribute("userType")))) {

            response.sendRedirect("admin-login.jsp");
            return;
        }

        String idValue = request.getParameter("id");

        if (idValue == null || idValue.trim().isEmpty()) {

            response.sendRedirect(
                "admin.jsp?error=Invalid resource"
            );
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {

            int resourceId = Integer.parseInt(idValue);

            con = DBConnection.getConnection();

            /*
             * Soft delete:
             * Resource is not physically deleted.
             * Its status is changed to REMOVED.
             */
            String sql =
                "UPDATE resources " +
                "SET status = 'REMOVED' " +
                "WHERE id = ?";

            ps = con.prepareStatement(sql);

            ps.setInt(1, resourceId);

            int rows = ps.executeUpdate();

            if (rows > 0) {

                response.sendRedirect(
                    "admin.jsp?success=Resource removed successfully"
                );

            } else {

                response.sendRedirect(
                    "admin.jsp?error=Resource not found"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                "admin.jsp?error=Invalid resource ID"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "admin.jsp?error=Unable to remove resource"
            );

        } finally {

            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception e) {
            }

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

        response.sendRedirect("admin.jsp");
    }
}