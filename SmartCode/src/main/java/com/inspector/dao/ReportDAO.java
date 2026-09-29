package com.inspector.dao;

import com.inspector.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ReportDAO {

    public boolean saveReport(String username, String language, String mode, String sourceCode, String aiResponse) {
        String sql = "INSERT INTO inspection_reports (username, language, inspection_mode, source_code, ai_response) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, language);
            stmt.setString(3, mode);
            stmt.setString(4, sourceCode);
            stmt.setString(5, aiResponse);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}