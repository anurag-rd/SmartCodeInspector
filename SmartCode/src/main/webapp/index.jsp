<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || (session.getAttribute("userId") == null && session.getAttribute("user") == null && session.getAttribute("loggedUser") == null)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Code Inspector | AI-Assisted Bug Analyzer</title>
    
    <!-- Prism.js Tomorrow Night Theme for IDE Syntax Highlighting -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        body { background-color: #0d1117; color: #e6edf3; display: flex; flex-direction: column; height: 100vh; }
        
        header { background-color: #161b22; padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #30363d; }
        header h1 { font-size: 22px; color: #58a6ff; font-weight: 700; }
        header nav a { color: #8b949e; text-decoration: none; margin-left: 24px; font-weight: 600; transition: color 0.2s; }
        header nav a:hover { color: #58a6ff; }

        .main-container { display: flex; flex: 1; overflow: hidden; padding: 24px; gap: 24px; }
        
        .panel { flex: 1; background-color: #161b22; border-radius: 12px; border: 1px solid #30363d; display: flex; flex-direction: column; padding: 20px; position: relative; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.3); }
        .panel h2 { margin-bottom: 16px; color: #f0f6fc; font-size: 18px; font-weight: 600; }
        
        .controls { display: flex; gap: 12px; margin-bottom: 16px; }
        select, button { padding: 10px 16px; border-radius: 8px; border: 1px solid #30363d; background-color: #21262d; color: #c9d1d9; font-size: 14px; font-weight: 500; outline: none; transition: all 0.2s ease; }
        select:focus { border-color: #58a6ff; }
        select { cursor: pointer; flex: 1; }
        
        .btn-inspect { background: linear-gradient(135deg, #1f6feb 0%, #38bdf8 100%); color: #ffffff; font-weight: 700; cursor: pointer; border: none; box-shadow: 0 4px 12px rgba(31, 111, 235, 0.3); }
        .btn-inspect:hover { transform: translateY(-1px); box-shadow: 0 6px 16px rgba(56, 189, 248, 0.4); }

        /* Overlapping Overlay Editor Container for Real-time Highlighting */
        .editor-container { position: relative; flex: 1; background-color: #0d1117; border: 1px solid #30363d; border-radius: 8px; overflow: hidden; }
        
        .editor-container textarea, 
        .editor-container pre {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            padding: 16px; font-family: 'Fira Code', 'Cascadia Code', 'Consolas', monospace;
            font-size: 14px; line-height: 1.6; margin: 0; border: none; outline: none;
            white-space: pre-wrap; word-wrap: break-word; tab-size: 4;
        }

        /* Invisible text layer for editing input */
        .editor-container textarea {
            color: transparent; background: transparent; caret-color: #58a6ff;
            resize: none; z-index: 2; overflow-y: auto;
        }

        /* Colorized visual code layer beneath editor */
        .editor-container pre { z-index: 1; pointer-events: none; overflow: hidden; background: #0d1117 !important; }

        /* Syntax Highlight Colors (VS Code / Tomorrow Night Theme) */
        .token.keyword { color: #f7768e !important; font-weight: bold; } /* Keywords: public, class, void */
        .token.class-name, .token.function { color: #7aa2f7 !important; } /* Functions & Class names */
        .token.string { color: #9ece6a !important; } /* Strings: "Hello, World!" */
        .token.comment { color: #565f89 !important; font-style: italic; } /* Comments */
        .token.punctuation { color: #bb9af7 !important; } /* Brackets {}, (), [] */
        .token.operator { color: #89ddff !important; }

        .output-box { flex: 1; background-color: #0d1117; border: 1px solid #30363d; border-radius: 8px; padding: 16px; overflow-y: auto; }

        .badge { display: inline-block; padding: 6px 14px; border-radius: 20px; font-weight: 700; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px; }
        .badge-LOW { background-color: rgba(46, 160, 67, 0.2); color: #3fb950; border: 1px solid #2ea043; }
        .badge-MEDIUM { background-color: rgba(210, 153, 34, 0.2); color: #d29922; border: 1px solid #bb8009; }
        .badge-HIGH { background-color: rgba(248, 81, 73, 0.2); color: #f85149; border: 1px solid #f85149; }

        .card { background: #161b22; border: 1px solid #30363d; padding: 14px 18px; border-radius: 8px; margin-bottom: 14px; }
        .card-title { font-weight: 700; color: #79c0ff; margin-bottom: 6px; font-size: 14px; display: flex; align-items: center; gap: 8px; }
        .card-text { font-size: 14px; color: #e6edf3; line-height: 1.5; }

        .loader-overlay { display: none; position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(13, 17, 23, 0.92); backdrop-filter: blur(4px); border-radius: 12px; flex-direction: column; justify-content: center; align-items: center; z-index: 10; }
        .spinner { border: 3px solid #30363d; border-top: 3px solid #58a6ff; border-radius: 50%; width: 44px; height: 44px; animation: spin 0.8s infinite linear; margin-bottom: 12px; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>
<body>

    <header>
        <h1>Smart Code Inspector</h1>
        <nav>
            <a href="index.jsp">Dashboard</a>
            <a href="HistoryServlet">History</a>
            <a href="LogoutServlet" style="color: #f85149;">Logout</a>
        </nav>
    </header>

    <div class="main-container">
        <!-- Input Panel with Live IDE Syntax Highlighting -->
        <div class="panel">
            <h2>Source Code Submission</h2>
            <div class="controls">
                <select id="language" onchange="updateSyntaxHighlighting()">
                    <option value="java">Java</option>
                    <option value="cpp">C++</option>
                    <option value="python">Python</option>
                    <option value="javascript">JavaScript</option>
                </select>
                <select id="mode">
                    <option value="Bug Hunting & Logic">Bug Hunting & Logic</option>
                    <option value="Security Audit">Security Audit</option>
                    <option value="Performance Optimization">Performance Optimization</option>
                </select>
                <button class="btn-inspect" onclick="analyzeCode()">Analyze Code</button>
            </div>
            
            <div class="editor-container">
                <textarea id="sourceCode" spellcheck="false" oninput="updateSyntaxHighlighting()" onscroll="syncScroll()">// Every line of code that runs in Java must be inside a class.
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}</textarea>
                <pre><code id="highlightingCode" class="language-java"></code></pre>
            </div>
        </div>

        <!-- Output Panel -->
        <div class="panel">
            <h2>Inspection Results</h2>
            <div id="loader" class="loader-overlay">
                <div class="spinner"></div>
                <p>Analyzing Code Dynamics...</p>
            </div>
            <div id="outputResult" class="output-box">
                <p style="color: #8b949e; font-size: 14px;">Select target language and click "Analyze Code" to display Gemini AI analysis...</p>
            </div>
        </div>
    </div>

    <!-- Prism Syntax Highlighting Engine -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-java.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-cpp.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-python.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-javascript.min.js"></script>

    <script>
        function updateSyntaxHighlighting() {
            const codeInput = document.getElementById("sourceCode").value;
            const codeDisplay = document.getElementById("highlightingCode");
            const selectedLang = document.getElementById("language").value;

            codeDisplay.className = "language-" + selectedLang;
            codeDisplay.textContent = codeInput;
            Prism.highlightElement(codeDisplay);
        }

        function syncScroll() {
            const textarea = document.getElementById("sourceCode");
            const pre = document.querySelector(".editor-container pre");
            pre.scrollTop = textarea.scrollTop;
            pre.scrollLeft = textarea.scrollLeft;
        }

        // Initialize syntax highlighting on first load
        document.addEventListener("DOMContentLoaded", updateSyntaxHighlighting);

        async function analyzeCode() {
            const language = document.getElementById("language").value;
            const mode = document.getElementById("mode").value;
            const sourceCode = document.getElementById("sourceCode").value;

            if (!sourceCode.trim()) {
                alert("Please enter some source code to analyze.");
                return;
            }

            const loader = document.getElementById("loader");
            const outputBox = document.getElementById("outputResult");
            
            loader.style.display = "flex";

            try {
                const response = await fetch('AnalysisServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                    body: new URLSearchParams({ 'language': language, 'mode': mode, 'sourceCode': sourceCode })
                });

                const rawText = await response.text();

                if (rawText.trim().startsWith("<")) {
                    alert("Server returned an HTML error page. Check Eclipse Console.");
                    return;
                }

                const responseData = JSON.parse(rawText);

                if (responseData.error) {
                    outputBox.innerHTML = '<div class="card"><div class="card-title" style="color:#f85149;">Error</div><div class="card-text">' + escapeHtml(responseData.error) + '</div></div>';
                    return;
                }

                let parsedAnalysis;
                try {
                    let jsonText = responseData.candidates[0].content.parts[0].text;
                    jsonText = jsonText.replace(/```json/g, "").replace(/```/g, "").trim();
                    parsedAnalysis = JSON.parse(jsonText);
                } catch (e) {
                    parsedAnalysis = responseData;
                }

                renderResults(parsedAnalysis);

            } catch (err) {
                outputBox.innerHTML = '<div class="card"><div class="card-title" style="color:#f85149;">Execution Error</div><div class="card-text">' + escapeHtml(err.message) + '</div></div>';
            } finally {
                loader.style.display = "none";
            }
        }

        function renderResults(data) {
            const outputBox = document.getElementById("outputResult");
            
            if (!data || typeof data !== 'object') {
                outputBox.innerHTML = "<p style='color:#f85149;'>Invalid inspection data received.</p>";
                return;
            }

            const severity = data.severity || "LOW";
            const summary = data.summary || "No detailed summary available.";
            const issues = data.issues || [];
            const suggestedCode = data.suggestedCode || "";

            let html = '<span class="badge badge-' + severity + '">Severity: ' + severity + '</span>' +
                '<div class="card">' +
                    '<div class="card-title">Summary</div>' +
                    '<div class="card-text">' + escapeHtml(summary) + '</div>' +
                '</div>';

            if (issues.length > 0) {
                html += '<div class="card-title" style="margin-top:15px; margin-bottom:8px; color:#f0f6fc;">Detected Issues (' + issues.length + ')</div>';
                issues.forEach((issue, index) => {
                    const title = issue.type || 'Bug/Warning';
                    const desc = issue.description || issue;
                    html += '<div class="card">' +
                                '<div class="card-title" style="color:#d29922;">#' + (index + 1) + ': ' + escapeHtml(title) + '</div>' +
                                '<div class="card-text">' + escapeHtml(desc) + '</div>' +
                            '</div>';
                });
            } else {
                html += '<div class="card">' +
                            '<div class="card-title" style="color:#3fb950;">No Issues Found</div>' +
                            '<div class="card-text">Your source code passed all dynamic static inspection checks!</div>' +
                        '</div>';
            }

            if (suggestedCode) {
                html += '<div class="card-title" style="margin-top:15px; margin-bottom:8px; color:#f0f6fc;">Suggested Refactored Code</div>' +
                        '<pre><code class="language-java">' + escapeHtml(suggestedCode) + '</code></pre>';
            }

            outputBox.innerHTML = html;
            Prism.highlightAllUnder(outputBox);
        }

        function escapeHtml(str) {
            if (!str) return '';
            return String(str).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
        }
    </script>
</body>
</html>