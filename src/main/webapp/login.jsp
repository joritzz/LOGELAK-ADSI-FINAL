<%-- Document : login Created on : 18 dic 2025, 16:52:38 Author : joritzz --%>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Logelak - Login</title>
            <link rel="stylesheet" href="css/style.css">
            <link rel="stylesheet" href="css/login.css">

            <link rel="icon" href="image/favicon.png" type="image/png">
        </head>

        <body>

            <div id="login-view" class="login-container">
                <form id="login-form" class="login-form" action="login" method="post">
                    <h2>Login</h2>
                    <% if (request.getAttribute("error") !=null) { %>
                        <div id="login-error" class="error-message error-visible">
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>

                            <div class="form-group">
                                <label for="login-email">User (email):</label>
                                <input type="email" id="login-email" name="email" placeholder="tu@ejemplo.com" required>
                            </div>
                            <div class="form-group">
                                <label for="login-password">Password:</label>
                                <div class="relative-container">
                                    <input type="password" id="login-password" name="password" placeholder="••••••••"
                                        class="input-password" required>
                                    <span id="toggle-password" class="password-toggle">👁️</span>
                                </div>
                            </div>
                            <button type="submit">Aceptar</button>
                </form>
            </div>

            <script>
                const togglePassword = document.querySelector("#toggle-password");
                const password = document.querySelector("#login-password");

                togglePassword.addEventListener("click", function () {
                    const type = password.getAttribute("type") === "password" ? "text" : "password";
                    password.setAttribute("type", type);
                    this.textContent = type === "password" ? "👁️" : "🙈";
                });
            </script>
        </body>

        </html>