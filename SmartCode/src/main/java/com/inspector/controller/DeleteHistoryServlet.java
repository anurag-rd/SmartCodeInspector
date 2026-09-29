package com.inspector.controller;

import com.inspector.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/DeleteHistoryServlet")
public class DeleteHistoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userRole = (session != null) ? (String) session.getAttribute("userRole") : null;

        // Verify Admin Privileges
        if (userRole == null || !userRole.equalsIgnoreCase("admin")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized: Admin access required.");
            return;
        }

        String historyIdParam = request.getParameter("id");
        if (historyIdParam != null && !historyIdParam.trim().isEmpty()) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM inspection_history WHERE id = ?")) {

                ps.setInt(1, Integer.parseInt(historyIdParam));
                int rows = ps.executeUpdate();
                System.out.println("[DeleteHistoryServlet] Admin deleted history ID: " + historyIdParam + ", rows affected: " + rows);

            } catch (Exception e) {
                System.err.println("[DeleteHistoryServlet Error] Deletion failed:");
                e.printStackTrace();
            }
        }

        response.sendRedirect("HistoryServlet");
    }
}