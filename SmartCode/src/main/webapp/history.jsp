\<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (session == null || (session.getAttribute("userId") == null && session.getAttribute("user") == null && session.getAttribute("loggedUser") == null)) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, Object>> historyList = (List<Map<String, Object>>) request.getAttribute("historyList");
    String userRole = (String) session.getAttribute("userRole");
    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Inspection History | Smart Code Inspector</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #0d1117; color: #e6edf3; min-height: 100vh; display: flex; flex-direction: column; }
        header { background-color: #161b22; padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #30363d; }
        header h1 { font-size: 22px; color: #58a6ff; font-weight: 700; }
        header nav a { color: #8b949e; text-decoration: none; margin-left: 24px; font-weight: 600; }
        .container { flex: 1; padding: 32px; max-width: 1200px; margin: 0 auto; width: 100%; }
        .page-title { margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; }
        .admin-badge { background: #f85149; color: white; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: bold; margin-left: 8px; text-transform: uppercase; }

        .history-table { width: 100%; border-collapse: separate; border-spacing: 0; background-color: #161b22; border-radius: 12px; border: 1px solid #30363d; overflow: hidden; }
        .history-table th { background-color: #21262d; color: #79c0ff; text-align: left; padding: 14px 20px; font-size: 13px; font-weight: 700; text-transform: uppercase; border-bottom: 1px solid #30363d; }
        .history-table td { padding: 16px 20px; color: #c9d1d9; border-bottom: 1px solid #21262d; font-size: 14px; }
        .history-table tr { cursor: pointer; transition: background 0.2s; }
        .history-table tr:hover td { background-color: rgba(56, 189, 248, 0.08); }

        .btn-delete { background-color: #da3633; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-weight: 600; font-size: 12px; cursor: pointer; transition: background 0.2s; text-decoration: none; display: inline-block; }
        .btn-delete:hover { background-color: #f85149; }

        .tag { display: inline-block; padding: 4px 12px; border-radius: 6px; font-size: 12px; font-weight: 700; background: #1f6feb; color: #ffffff; border: 1px solid #38bdf8; text-transform: lowercase; }
        .code-snippet { font-family: 'Fira Code', monospace; color: #50fa7b; max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; background: #0d1117; padding: 6px 10px; border-radius: 6px; border: 1px solid #21262d; }

        /* Modal Overlay */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.8); backdrop-filter: blur(5px); justify-content: center; align-items: center; z-index: 1000; }
        .modal-content { background: #161b22; border: 1px solid #30363d; width: 85%; max-width: 900px; max-height: 85vh; border-radius: 12px; display: flex; flex-direction: column; overflow: hidden; }
        .modal-header { padding: 18px 24px; background: #21262d; border-bottom: 1px solid #30363d; display: flex; justify-content: space-between; align-items: center; }
        .modal-body { padding: 24px; overflow-y: auto; display: flex; flex-direction: column; gap: 20px; }
        .close-btn { background: none; border: none; color: #8b949e; font-size: 24px; cursor: pointer; }
        .code-block { background: #0d1117 !important; border: 1px solid #30363d; border-radius: 8px; padding: 16px; overflow-x: auto; font-family: 'Fira Code', monospace; }
        .card { background: #0d1117; border: 1px solid #30363d; padding: 14px 18px; border-radius: 8px; margin-bottom: 10px; }
        .card-title { font-weight: 700; color: #d29922; margin-bottom: 4px; font-size: 14px; }
        .card-text { font-size: 14px; color: #e6edf3; }
    </style>
</head>
<body>

    <header>
        <h1>Smart Code Inspector <% if(isAdmin) { %><span class="admin-badge">Admin Mode</span><% } %></h1>
        <nav>
            <a href="index.jsp">Dashboard</a>
            <a href="HistoryServlet" style="color: #58a6ff;">History</a>
            <a href="LogoutServlet" style="color: #f85149;">Logout</a>
        </nav>
    </header>

    <div class="container">
        <div class="page-title">
            <h2>Past Inspection History</h2>
            <a href="index.jsp" style="color:#58a6ff; text-decoration:none;">&larr; Back to Dashboard</a>
        </div>

        <table class="history-table">
            <thead>
                <tr>
                    <th>Date &amp; Time</th>
                    <th>Language</th>
                    <th>Mode</th>
                    <th>Source Code Snippet</th>
                    <% if (isAdmin) { %><th>Action</th><% } %>
                </tr>
            </thead>
            <tbody>
                <% if (historyList != null && !historyList.isEmpty()) { 
                    int index = 0;
                    for (Map<String, Object> item : historyList) { 
                        index++;
                        int historyId = (Integer) item.get("id");
                        String lang = (String) item.get("language");
                        String mode = (String) item.get("mode");
                        String source = (String) item.get("source_code");
                        String result = (String) item.get("analysis_result");
                        String date = item.get("created_at") != null ? item.get("created_at").toString() : "N/A";
                %>
                    <tr onclick="openModal('<%= index %>')">
                        <td><%= date %></td>
                        <td><span class="tag"><%= lang %></span></td>
                        <td><%= mode %></td>
                        <td><div class="code-snippet"><%= source %></div></td>
                        <% if (isAdmin) { %>
                            <td onclick="event.stopPropagation();">
                                <a href="DeleteHistoryServlet?id=<%= historyId %>" 
                                   class="btn-delete" 
                                   onclick="return confirm('Are you sure you want to delete this history record?');">
                                   Delete
                                </a>
                            </td>
                        <% } %>
                    </tr>

                    <div id="data-source-<%= index %>" style="display:none;"><%= source %></div>
                    <div id="data-result-<%= index %>" style="display:none;"><%= result %></div>
                    <div id="data-lang-<%= index %>" style="display:none;"><%= lang %></div>
                    <div id="data-mode-<%= index %>" style="display:none;"><%= mode %></div>
                    <div id="data-date-<%= index %>" style="display:none;"><%= date %></div>
                <%  } 
                   } else { %>
                    <tr>
                        <td colspan="<%= isAdmin ? 5 : 4 %>" style="text-align:center; padding: 40px; color:#8b949e;">
                            No history entries recorded yet.
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Modal Popup Box -->
    <div id="inspectionModal" class="modal-overlay" onclick="closeModalOnOuterClick(event)">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle" style="color:#58a6ff;">Inspection Details</h3>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div>
                    <div style="font-size:12px; font-weight:bold; color:#79c0ff; margin-bottom:8px;">SUBMITTED SOURCE CODE</div>
                    <pre class="code-block"><code id="modalSourceCode"></code></pre>
                </div>
                <div>
                    <div style="font-size:12px; font-weight:bold; color:#79c0ff; margin-bottom:8px;">INSPECTION OUTPUT</div>
                    <div id="modalAnalysisResult"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script>
        function openModal(id) {
            const lang = document.getElementById("data-lang-" + id).innerText;
            const mode = document.getElementById("data-mode-" + id).innerText;
            const date = document.getElementById("data-date-" + id).innerText;
            const rawSource = document.getElementById("data-source-" + id).innerText;
            const rawResult = document.getElementById("data-result-" + id).innerText;

            document.getElementById("modalTitle").innerText = lang.toUpperCase() + " Inspection (" + mode + ") - " + date;
            
            const codeElem = document.getElementById("modalSourceCode");
            codeElem.textContent = rawSource;

            const resultBox = document.getElementById("modalAnalysisResult");
            try {
                let parsed = JSON.parse(rawResult);
                resultBox.innerHTML = '<div class="card"><div class="card-title">Summary</div><div class="card-text">' + 
                                      (parsed.summary || rawResult) + '</div></div>';
            } catch (e) {
                resultBox.innerHTML = '<div class="card"><div class="card-text">' + rawResult + '</div></div>';
            }

            document.getElementById("inspectionModal").style.display = "flex";
        }

        function closeModal() { document.getElementById("inspectionModal").style.display = "none"; }
        function closeModalOnOuterClick(e) { if (e.target.id === "inspectionModal") closeModal(); }
    </script>
</body>
</html>