<%-- 
    Document   : index
    Created on : 18 dic 2025, 16:51:25
    Author     : joritzz
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logelak - Buscar Habitación</title>

    <!-- 
      Reutilizamos la misma hoja de estilos del proyecto 
      para mantener la coherencia.
    -->
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" href="imgs/favicon.png" type="image/png">

    <!-- 
      Carga el inicializador de la BD.
      Carga el script específico para ESTA página (index.js).
    -->
    <script src="js/db-init.js" defer></script>
    <script src="js/index.js" defer></script>
</head>

<body>

    <header class="main-header">
        <div class="logo">Logelak</div>
        <nav class="main-nav">
            <!-- 
              Enlace a la página de login separada.
            -->
            <a href="login.html">Login</a>
        </nav>
    </header>

    <!-- 
      Contenido principal de la página de búsqueda.
      Se corresponde con la Figura 2 del PDF.
    -->
    <main id="public-search-page">
        <section class="search-section">
            <h2>Buscar Habitación</h2>
            <form id="search-form-public" class="search-form">
                <div class="form-group">
                    <label for="search-city-public">Ciudad:</label>
                    <select id="search-city-public" name="ciudad">
                        <option value="Vitoria-Gasteiz">Vitoria-Gasteiz</option>
                        <option value="Bilbao">Bilbao</option>
                        <option value="Donostia">Donostia</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="search-date-public">Fecha (a partir de):</label>
                    <input type="date" id="search-date-public" name="fecha" placeholder="AAAA/MM/DD">
                </div>
                <button type="submit">Buscar</button>
            </form>
        </section>

        <section class="results-section">
            <h3>Resultados</h3>
            <!-- 
              Los resultados de la búsqueda se insertarán aquí
              con JavaScript.
            -->
            <div id="results-container-public" class="results-grid">
                <!-- 
                Ejemplo de cómo se verá un resultado (generado por JS):
                
                <div class="room-card public" data-room-id="123">
                    <img src="https://placehold.co/200x150/cccccc/999999?text=Foto" alt="Foto de habitación (difuminada)">
                    <div class="room-info">
                        <p><strong>Dirección:</strong> Calle Falsa, 123</p>
                        <p><strong>Precio:</strong> 300 €/mes</p>
                    </div>
                </div>
                -->
            </div>
        </section>
    </main>

</body>

</html>