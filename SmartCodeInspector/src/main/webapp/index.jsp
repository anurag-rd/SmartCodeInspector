<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Code Bug Inspector</title>
    <style>
        body { font-family: sans-serif; background: #1e1e1e; color: #d4d4d4; padding: 30px; }
        .container { max-width: 900px; margin: 0 auto; background: #252526; padding: 25px; border-radius: 8px; }
        textarea { width: 100%; height: 200px; background: #1e1e1e; color: #9cdcfe; font-family: monospace; box-sizing: border-box; }
        button { padding: 10px 20px; background: #0e639c; color: white; border: none; cursor: pointer; font-weight: bold; }
        button:hover { background: #1177bb; }
        #output { margin-top: 20px; padding: 15px; background: #333333; border-left: 4px solid #0e639c; white-space: pre-wrap; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Smart Code Inspector</h2>
        <label for="language">Select Language: </label>
        <select id="language">
            <option value="Java">Java</option>
            <option value="C++">C++</option>
            <option value="Python">Python</option>
        </select>
        <br><br>
        <textarea id="code" placeholder="Paste code here..."></textarea>
        <br><br>
        <button onclick="inspectCode()">Analyze Code</button>
        <div id="output">Analysis results will appear here...</div>
    </div>

    <script>
    function inspectCode() {
        let lang = document.getElementById("language").value;
        let code = document.getElementById("code").value;
        
        if (!code.trim()) {
            alert("Please paste some code first!");
            return;
        }

        document.getElementById("output").innerText = "Analyzing code...";

        fetch('analyzeCode', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'language=' + encodeURIComponent(lang) + '&code=' + encodeURIComponent(code)
        })
        .then(res => res.json())
        .then(data => {
            // Check if response contains valid AI generated text
            if (data.candidates && data.candidates[0] && data.candidates[0].content) {
                document.getElementById("output").innerText = data.candidates[0].content.parts[0].text;
            } 
            // Handle API or backend error objects clearly
            else if (data.error) {
                let errorMsg = typeof data.error === 'object' ? JSON.stringify(data.error, null, 2) : data.error;
                document.getElementById("output").innerText = "API Error:\n" + errorMsg;
            } 
            else {
                document.getElementById("output").innerText = "Unexpected response format:\n" + JSON.stringify(data, null, 2);
            }
        })
        .catch(err => {
            document.getElementById("output").innerText = "Network/Server Error: " + err.message;
        });
    }
    </script>
</body>
</html>