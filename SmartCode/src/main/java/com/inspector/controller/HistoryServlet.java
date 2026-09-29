package com.inspector.controller;

import com.inspector.util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/HistoryServlet")
public class HistoryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        List<Map<String, Object>> historyList = new ArrayList<>();

        String sql = "SELECT id, language, mode, source_code, analysis_result, created_at " +
                     "FROM inspection_history ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("language", rs.getString("language"));
                row.put("mode", rs.getString("mode"));
                row.put("source_code", rs.getString("source_code"));
                row.put("analysis_result", rs.getString("analysis_result"));
                row.put("created_at", rs.getTimestamp("created_at"));
                historyList.add(row);
            }

        } catch (Exception e) {
            System.err.println("[HistoryServlet Error] Database query failed:");
            e.printStackTrace();
        }

        request.setAttribute("historyList", historyList);
        request.getRequestDispatcher("history.jsp").forward(request, response);
    }
}