package com.inspector.servlet;

import com.inspector.util.GeminiService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/analyzeCode")
public class CodeAnalysisServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String language = request.getParameter("language");
        String codeSnippet = request.getParameter("code");

        String prompt = "Analyze this " + language + " code for bugs: " + codeSnippet + ". Explain the issue clearly.";
        String aiJsonResponse = GeminiService.askAI(prompt);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(aiJsonResponse);
    }
}