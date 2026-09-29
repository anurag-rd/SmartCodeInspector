package com.inspector.service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class GeminiService {

    // Insert your valid Gemini API Key from Google AI Studio
    private static final String API_KEY = "AQ.Ab8RN6Jc2BPBKBQ8r4UkEfFRvFoXLOQB5ERbvgcJMsJCrQlevw";

    // Endpoint configured with gemini-3.6-flash
    private static final String GEMINI_URL = 
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.6-flash:generateContent?key=" + API_KEY;

    private final HttpClient httpClient;

    public GeminiService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(15))
                .build();
    }

    public String analyzeCode(String sourceCode, String language, String mode) throws Exception {
        
        String escapedCode = escapeJson(sourceCode);
        
        // System instruction requesting strict JSON output format
        String promptText = "You are an expert static code analyzer. Mode: " + mode + 
                ". Language: " + language + 
                ". Analyze the following code and return strict valid JSON containing keys 'severity' (LOW, MEDIUM, HIGH), 'summary', 'issues' (array of objects with 'type' and 'description'), and 'suggestedCode':\n\n" + escapedCode;

        // Construct standard REST JSON payload for Gemini API
        String jsonRequestBody = "{\n" +
                "  \"contents\": [{\n" +
                "    \"parts\": [{\"text\": \"" + promptText + "\"}]\n" +
                "  }]\n" +
                "}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(GEMINI_URL))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonRequestBody))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new RuntimeException("Gemini API Error (" + response.statusCode() + "): " + response.body());
        }

        return response.body();
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}