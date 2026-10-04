import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddResourceServlet extends HttpServlet {

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");

            return;
        }


        int studentId =
                (Integer) session.getAttribute("userId");


        String resourceName =
                request.getParameter("resourceName");

        String category =
                request.getParameter("category");

        String description =
                request.getParameter("description");

        String priceValue =
                request.getParameter("price");

        String quantityValue =
                request.getParameter("quantity");


        // Check fields
        if (resourceName == null ||
            category == null ||
            description == null ||
            priceValue == null ||
            quantityValue == null ||
            resourceName.trim().isEmpty() ||
            category.trim().isEmpty() ||
            priceValue.trim().isEmpty() ||
            quantityValue.trim().isEmpty()) {

            response.sendRedirect(
                    "add-resource.jsp?error=Please fill all required fields"
            );

            return;
        }


        double price;

        int quantity;


        try {

            price = Double.parseDouble(priceValue);

            quantity = Integer.parseInt(quantityValue);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "add-resource.jsp?error=Invalid price or quantity"
            );

            return;
        }


        // Validate values
        if (price <= 0) {

            response.sendRedirect(
                    "add-resource.jsp?error=Price must be greater than 0"
            );

            return;
        }


        if (quantity <= 0) {

            response.sendRedirect(
                    "add-resource.jsp?error=Quantity must be greater than 0"
            );

            return;
        }


        Connection con = null;
        PreparedStatement ps = null;


        try {

            con = DBConnection.getConnection();


            String sql =
                    "INSERT INTO resources " +
                    "(student_id, resource_name, category, description, " +
                    "price, quantity, available_quantity, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, 'ACTIVE')";


            ps = con.prepareStatement(sql);


            ps.setInt(1, studentId);

            ps.setString(2, resourceName);

            ps.setString(3, category);

            ps.setString(4, description);

            ps.setDouble(5, price);

            ps.setInt(6, quantity);

            // Initially all quantity is available
            ps.setInt(7, quantity);


            int result =
                    ps.executeUpdate();


            if (result > 0) {

                response.sendRedirect(
                        "resources.jsp?success=Resource added successfully"
                );

            } else {

                response.sendRedirect(
                        "add-resource.jsp?error=Unable to add resource"
                );
            }


        } catch (Exception e) {

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Add Resource Error</h2>"
            );

            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>"
            );

            response.getWriter().println(
                    "<a href='add-resource.jsp'>Back</a>"
            );


        } finally {

            try {

                if (ps != null) {
                    ps.close();
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