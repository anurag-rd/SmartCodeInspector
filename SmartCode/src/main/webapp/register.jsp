<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Smart Code Inspector</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&family=JetBrains+Mono:wght@500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-main: #0a0d14;
            --card-bg: rgba(16, 22, 34, 0.75);
            --accent-glow: #38bdf8;
            --accent-purple: #a855f7;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --input-bg: rgba(15, 23, 42, 0.65);
            --border-color: rgba(255, 255, 255, 0.1);
            --error-color: #f87171;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: var(--bg-main);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        /* Animated Ambient Light Orbs */
        .ambient-glow {
            position: absolute;
            width: 550px;
            height: 550px;
            border-radius: 50%;
            filter: blur(120px);
            pointer-events: none;
            opacity: 0.35;
            animation: pulseMotion 12s infinite ease-in-out alternate;
        }

        .glow-1 {
            background: radial-gradient(circle, var(--accent-purple), transparent 70%);
            top: -150px;
            right: -150px;
        }

        .glow-2 {
            background: radial-gradient(circle, var(--accent-glow), transparent 70%);
            bottom: -150px;
            left: -150px;
            animation-delay: -6s;
        }

        @keyframes pulseMotion {
            0% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(-40px, 30px) scale(1.1); }
            100% { transform: translate(30px, -20px) scale(0.95); }
        }

        /* Glass Container Card */
        .auth-container {
            width: 100%;
            max-width: 460px;
            padding: 2.5rem;
            background: var(--card-bg);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.7),
                        0 0 0 1px rgba(255, 255, 255, 0.05);
            z-index: 10;
            animation: slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Brand Header & Live Typing Container */
        .brand-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .icon-badge {
            width: 52px;
            height: 52px;
            margin: 0 auto 1.25rem;
            background: linear-gradient(135deg, var(--accent-glow), var(--accent-purple));
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 30px rgba(56, 189, 248, 0.3);
            animation: floatIcon 4s ease-in-out infinite;
        }

        @keyframes floatIcon {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
        }

        /* Dynamic Animated Typing Title Styling */
        .typing-title-wrapper {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 2.2rem;
            margin-bottom: 0.3rem;
        }

        .typing-title {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #38bdf8 0%, #c084fc 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.02em;
        }

        .cursor {
            display: inline-block;
            width: 3px;
            height: 1.35rem;
            background-color: var(--accent-glow);
            margin-left: 4px;
            border-radius: 2px;
            animation: blink 0.8s infinite;
        }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0; }
        }

        .brand-header p {
            color: var(--text-secondary);
            font-size: 0.875rem;
        }

        /* Form Inputs */
        .form-group {
            margin-bottom: 1.15rem;
        }

        .form-group label {
            display: block;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-secondary);
            margin-bottom: 0.45rem;
            transition: color 0.3s ease;
        }

        .form-group:focus-within label {
            color: var(--accent-glow);
        }

        .input-control {
            width: 100%;
            padding: 0.8rem 1rem;
            background: var(--input-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            color: var(--text-primary);
            font-size: 0.925rem;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .input-control:focus {
            outline: none;
            border-color: var(--accent-glow);
            box-shadow: 0 0 0 4px rgba(56, 189, 248, 0.15);
            background: rgba(15, 23, 42, 0.9);
        }

        /* Custom Dropdown Styling */
        .select-wrapper {
            position: relative;
        }

        .select-control {
            appearance: none;
            -webkit-appearance: none;
            cursor: pointer;
            padding-right: 2.5rem;
        }

        .select-wrapper::after {
            content: '';
            position: absolute;
            right: 1.1rem;
            top: 50%;
            transform: translateY(-50%);
            width: 0;
            height: 0;
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
            border-top: 6px solid var(--text-secondary);
            pointer-events: none;
            transition: transform 0.3s ease;
        }

        .select-wrapper:focus-within::after {
            transform: translateY(-50%) rotate(180deg);
            border-top-color: var(--accent-glow);
        }

        .select-control option {
            background-color: #0f172a;
            color: var(--text-primary);
        }

        /* Interactive Action Button */
        .btn-submit {
            width: 100%;
            padding: 0.9rem;
            margin-top: 0.6rem;
            background: linear-gradient(135deg, #38bdf8 0%, #6366f1 100%);
            border: none;
            border-radius: 12px;
            color: #ffffff;
            font-weight: 600;
            font-size: 0.975rem;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px -5px rgba(56, 189, 248, 0.3);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 25px -5px rgba(56, 189, 248, 0.5);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        /* Footer Link */
        .auth-footer {
            margin-top: 1.5rem;
            text-align: center;
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        .auth-footer a {
            color: var(--accent-glow);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
        }

        .auth-footer a:hover {
            color: #ffffff;
            text-shadow: 0 0 8px rgba(56, 189, 248, 0.6);
        }

        /* Status Alerts */
        .alert-error {
            padding: 0.8rem 1rem;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 1.25rem;
            background: rgba(248, 113, 113, 0.12);
            border: 1px solid rgba(248, 113, 113, 0.3);
            color: var(--error-color);
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-5px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="ambient-glow glow-1"></div>
    <div class="ambient-glow glow-2"></div>

    <div class="auth-container">
        <div class="brand-header">
            <div class="icon-badge">
                <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>
            </div>
            
            <!-- Live Typing Project Title -->
            <div class="typing-title-wrapper">
                <span id="typed-text" class="typing-title"></span><span class="cursor"></span>
            </div>
            
            <p>Create your account to start inspecting code</p>
        </div>

        <% 
            String error = request.getParameter("error");
            if ("failed".equals(error)) { 
        %>
            <div class="alert-error">Registration failed. Please try again.</div>
        <%  } %>

        <form action="RegisterServlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="input-control" required placeholder="e.g. dev_ninja" autocomplete="off">
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="input-control" required placeholder="developer@example.com" autocomplete="off">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="input-control" required placeholder="••••••••">
            </div>

            <div class="form-group">
                <label for="role">Register As</label>
                <div class="select-wrapper">
                    <select name="role" id="role" class="input-control select-control" required>
                        <option value="user" selected>User</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn-submit">Create Account</button>
        </form>

        <div class="auth-footer">
            Already registered? <a href="login.jsp">Sign in to workspace</a>
        </div>
    </div>

    <!-- Live Typing Script -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const titleText = "Smart Code Inspector";
            const targetElement = document.getElementById("typed-text");
            let index = 0;

            function typeWriter() {
                if (index < titleText.length) {
                    targetElement.textContent += titleText.charAt(index);
                    index++;
                    setTimeout(typeWriter, 70); // Adjust typing speed here
                }
            }

            // Start typing animation after a brief entrance delay
            setTimeout(typeWriter, 300);
        });
    </script>

</body>
</html>