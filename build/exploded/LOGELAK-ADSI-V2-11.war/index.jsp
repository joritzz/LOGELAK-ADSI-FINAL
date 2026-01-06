<%-- Document : index Created on : 18 dic 2025, 16:51:25 Author : joritzz --%>
    <%@page import="java.util.List" %>
        <%@page import="models.Habitacion" %>
            <%@page contentType="text/html" pageEncoding="UTF-8" %>
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
                    <link rel="icon" href="image/favicon.png" type="image/png">
                </head>

                <body>

                    <header class="main-header">
                        <div class="logo">
                            <img src="image/favicon.png" alt="Logo" class="logo-img">
                            Logelak
                        </div>
                        <nav class="main-nav">
                            <!-- 
                Enlace a la página de login separada.
            -->
                            <a href="login.jsp">Login</a>
                        </nav>
                    </header>

                    <!-- 
        Contenido principal de la página de búsqueda.
        Se corresponde con la Figura 2 del PDF.
    -->
                    <main id="public-search-page">
                        <section class="search-section">
                            <h2>Buscar Habitación</h2>
                            <form id="search-form-public" class="search-form" action="index" method="POST">
                                <div class="form-group">
                                    <label for="search-city-public">Ciudad:</label>
                                    <select id="search-city-public" name="ciudad">
                                        <% String ciudadParam=request.getParameter("ciudad"); %>
                                            <option value="Vitoria" <%="Vitoria" .equals(ciudadParam) ? "selected" : ""
                                                %>>Vitoria</option>
                                            <option value="Bilbo" <%="Bilbo" .equals(ciudadParam) ? "selected" : "" %>
                                                >Bilbo</option>
                                            <option value="Donostia" <%="Donostia" .equals(ciudadParam) ? "selected"
                                                : "" %>>Donostia</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="search-date-start">Fecha Inicio:</label>
                                    <input type="date" id="search-date-start" name="fechaInicio"
                                        placeholder="AAAA/MM/DD" min="<%= java.time.LocalDate.now() %>"
                                        value="<%= request.getParameter(" fechaInicio") !=null ?
                                        request.getParameter("fechaInicio") : "" %>">
                                </div>
                                <div class="form-group">
                                    <label for="search-date-end">Fecha Fin:</label>
                                    <input type="date" id="search-date-end" name="fechaFin" placeholder="AAAA/MM/DD"
                                        min="<%= java.time.LocalDate.now() %>" value="<%= request.getParameter("fechaFin") !=null ? request.getParameter("fechaFin") : "" %>">
                                </div>
                                <button type="submit">Buscar</button>
                            </form>
                        </section>

                        <section class="results-section">
                            <h3>Resultados</h3>
                            <!-- 
                Los resultados de la búsqueda se insertarán aquí
                con Java Scriptlets.
            -->
                            <div id="results-container-public" class="results-grid">
                                <% List<Habitacion> searchResults = (List<Habitacion>)
                                        request.getAttribute("searchResults");
                                        if (searchResults != null && !searchResults.isEmpty()) {
                                        for (Habitacion h : searchResults) {
                                        %>
                                        <div class="room-card public cursor-pointer"
                                            data-room-id="<%= h.getCodHabi() %>"
                                            onclick="window.location.href='login.jsp'">
                                            <img src="<%= (h.getImagenHabitacion() != null && !h.getImagenHabitacion().isEmpty()) ? h.getImagenHabitacion() : "https://placehold.co/200x150/cccccc/999999?text=Foto" %>" alt="Foto de habitación" class="room-img">
                                            <div class="room-info">
                                                <p><strong>Dirección:</strong>
                                                    <%= h.getDireccion() %>
                                                </p>
                                                <p><strong>Ciudad:</strong>
                                                    <%= h.getCiudad() %>
                                                </p>
                                                <p><strong>Precio:</strong>
                                                    <%= h.getPrecioMes() %> €/mes
                                                </p>
                                            </div>
                                        </div>
                                        <% } } else if ("POST".equalsIgnoreCase(request.getMethod())) { %>
                                            <p>No se encontraron habitaciones disponibles para los criterios
                                                seleccionados.</p>
                                            <% } %>
                            </div>
                        </section>
                    </main>

                </body>

                </html>