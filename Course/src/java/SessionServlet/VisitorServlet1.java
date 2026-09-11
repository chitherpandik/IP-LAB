package SessionServlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class VisitorServlet1 extends HttpServlet {

    static int count = 0;

    protected void processRequest(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        // Increase count only for a new session
        if (session.isNew()) {
            count++;
        }

        try (PrintWriter out = response.getWriter()) {

            String name = request.getParameter("name");
            String course = request.getParameter("course");

            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Visitor Servlet</title>");
            out.println("</head>");
            out.println("<body>");

            out.println("<h1>Servlet VisitorServlet</h1>");
            out.println("<p>Name: " + name + "</p>");
            out.println("<p>Course: " + course + "</p>");

            out.println("<p>Unique Visitor: " + count + "</p>");

            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Visitor Servlet";
    }
}