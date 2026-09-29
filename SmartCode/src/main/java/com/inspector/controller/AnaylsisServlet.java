package com.inspector.controller;

import com.inspector.service.GeminiService;
import com.inspector.util.DBConnection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AnalysisServlet")
public class AnaylsisServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private GeminiService geminiService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.geminiService = new GeminiService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Retrieve session user ID
        HttpSession session = request.getSession(false);
        Integer userId = null;
        
        if (session != null) {
            if (session.getAttribute("userId") != null) {
                userId = (Integer) session.getAttribute("userId");
            } else if (session.getAttribute("user_id") != null) {
                userId = (Integer) session.getAttribute("user_id");
            } else if (session.getAttribute("user") != null) {
                Object u = session.getAttribute("user");
                if (u instanceof Integer) userId = (Integer) u;
            }
        }

        // Fallback to User ID 1 if session is unauthenticated
        if (userId == null) {
            userId = 1; 
        }

        String language = request.getParameter("language");
        String mode = request.getParameter("mode");
        String sourceCode = request.getParameter("sourceCode");

        if (sourceCode == null || sourceCode.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Source code cannot be empty.\"}");
            out.flush();
            return;
        }

        try {
            // 2. Query Gemini Service
            String analysisResult = geminiService.analyzeCode(sourceCode, language, mode);

            // 3. Unconditionally save history to MySQL
            saveInspectionHistory(userId, language, mode, sourceCode, analysisResult);

            out.print(analysisResult);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(String.format("{\"error\": \"%s\"}", escapeJsonString(e.getMessage())));
        } finally {
            out.flush();
        }
    }

    private void saveInspectionHistory(int userId, String language, String mode, String sourceCode, String resultJson) {
        String sql = "INSERT INTO inspection_history " +
                     "(user_id, language, mode, severity, bug_count, source_code, analysis_result, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, language);
            ps.setString(3, mode);
            ps.setString(4, "MEDIUM");
            ps.setInt(5, 0);
            ps.setString(6, sourceCode);
            ps.setString(7, resultJson);

            int rows = ps.executeUpdate();
            System.out.println("[AnalysisServlet SUCCESS] Recorded " + rows + " inspection row into DB for User ID: " + userId);

        } catch (Exception e) {
            System.err.println("[AnalysisServlet DB ERROR] Insert failed:");
            e.printStackTrace();
        }
    }

    private String escapeJsonString(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", " ")
                    .replace("\r", " ");
    }
}