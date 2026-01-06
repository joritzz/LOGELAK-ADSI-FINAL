<%-- Document : login Created on : 18 dic 2025, 16:52:38 Author : joritzz --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Logelak - Login</title>



            <!-- Enlace a la hoja de estilos del proyecto -->
            <link rel="stylesheet" href="css/style.css">

            <!-- Enlace a los estilos específicos del login -->
            <link rel="stylesheet" href="css/login.css">

            <link rel="icon" href="image/favicon.png" type="image/png">

        </head>

        <body>

            <div id="login-view" class="login-container">
                <form id="login-form" class="login-form" action="login" method="post">
                    <h2>Login</h2>
                    <!-- Mensaje de error -->
                    <% if (request.getAttribute("error") !=null) { %>
                        <div id="login-error" class="error-message"
                            style="display:block; color:red; margin-bottom:10px;">
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>

                            <div class="form-group">
                                <label for="login-email">User (email):</label>
                                <input type="email" id="login-email" name="email" placeholder="tu@ejemplo.com" required>
                            </div>
                            <div class="form-group">
                                <label for="login-password">Password:</label>
                                <div style="position: relative;">
                                    <input type="password" id="login-password" name="password" placeholder="••••••••"
                                        style="width: 100%; padding-right: 40px;" required>
                                    <span id="toggle-password"
                                        style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); cursor: pointer;">👁️</span>
                                </div>
                            </div>
                            <button type="submit">Aceptar</button>
                </form>
            </div>
        </body>

        </html>