package com.inspector.controller;

import com.inspector.util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String userInput = request.getParameter("username");
        if (userInput == null || userInput.trim().isEmpty()) {
            userInput = request.getParameter("email");
        }
        
        String password = request.getParameter("password");

        if (userInput == null || password == null || userInput.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=invalid");
            return;
        }

        String sql = "SELECT id, username, role FROM users WHERE (email = ? OR username = ?) AND password = ?";

        try (Connection conn = DBConnection.getConnection()) {
            
            if (conn == null) {
                response.sendRedirect("login.jsp?error=db_error");
                return;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, userInput.trim());
                ps.setString(2, userInput.trim());
                ps.setString(3, password.trim());

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int userId = rs.getInt("id");
                        String username = rs.getString("username");
                        String userRole = rs.getString("role");

                        if (userRole == null || userRole.trim().isEmpty()) {
                            userRole = "user";
                        }

                        HttpSession session = request.getSession(true);
                        session.setAttribute("userId", userId);
                        session.setAttribute("username", username);
                        session.setAttribute("userRole", userRole.toLowerCase());

                        response.sendRedirect("index.jsp");
                    } else {
                        response.sendRedirect("login.jsp?error=invalid");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=invalid");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}