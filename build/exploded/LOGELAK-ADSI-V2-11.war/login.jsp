<%-- 
    Document   : login
    Created on : 18 dic 2025, 16:52:38
    Author     : joritzz
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logelak - Login</title>

    <!-- 
      ¡IMPORTANTE!
      Estos enlaces asumen que 'login.html' está en la carpeta raíz
      y los archivos CSS están DENTRO de una carpeta llamada 'css'.

      Estructura de carpetas esperada:
      tu_proyecto/
      ├── login.html
      └── css/
          ├── style.css
          └── login.css
    -->

    <!-- Enlace a la hoja de estilos del proyecto -->
    <link rel="stylesheet" href="css/style.css">

    <!-- Enlace a los estilos específicos del login -->
    <link rel="stylesheet" href="css/login.css">

    <link rel="icon" href="imgs/favicon.png" type="image/png">

    <!-- 
      Carga el inicializador de la BD.
      Carga el script específico para esta página de login.
    -->
    <script src="js/db-init.js" defer></script>
    <script src="js/login.js" defer></script>
</head>

<body>

    <!-- 
      Contenedor del formulario de login (Figura 3).
      Esto es el contenido que faltaba.
    -->
    <div id="login-view" class="login-container">
        <form id="login-form" class="login-form">
            <h2>Login</h2>
            <!-- Mensaje de error -->
            <div id="login-error" class="error-message hidden"></div>

            <div class="form-group">
                <label for="login-email">User (email):</label>
                <input type="email" id="login-email" placeholder="tu@ejemplo.com">
            </div>
            <div class="form-group">
                <label for="login-password">Password:</label>
                <div style="position: relative;">
                    <input type="password" id="login-password" placeholder="••••••••"
                        style="width: 100%; padding-right: 40px;">
                    <span id="toggle-password"
                        style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); cursor: pointer;">👁️</span>
                </div>
            </div>
            <button type="submit">Aceptar</button>
        </form>
        <!-- 
            He quitado el enlace "No tienes cuenta" porque no 
            estaba en los bocetos del PDF, pero se puede añadir.
         -->
    </div>
</body>

</html>