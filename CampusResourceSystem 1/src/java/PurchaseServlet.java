import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class PurchaseServlet extends HttpServlet {

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        // Check login
        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("login.jsp");

            return;
        }


        int buyerId =
                (Integer) session.getAttribute("userId");


        String resourceIdValue =
                request.getParameter("resourceId");

        String quantityValue =
                request.getParameter("quantity");


        // Check input
        if (resourceIdValue == null ||
            quantityValue == null ||
            resourceIdValue.trim().isEmpty() ||
            quantityValue.trim().isEmpty()) {

            response.sendRedirect(
                    "resources.jsp?error=Please select resource and quantity"
            );

            return;
        }


        int resourceId;
        int purchaseQuantity;


        try {

            resourceId =
                    Integer.parseInt(resourceIdValue);

            purchaseQuantity =
                    Integer.parseInt(quantityValue);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "resources.jsp?error=Invalid resource or quantity"
            );

            return;
        }


        if (purchaseQuantity <= 0) {

            response.sendRedirect(
                    "resources.jsp?error=Quantity must be greater than 0"
            );

            return;
        }


        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement purchasePs = null;
        PreparedStatement updatePs = null;

        ResultSet rs = null;


        try {

            con = DBConnection.getConnection();

            /*
             * Start transaction.
             *
             * This makes sure the purchase and
             * quantity update happen together.
             */

            con.setAutoCommit(false);


            // Get resource information
            String checkSql =
                    "SELECT student_id, price, available_quantity, status " +
                    "FROM resources " +
                    "WHERE id = ? " +
                    "FOR UPDATE";


            checkPs =
                    con.prepareStatement(checkSql);

            checkPs.setInt(
                    1,
                    resourceId
            );


            rs = checkPs.executeQuery();


            if (!rs.next()) {

                con.rollback();

                response.sendRedirect(
                        "resources.jsp?error=Resource not found"
                );

                return;
            }


            int sellerId =
                    rs.getInt("student_id");


            double price =
                    rs.getDouble("price");


            int availableQuantity =
                    rs.getInt("available_quantity");


            String status =
                    rs.getString("status");


            rs.close();


            // Student cannot buy their own resource
            if (sellerId == buyerId) {

                con.rollback();

                response.sendRedirect(
                        "resources.jsp?error=You cannot buy your own resource"
                );

                return;
            }


            // Check resource status
            if (!"ACTIVE".equalsIgnoreCase(status)) {

                con.rollback();

                response.sendRedirect(
                        "resources.jsp?error=Resource is not available"
                );

                return;
            }


            // Check available quantity
            if (purchaseQuantity > availableQuantity) {

                con.rollback();

                response.sendRedirect(
                        "resources.jsp?error=Not enough quantity available"
                );

                return;
            }


            // Calculate total amount
            double totalAmount =
                    price * purchaseQuantity;


            /*
             * Insert purchase record
             */

            String purchaseSql =
                    "INSERT INTO purchases " +
                    "(buyer_id, resource_id, quantity, price, " +
                    "total_amount, status) " +
                    "VALUES (?, ?, ?, ?, ?, 'PURCHASED')";


            purchasePs =
                    con.prepareStatement(purchaseSql);


            purchasePs.setInt(
                    1,
                    buyerId
            );

            purchasePs.setInt(
                    2,
                    resourceId
            );

            purchasePs.setInt(
                    3,
                    purchaseQuantity
            );

            purchasePs.setDouble(
                    4,
                    price
            );

            purchasePs.setDouble(
                    5,
                    totalAmount
            );


            purchasePs.executeUpdate();


            /*
             * Update available quantity
             */

            int newAvailableQuantity =
                    availableQuantity - purchaseQuantity;


            String newStatus =
                    newAvailableQuantity == 0
                    ? "OUT_OF_STOCK"
                    : "ACTIVE";


            String updateSql =
                    "UPDATE resources " +
                    "SET available_quantity = ?, status = ? " +
                    "WHERE id = ?";


            updatePs =
                    con.prepareStatement(updateSql);


            updatePs.setInt(
                    1,
                    newAvailableQuantity
            );

            updatePs.setString(
                    2,
                    newStatus
            );

            updatePs.setInt(
                    3,
                    resourceId
            );


            updatePs.executeUpdate();


            /*
             * Complete transaction
             */

            con.commit();


            response.sendRedirect(
                    "purchase-history.jsp?success=Purchase successful"
            );


        } catch (Exception e) {

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception ignored) {}


            response.setContentType("text/html");

            response.getWriter().println(
                    "<h2>Purchase Error</h2>"
            );

            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>"
            );

            response.getWriter().println(
                    "<a href='resources.jsp'>Back to Resources</a>"
            );


        } finally {

            try {

                if (rs != null) {
                    rs.close();
                }

            } catch (Exception ignored) {}


            try {

                if (checkPs != null) {
                    checkPs.close();
                }

            } catch (Exception ignored) {}


            try {

                if (purchasePs != null) {
                    purchasePs.close();
                }

            } catch (Exception ignored) {}


            try {

                if (updatePs != null) {
                    updatePs.close();
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