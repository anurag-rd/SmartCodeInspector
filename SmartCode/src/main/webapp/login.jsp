<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | Smart Code Inspector</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
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
            --success-color: #4ade80;
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

        /* Animated Glowing Orbs Background */
        .ambient-glow {
            position: absolute;
            width: 500px;
            height: 500px;
            border-radius: 50%;
            filter: blur(120px);
            pointer-events: none;
            opacity: 0.35;
            animation: pulseMotion 12s infinite ease-in-out alternate;
        }

        .glow-1 {
            background: radial-gradient(circle, var(--accent-glow), transparent 70%);
            top: -150px;
            left: -150px;
        }

        .glow-2 {
            background: radial-gradient(circle, var(--accent-purple), transparent 70%);
            bottom: -150px;
            right: -150px;
            animation-delay: -6s;
        }

        @keyframes pulseMotion {
            0% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(40px, -30px) scale(1.1); }
            100% { transform: translate(-30px, 20px) scale(0.95); }
        }

        /* Glass Container Card */
        .auth-container {
            width: 100%;
            max-width: 440px;
            padding: 3rem 2.5rem;
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

        /* Header Section */
        .brand-header {
            text-align: center;
            margin-bottom: 2.25rem;
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

        .brand-header h1 {
            font-size: 1.65rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: var(--text-primary);
            margin-bottom: 0.4rem;
        }

        .brand-header p {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        /* Form Inputs */
        .form-group {
            margin-bottom: 1.35rem;
        }

        .form-group label {
            display: block;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-secondary);
            margin-bottom: 0.5rem;
            transition: color 0.3s ease;
        }

        .form-group:focus-within label {
            color: var(--accent-glow);
        }

        .input-wrapper {
            position: relative;
        }

        .input-control {
            width: 100%;
            padding: 0.85rem 1.1rem;
            background: var(--input-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            color: var(--text-primary);
            font-size: 0.95rem;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .input-control:focus {
            outline: none;
            border-color: var(--accent-glow);
            box-shadow: 0 0 0 4px rgba(56, 189, 248, 0.15);
            background: rgba(15, 23, 42, 0.9);
        }

        /* Interactive Action Button */
        .btn-submit {
            width: 100%;
            padding: 0.9rem;
            margin-top: 0.75rem;
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
            margin-top: 1.75rem;
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

        /* Status Badges */
        .alert {
            padding: 0.85rem 1rem;
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 1.25rem;
            animation: fadeIn 0.3s ease;
        }

        .alert-error {
            background: rgba(248, 113, 113, 0.12);
            border: 1px solid rgba(248, 113, 113, 0.3);
            color: var(--error-color);
        }

        .alert-success {
            background: rgba(74, 222, 128, 0.12);
            border: 1px solid rgba(74, 222, 128, 0.3);
            color: var(--success-color);
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
            <h1>Smart Code Inspector</h1>
            <p>Welcome back! Please enter your details.</p>
        </div>

        <% 
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");

            if ("registered".equals(msg)) {
        %>
            <div class="alert alert-success">Registration successful! Please sign in.</div>
        <% 
            }

            if ("invalid".equals(error) || "invalid_credentials".equals(error)) { 
        %>
            <div class="alert alert-error">Invalid username or password.</div>
        <%  } else if ("unauthorized".equals(error)) { %>
            <div class="alert alert-error">Please log in to access the system.</div>
        <%  } %>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="username">Username / Email</label>
                <div class="input-wrapper">
                    <input type="text" id="username" name="username" class="input-control" required placeholder="Enter your credential" autocomplete="off">
                </div>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <div class="input-wrapper">
                    <input type="password" id="password" name="password" class="input-control" required placeholder="••••••••">
                </div>
            </div>

            <button type="submit" class="btn-submit">Sign In</button>
        </form>

        <div class="auth-footer">
            Don't have an account? <a href="register.jsp">Create an account</a>
        </div>
    </div>

</body>
</html>