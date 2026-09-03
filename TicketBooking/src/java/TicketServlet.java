/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

/**
 *
 * @author 24uad076
 */
public class TicketServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        try {

            String name = request.getParameter("name");
            String movie = request.getParameter("moviename");
            String time = request.getParameter("time");
            String date = request.getParameter("date");
            String number = request.getParameter("number");

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/mysql?useSSL=false&allowPublicKeyRetrieval=true",
                    "root",
                    "test@123"
            );

            // INSERT DATA
            String sql = "INSERT INTO tickets1(name,movie,time,date,numbers) VALUES(?,?,?,?,?)";

            PreparedStatement pstmt = con.prepareStatement(sql);

            pstmt.setString(1, name);
            pstmt.setString(2, movie);
            pstmt.setString(3, time);
            pstmt.setString(4, date);
            pstmt.setInt(5, Integer.parseInt(number));

            int res = pstmt.executeUpdate();

            // OUTPUT
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Ticket Details</title>");
            out.println("</head>");
            out.println("<body>");

            if (res > 0) {

                out.println("<h1>Ticket Booked Successfully</h1>");

                out.println("<h2>Ticket Details</h2>");

                out.println("<p>Name: " + name + "</p>");
                out.println("<p>Movie Name: " + movie + "</p>");
                out.println("<p>Time: " + time + "</p>");
                out.println("<p>Date: " + date + "</p>");
                out.println("<p>Number of Seats: " + number + "</p>");
            }

            out.println("<hr>");

            out.println("<h2>All Ticket Details</h2>");

            Statement stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT * FROM tickets1");

            out.println("<table border='1' cellpadding='5'>");

            out.println("<tr>");
            out.println("<th>User Name</th>");
            out.println("<th>Movie Name</th>");
            out.println("<th>Time</th>");
            out.println("<th>Date</th>");
            out.println("<th>Number of Seats</th>");
            out.println("</tr>");

            while (rs.next()) {

                String Name = rs.getString("name");
                String Movie = rs.getString("movie");
                String Time = rs.getString("time");
                String Date = rs.getString("date");
                int Seat = rs.getInt("numbers");

                out.println("<tr>");

                out.println("<td>" + Name + "</td>");
                out.println("<td>" + Movie + "</td>");
                out.println("<td>" + Time + "</td>");
                out.println("<td>" + Date + "</td>");
                out.println("<td>" + Seat + "</td>");

                out.println("</tr>");
            }

            out.println("</table>");

            out.println("<br><br>");

            out.println("<a href='index.html'>Book Another Ticket</a>");

            out.println("</body>");
            out.println("</html>");

            rs.close();
            stmt.close();
            pstmt.close();
            con.close();

        } catch (ClassNotFoundException | NumberFormatException | SQLException e) {

            out.println("<h2>Error:</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);

    }

    @Override
    public String getServletInfo() {
        return "Ticket Booking Servlet";
    }
}