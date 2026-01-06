<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="models.Habitacion" %>
            <%@ page import="models.Solicitud" %>
                <%@ page import="models.Alquiler" %>
                    <%@ page import="models.Usuario" %>

                        <!DOCTYPE html>
                        <html lang="es">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Logelak - Mi Perfil</title>
                            <link rel="stylesheet" href="css/style.css?v=<%= java.time.Instant.now().toEpochMilli() %>">
                            <link rel="icon" href="image/favicon.png" type="image/png">
                        </head>

                        <body>

                            <header class="main-header">
                                <div class="logo">
                                    <img src="image/favicon.png" alt="Logo"
                                        style="height: 1.2em; vertical-align: middle; margin-right: 10px;">
                                    Logelak
                                </div>
                                <nav class="main-nav">
                                    <a href="app?action=logout" id="logout-link">Logout</a>
                                </nav>
                            </header>

                            <% Usuario usuario=(Usuario) session.getAttribute("usuario"); String nombreUsuario=(usuario
                                !=null) ? usuario.getNombre() : "" ; String fotoUsuario=(usuario !=null &&
                                usuario.getFoto() !=null) ? usuario.getFoto()
                                : "https://placehold.co/50x50/2563eb/FFF?text=U" ; String currentView=(String)
                                request.getAttribute("currentView"); if (currentView==null) currentView="" ; %>

                                <div id="logged-in-view">
                                    <div class="user-header">
                                        <span>Hola, <strong id="user-name">
                                                <%= nombreUsuario %>
                                            </strong></span>
                                        <img id="user-photo" src="<%= fotoUsuario %>" alt="Foto de perfil"
                                            class="profile-pic">
                                    </div>



                                    <nav class="app-nav">
                                        <div class="nav-tab tab-consultar <%= " consultar".equals(currentView)
                                            ? "active" : "" %>">
                                            <a href="app?view=consultar">Consultar</a>
                                        </div>
                                        <div class="nav-tab tab-habitaciones <%= " habitaciones".equals(currentView)
                                            ? "active" : "" %>">
                                            <a href="app?view=habitaciones">Habitaciones</a>
                                        </div>

                                        <!-- Inquilino Dropdown -->
                                        <div class="nav-tab dropdown <%= currentView.startsWith(" inquilino") ? "active"
                                            : "" %>" onclick="toggleDropdown(event)">
                                            <span class="dropdown-trigger">Inquilino</span>
                                            <div class="dropdown-content">
                                                <a href="app?view=inquilino_solicitudes">Mis Solicitudes</a>
                                                <a href="app?view=inquilino_alquileres">Mis Alquileres</a>
                                            </div>
                                        </div>

                                        <!-- Propietario Dropdown -->
                                        <div class="nav-tab dropdown <%= currentView.startsWith(" propietario")
                                            ? "active" : "" %>" onclick="toggleDropdown(event)">
                                            <span class="dropdown-trigger">Propietario</span>
                                            <div class="dropdown-content">
                                                <a href="app?view=propietario_solicitudes">Solicitudes Recibidas</a>
                                                <a href="app?view=propietario_alquileres">Alquileres en Propiedad</a>
                                            </div>
                                        </div>
                                    </nav>

                                    <script>
                                        /* Dropdown Toggle Logic */
                                        function toggleDropdown(event) {
                                            event.stopPropagation(); // Prevent immediate closing

                                            // Close all other dropdowns
                                            var dropdowns = document.getElementsByClassName("dropdown-content");
                                            for (var i = 0; i < dropdowns.length; i++) {
                                                var openDropdown = dropdowns[i];
                                                // If it's not the sibling of the clicked trigger, hide it
                                                if (openDropdown !== event.currentTarget.nextElementSibling) {
                                                    openDropdown.classList.remove('show');
                                                }
                                            }

                                            // Toggle the clicked one
                                            var content = event.currentTarget.nextElementSibling;
                                            content.classList.toggle("show");
                                        }

                                        // Close the dropdown if the user clicks outside of it
                                        window.onclick = function (event) {
                                            if (!event.target.matches('.dropdown-trigger')) {
                                                var dropdowns = document.getElementsByClassName("dropdown-content");
                                                for (var i = 0; i < dropdowns.length; i++) {
                                                    var openDropdown = dropdowns[i];
                                                    if (openDropdown.classList.contains('show')) {
                                                        openDropdown.classList.remove('show');
                                                    }
                                                }
                                            }
                                        }
                                    </script>

                                    <div class="tab-content">

                                        <!-- VISTA CONSULTAR -->
                                        <% if ("consultar".equals(currentView)) { String searchCity=(String)
                                            request.getAttribute("searchCity"); %>
                                            <div id="content-consultar" class="content active">
                                                <div class="sub-nav search-tabs-container">
                                                    <button type="button" id="btn-tab-generic" class="btn-tab active"
                                                        onclick="switchSearchTab('generic')">Búsqueda Genérica</button>
                                                    <button type="button" id="btn-tab-map" class="btn-tab"
                                                        onclick="switchSearchTab('map')">Búsqueda por Mapa</button>
                                                </div>

                                                <!-- GENERIC SEARCH FORM -->
                                                <div id="search-generic" class="search-tab-content">
                                                    <form action="app" method="post" class="search-form">
                                                        <input type="hidden" name="action" value="search">
                                                        <div class="form-group">
                                                            <label for="search-city-private">Ciudad:</label>
                                                            <select id="search-city-private" name="ciudad">
                                                                <option value="Vitoria" <%="Vitoria" .equals(searchCity)
                                                                    ? "selected" : "" %>>Vitoria</option>
                                                                <option value="Bilbo" <%="Bilbo" .equals(searchCity)
                                                                    ? "selected" : "" %>>Bilbo</option>
                                                                <option value="Donostia" <%="Donostia"
                                                                    .equals(searchCity) ? "selected" : "" %>>Donostia
                                                                </option>
                                                            </select>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="search-date-start">Fecha Inicio:</label>
                                                            <input type="date" id="search-date-start" name="fechaInicio"
                                                                min="<%= java.time.LocalDate.now() %>" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="search-date-end">Fecha Fin:</label>
                                                            <input type="date" id="search-date-end" name="fechaFin"
                                                                min="<%= java.time.LocalDate.now() %>" required>
                                                        </div>
                                                        <button type="submit">Buscar</button>
                                                    </form>
                                                </div>

                                                <!-- MAP SEARCH FORM -->
                                                <div id="search-map" class="search-tab-content" style="display:none;">
                                                    <form action="app" method="post" id="map-search-form">
                                                        <input type="hidden" name="action" value="search">
                                                        <input type="hidden" id="map-lat" name="lat">
                                                        <input type="hidden" id="map-lng" name="lng">
                                                        <input type="hidden" id="map-radius" name="radius" value="20">

                                                        <div class="map-slider-card">
                                                            <div class="map-slider-header">
                                                                <label class="map-slider-label">Radio
                                                                    de búsqueda: <span id="radius-val"
                                                                        class="map-slider-value">2
                                                                        km</span></label>
                                                            </div>
                                                            <input type="range" min="1" max="10" value="2"
                                                                class="slider map-slider-input" id="radius-slider">
                                                        </div>
                                                        <div id="map" class="map-container">
                                                        </div>




                                                        <!-- Search triggered automatically by map interaction -->
                                                    </form>
                                                    </form>
                                                </div>
                                                <div id="results-container-private" class="results-grid">
                                                    <% List<Habitacion> searchResults = (List<Habitacion>)
                                                            request.getAttribute("searchResults");
                                                            if (searchResults != null) {
                                                            for (Habitacion h : searchResults) {
                                                            String img = (h.getImagenHabitacion() != null) ?
                                                            h.getImagenHabitacion() :
                                                            "https://placehold.co/200x150?text=Sin+Foto";
                                                            %>
                                                            <div class="room-card" data-lat="<%= h.getLatitudH() %>"
                                                                data-lng="<%= h.getLongitudH() %>">
                                                                <img src="<%= img %>" alt="Foto de habitación"
                                                                    class="room-img">
                                                                <div class="room-info">
                                                                    <h4>
                                                                        <%= h.getDireccion() %>
                                                                    </h4>
                                                                    <p><strong>Ciudad:</strong>
                                                                        <%= h.getCiudad() %>
                                                                    </p>
                                                                    <p><strong>Precio:</strong>
                                                                        <%= h.getPrecioMes() %> €/mes
                                                                    </p>
                                                                </div>
                                                                <div class="room-actions">
                                                                    <button class="btn-solicitar"
                                                                        onclick="abrirModalSolicitud('<%= h.getCodHabi() %>', '<%= h.getDireccion() %>', <%= h.getPrecioMes() %>)">Solicitar
                                                                        📩</button>
                                                                </div>
                                                            </div>
                                                            <% } } if ((searchResults==null || searchResults.isEmpty())
                                                                && "search" .equals(request.getParameter("action"))) {
                                                                %>
                                                                <p>No se encontraron habitaciones.</p>
                                                                <% } %>
                                                </div>
                                            </div>
                                    </div>
                                    <% } %>

                                        <!-- VISTA HABITACIONES -->
                                        <% if ("habitaciones".equals(currentView)) { %>
                                            <div id="content-habitaciones" class="content active">
                                                <div class="sub-nav">
                                                    <h3>Añadir Habitación</h3>
                                                </div>
                                                <div id="view-anadir" class="subtab-content">
                                                    <form action="app" method="post" enctype="multipart/form-data"
                                                        class="room-form">
                                                        <input type="hidden" name="action" value="addRoom">
                                                        <div class="form-group">
                                                            <label for="room-address">Dirección:</label>
                                                            <input type="text" name="direccion" id="room-address"
                                                                placeholder="Ej: Calle Dato, 15" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="room-coords">Coordenadas (Lat,
                                                                Lng):</label>
                                                            <input type="text" name="coords" id="room-coords"
                                                                placeholder="Ej: 43.2611, -2.9332" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="room-city">Ciudad:</label>
                                                            <select name="ciudad" id="room-city" required>
                                                                <option value="" disabled selected>Selecciona
                                                                    una ciudad</option>
                                                                <option value="Vitoria">Vitoria
                                                                </option>
                                                                <option value="Bilbo">Bilbo</option>
                                                                <option value="Donostia">Donostia</option>
                                                            </select>
                                                        </div>
                                                        <div class="form-group">
                                                            <label for="room-price">Precio (€/mes):</label>
                                                            <input type="number" name="precio" id="room-price"
                                                                placeholder="Ej: 350" min="0" required>
                                                        </div>
                                                        <div class="form-group">
                                                            <label>Foto de la habitación:</label>
                                                            <input type="file" name="imagen" accept="image/*" required>
                                                        </div>
                                                        <button type="submit" class="btn-primary">Publicar
                                                            Habitación</button>
                                                    </form>
                                                </div>

                                                <div id="view-ver-mis-habi" class="subtab-content">
                                                    <h3>Mis Habitaciones Publicadas</h3>
                                                    <div class="results-grid">
                                                        <% List<Habitacion> misHabitaciones = (List<Habitacion>)
                                                                request.getAttribute("misHabitaciones");
                                                                if (misHabitaciones != null &&
                                                                !misHabitaciones.isEmpty()) {
                                                                for (Habitacion h : misHabitaciones) {
                                                                String img = (h.getImagenHabitacion() != null) ?
                                                                h.getImagenHabitacion() :
                                                                "https://placehold.co/200x150?text=Sin+Foto";
                                                                %>
                                                                <div class="room-card">
                                                                    <img src="<%= img %>" alt="Foto" class="room-img">
                                                                    <div class="room-info">
                                                                        <h4>
                                                                            <%= h.getDireccion() %>
                                                                        </h4>
                                                                        <p><strong>ID:</strong>
                                                                            <%= h.getCodHabi() %>
                                                                        </p>
                                                                        <p><strong>Ciudad:</strong>
                                                                            <%= h.getCiudad() %>
                                                                        </p>
                                                                        <p><strong>Precio:</strong>
                                                                            <%= h.getPrecioMes() %> €/mes
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <% } } else { %>
                                                                    <p>No tienes habitaciones publicadas.</p>
                                                                    <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>

                                                <!-- VISTA SOLICITUDES INQUILINO -->
                                                <% if ("inquilino_solicitudes".equals(currentView)) { %>
                                                    <div id="content-solicitudes" class="content active">
                                                        <h3>Mis Solicitudes Enviadas</h3>
                                                        <div class="results-grid">
                                                            <% List<Solicitud> misSolicitudes = (List<Solicitud>
                                                                    ) request.getAttribute("misSolicitudes");
                                                                    if (misSolicitudes != null &&
                                                                    !misSolicitudes.isEmpty()) {
                                                                    for (Solicitud s : misSolicitudes) {
                                                                    Habitacion h = s.getHabitacion();
                                                                    String img = (h != null &&
                                                                    h.getImagenHabitacion() != null) ?
                                                                    h.getImagenHabitacion() :
                                                                    "https://placehold.co/200x150?text=Sin+Foto";
                                                                    %>
                                                                    <div class="room-card">
                                                                        <img src="<%= img %>" alt="Foto"
                                                                            class="room-img">
                                                                        <div class="room-info">
                                                                            <h4>
                                                                                <%= (h !=null) ? h.getDireccion()
                                                                                    : "Desconocida" %>
                                                                            </h4>
                                                                            <p><strong>Estado:</strong> <span
                                                                                    class="status-<%= s.getEstado().toLowerCase() %>">
                                                                                    <%= s.getEstado() %>
                                                                                </span></p>
                                                                            <p><strong>Precio:</strong>
                                                                                <%= (h !=null) ? h.getPrecioMes() : 0 %>
                                                                                    €/mes
                                                                            </p>
                                                                            <p><small>Propietario: <%= (h !=null) ?
                                                                                        h.getEmailPropietario() : "" %>
                                                                                </small></p>
                                                                        </div>
                                                                    </div>
                                                                    <% } } else { %>
                                                                        <p>No has realizado ninguna solicitud.
                                                                        </p>
                                                                        <% } %>
                                                        </div>
                                                    </div>
                                                    <% } %>

                                                        <!-- VISTA ALQUILERES INQUILINO -->
                                                        <% if ("inquilino_alquileres".equals(currentView)) { %>
                                                            <div id="content-alquileres" class="content active">
                                                                <h3>Mis Alquileres</h3>
                                                                <div class="results-grid">
                                                                    <% List<Alquiler> misAlquileres = (List
                                                                        <Alquiler>)
                                                                            request.getAttribute("misAlquileres");
                                                                            if (misAlquileres != null &&
                                                                            !misAlquileres.isEmpty()) {
                                                                            for (Alquiler a : misAlquileres) {
                                                                            Habitacion h = a.getHabitacion();
                                                                            String img = (h != null &&
                                                                            h.getImagenHabitacion() != null) ?
                                                                            h.getImagenHabitacion() :
                                                                            "https://placehold.co/200x150?text=Sin+Foto";
                                                                            %>
                                                                            <div class="room-card">
                                                                                <img src="<%= img %>" alt="Foto"
                                                                                    class="room-img">
                                                                                <div class="room-info">
                                                                                    <h4>
                                                                                        <%= (h !=null) ?
                                                                                            h.getDireccion()
                                                                                            : "Desconocida" %>
                                                                                    </h4>
                                                                                    <p><strong>Precio:</strong>
                                                                                        <%= (h !=null) ?
                                                                                            h.getPrecioMes() : 0 %>
                                                                                            €/mes
                                                                                    </p>
                                                                                    <p><strong>Inquilino:</strong>
                                                                                        <%= a.getEmailInquilino() %>
                                                                                    </p>
                                                                                    <p><strong>Inicio:</strong>
                                                                                        <%= a.getFechaInicio() %>
                                                                                    </p>
                                                                                    <p><strong>Fin:</strong>
                                                                                        <%= a.getFechaFin() %>
                                                                                    </p>
                                                                                </div>
                                                                            </div>
                                                                            <% } } else { %>
                                                                                <p>No tienes alquileres activos.
                                                                                </p>
                                                                                <% } %>
                                                                </div>
                                                            </div>
                                                            <% } %>

                                                                <!-- VISTA PROPIETARIO SOLICITUDES -->
                                                                <% if ("propietario_solicitudes".equals(currentView)) {
                                                                    %>
                                                                    <div id="content-propietario"
                                                                        class="content active">
                                                                        <h3>Solicitudes Recibidas (Por Habitación)</h3>
                                                                        <div class="results-grid">
                                                                            <% java.util.Map<models.Habitacion,
                                                                                List<Solicitud>>
                                                                                solicitudesPorHabitacion =
                                                                                (java.util.Map<models.Habitacion,
                                                                                    List<Solicitud>>)
                                                                                    request.getAttribute("solicitudesPorHabitacion");

                                                                                    if (solicitudesPorHabitacion != null
                                                                                    &&
                                                                                    !solicitudesPorHabitacion.isEmpty())
                                                                                    {
                                                                                    for (java.util.Map.Entry
                                                                                    <models.Habitacion, List<Solicitud>>
                                                                                        entry :
                                                                                        solicitudesPorHabitacion.entrySet())
                                                                                        {
                                                                                        Habitacion h = entry.getKey();
                                                                                        List<Solicitud> reqs =
                                                                                            entry.getValue();
                                                                                            String img =
                                                                                            (h.getImagenHabitacion() !=
                                                                                            null) ?
                                                                                            h.getImagenHabitacion() :
                                                                                            "https://placehold.co/200x150?text=Sin+Foto";
                                                                                            %>
                                                                                            <div class="room-card"
                                                                                                style="display:block; width:100%;">
                                                                                                <img src="<%= img %>"
                                                                                                    alt="Foto"
                                                                                                    class="room-img"
                                                                                                    style="height: 200px;">
                                                                                                <div class="room-info"
                                                                                                    style="padding: 1.5rem;">
                                                                                                    <h4>
                                                                                                        <%= h.getDireccion()
                                                                                                            %>
                                                                                                    </h4>
                                                                                                    <p
                                                                                                        style="color:var(--text-secondary); font-size:0.9em; margin-bottom:5px;">
                                                                                                        ID: <%=
                                                                                                            h.getCodHabi()
                                                                                                            %>
                                                                                                    </p>
                                                                                                    <p><strong>
                                                                                                            <%= h.getCiudad()
                                                                                                                %>
                                                                                                        </strong></p>
                                                                                                    <p>
                                                                                                        <%= h.getPrecioMes()
                                                                                                            %> €/mes
                                                                                                    </p>
                                                                                                    <button
                                                                                                        type="button"
                                                                                                        class="btn-primary"
                                                                                                        style="margin-top:10px; width:100%;"
                                                                                                        onclick="toggleRequests('<%= h.getCodHabi() %>')">
                                                                                                        Ver posibles
                                                                                                        inquilinos (<%=
                                                                                                            reqs.size()
                                                                                                            %>)
                                                                                                    </button>
                                                                                                </div>

                                                                                                <!-- Nested Requests List (Hidden by default) -->
                                                                                                <div id="requests-<%= h.getCodHabi() %>"
                                                                                                    style="display:none; padding-top:10px; border-top:1px solid var(--border-color);">
                                                                                                    <% for (Solicitud s
                                                                                                        : reqs) {
                                                                                                        Usuario
                                                                                                        inquilino=s.getInquilino();
                                                                                                        String
                                                                                                        fotoInquilino=(inquilino
                                                                                                        !=null &&
                                                                                                        inquilino.getFoto()
                                                                                                        !=null) ?
                                                                                                        inquilino.getFoto()
                                                                                                        : "https://placehold.co/50x50?text=U"
                                                                                                        ; %>
                                                                                                        <div class="user-request-item"
                                                                                                            style="display:flex; justify-content:space-between; align-items:center; background:#f9fafb; padding:10px; border-radius:8px; margin-bottom:8px;">
                                                                                                            <div
                                                                                                                style="display:flex; align-items:center; gap:10px;">
                                                                                                                <img src="<%= fotoInquilino %>"
                                                                                                                    alt="User"
                                                                                                                    class="profile-pic-small">
                                                                                                                <div>
                                                                                                                    <h5
                                                                                                                        style="margin:0;">
                                                                                                                        <%= (inquilino
                                                                                                                            !=null)
                                                                                                                            ?
                                                                                                                            inquilino.getNombre()
                                                                                                                            : "Desconocido"
                                                                                                                            %>
                                                                                                                    </h5>
                                                                                                                    <small>
                                                                                                                        <%= s.getEmailInquilino()
                                                                                                                            %>
                                                                                                                    </small>
                                                                                                                    <br>
                                                                                                                    <span
                                                                                                                        style="font-size:0.85em; color:var(--text-secondary);">
                                                                                                                        <%= s.getFechaPosibleInicioAlquiler()
                                                                                                                            %>
                                                                                                                            -
                                                                                                                            <%= s.getFechaPosibleFinAlquiler()
                                                                                                                                %>
                                                                                                                    </span>
                                                                                                                    <br>
                                                                                                                    <span
                                                                                                                        class="status-<%= s.getEstado().toLowerCase() %>"
                                                                                                                        style="font-size:0.8em;">
                                                                                                                        <%= s.getEstado().substring(0,
                                                                                                                            1).toUpperCase()
                                                                                                                            +
                                                                                                                            s.getEstado().substring(1).toLowerCase()
                                                                                                                            %>
                                                                                                                    </span>
                                                                                                                </div>
                                                                                                            </div>

                                                                                                            <div
                                                                                                                class="actions">
                                                                                                                <% if
                                                                                                                    ("pendiente".equalsIgnoreCase(s.getEstado()))
                                                                                                                    { %>
                                                                                                                    <form
                                                                                                                        action="app"
                                                                                                                        method="post"
                                                                                                                        style="display:inline;">
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="action"
                                                                                                                            value="updateRequest">
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="codHabi"
                                                                                                                            value="<%= s.getCodHabi() %>">
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="emailInquilino"
                                                                                                                            value="<%= s.getEmailInquilino() %>">
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="nuevoEstado"
                                                                                                                            value="Aceptada">
                                                                                                                        <button
                                                                                                                            type="submit"
                                                                                                                            class="btn-accept"
                                                                                                                            title="Aceptar">✓</button>
                                                                                                                    </form>
                                                                                                                    <form
                                                                                                                        action="app"
                                                                                                                        method="post"
                                                                                                                        style="display:inline;">
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="action"
                                                                                                                            value="updateRequest">
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="codHabi"
                                                                                                                            value="<%= s.getCodHabi() %>">
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="emailInquilino"
                                                                                                                            value="<%= s.getEmailInquilino() %>">
                                                                                                                        <input
                                                                                                                            type="hidden"
                                                                                                                            name="nuevoEstado"
                                                                                                                            value="Rechazada">
                                                                                                                        <button
                                                                                                                            type="submit"
                                                                                                                            class="btn-reject"
                                                                                                                            title="Rechazar">✕</button>
                                                                                                                    </form>
                                                                                                                    <% }
                                                                                                                        %>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                        <% } %>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } } else { %>
                                                                                                <p>No tienes solicitudes
                                                                                                    entrantes.</p>
                                                                                                <% } %>
                                                                        </div>
                                                                    </div>
                                                                    <script>
                                                                        function toggleRequests(id) {
                                                                            var el = document.getElementById('requests-' + id);
                                                                            if (el.style.display === 'none') {
                                                                                el.style.display = 'block';
                                                                            } else {
                                                                                el.style.display = 'none';
                                                                            }
                                                                        }
                                                                    </script>
                                                                    <% } %>

                                                                        <!-- VISTA PROPIETARIO ALQUILERES -->
                                                                        <% if
                                                                            ("propietario_alquileres".equals(currentView))
                                                                            { %>
                                                                            <div id="content-propietario-alquileres"
                                                                                class="content active">
                                                                                <h3>Mis Alquileres en Propiedad</h3>
                                                                                <div class="results-grid">
                                                                                    <% List<Alquiler> misAlquileres =
                                                                                        (List<Alquiler>)
                                                                                            request.getAttribute("misAlquileres");
                                                                                            if (misAlquileres != null &&
                                                                                            !misAlquileres.isEmpty()) {
                                                                                            for (Alquiler a :
                                                                                            misAlquileres) {
                                                                                            Habitacion h =
                                                                                            a.getHabitacion();
                                                                                            String img = (h != null &&
                                                                                            h.getImagenHabitacion() !=
                                                                                            null) ?
                                                                                            h.getImagenHabitacion() :
                                                                                            "https://placehold.co/200x150?text=Sin+Foto";
                                                                                            %>
                                                                                            <div class="room-card">
                                                                                                <img src="<%= img %>"
                                                                                                    alt="Foto"
                                                                                                    class="room-img">
                                                                                                <div class="room-info">
                                                                                                    <h4>
                                                                                                        <%= (h !=null) ?
                                                                                                            h.getDireccion()
                                                                                                            : "Desconocida"
                                                                                                            %>
                                                                                                    </h4>
                                                                                                    <p><strong>Precio:</strong>
                                                                                                        <%= (h !=null) ?
                                                                                                            h.getPrecioMes()
                                                                                                            : 0 %>
                                                                                                            €/mes
                                                                                                    </p>
                                                                                                    <p><strong>Inquilino:</strong>
                                                                                                        <%= a.getEmailInquilino()
                                                                                                            %>
                                                                                                    </p>
                                                                                                    <p><strong>Inicio:</strong>
                                                                                                        <%= a.getFechaInicio()
                                                                                                            %>
                                                                                                    </p>
                                                                                                    <p><strong>Fin:</strong>
                                                                                                        <%= a.getFechaFin()
                                                                                                            %>
                                                                                                    </p>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } } else { %>
                                                                                                <p>No tienes alquileres
                                                                                                    activos en tus
                                                                                                    propiedades.</p>
                                                                                                <% } %>
                                                                                </div>
                                                                            </div>
                                                                            <% } %>

                                </div>
                                </div>

                                <!-- Modal para seleccionar fecha de solicitud -->
                                <div id="modal-solicitud" class="modal hidden" style="display: none;">
                                    <div class="modal-content">
                                        <div class="modal-header-icon">📅</div>
                                        <h3>Solicitar Alquiler</h3>
                                        <div id="modal-room-info" class="modal-room-info">
                                            <h4 id="modal-room-address"></h4>
                                            <p id="modal-room-price" class="price-tag"></p>
                                        </div>
                                        <form action="app" method="post">
                                            <input type="hidden" name="action" value="requestRoom">
                                            <input type="hidden" name="codHabi" id="modal-id-habitacion">
                                            <p class="modal-instruction">¿Estás seguro de que
                                                quieres solicitar esta
                                                habitación?</p>
                                            <div class="modal-actions">
                                                <button type="button" id="btn-cancelar-solicitud" class="btn-secondary"
                                                    onclick="cerrarModalSolicitud()">Cancelar</button>
                                                <button type="submit" class="btn-primary">Confirmar
                                                    Solicitud</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <script>
                                    function abrirModalSolicitud(id, direccion, precio) {
                                        document.getElementById('modal-id-habitacion').value = id;
                                        document.getElementById('modal-room-address').textContent = direccion;
                                        document.getElementById('modal-room-price').textContent = precio + " €/mes";
                                        document.getElementById('modal-solicitud').style.display = 'flex';
                                    }

                                    function cerrarModalSolicitud() {
                                        document.getElementById('modal-solicitud').style.display = 'none';
                                    }

                                    function switchSearchTab(tab) {
                                        // Update Buttons
                                        document.querySelectorAll('.btn-tab').forEach(b => b.classList.remove('active'));
                                        if (tab === 'generic') document.getElementById('btn-tab-generic').classList.add('active');
                                        else document.getElementById('btn-tab-map').classList.add('active');

                                        // Update Content
                                        document.querySelectorAll('.search-tab-content').forEach(c => c.style.display = 'none');
                                        if (tab === 'generic') document.getElementById('search-generic').style.display = 'block';
                                        else document.getElementById('search-map').style.display = 'block';

                                        // Resize map if visible
                                        if (tab === 'map' && map) {
                                            setTimeout(() => google.maps.event.trigger(map, 'resize'), 100);
                                        }
                                    }

                                    // Map Variables
                                    let map, centerMarker, searchCircle;
                                    let resultMarkers = [];

                                    async function initMap() {
                                        // Request needed libraries
                                        const { Map } = await google.maps.importLibrary("maps");
                                        const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

                                        const defaultCenter = { lat: 42.8467, lng: -2.6716 };

                                        map = new Map(document.getElementById("map"), {
                                            zoom: 10,
                                            center: defaultCenter,
                                            mapId: "DEMO_MAP_ID"
                                        });

                                        window.map = map;

                                        // Click Listener to set Search Center
                                        map.addListener("click", (e) => {
                                            placeCenterMarker(e.latLng);
                                        });

                                        // Slider Listener
                                        const slider = document.getElementById("radius-slider");
                                        const radiusVal = document.getElementById("radius-val");

                                        slider.addEventListener("input", function () {
                                            radiusVal.textContent = this.value + " km";
                                            if (searchCircle) {
                                                searchCircle.setRadius(parseInt(this.value) * 1000);
                                            }
                                        });

                                        slider.addEventListener("change", function () {
                                            const radius = parseInt(this.value);
                                            document.getElementById("map-radius").value = radius;
                                            if (searchCircle) {
                                                searchCircle.setRadius(radius * 1000);
                                            }
                                            // Trigger search on slider release if marker exists
                                            if (centerMarker) {
                                                buscarPorGeolocalizacion(centerMarker.position);
                                            }
                                        });

                                        // Initial Search if previous state exists
                                        const initLat = parseFloat(document.getElementById("map-lat").value);
                                        const initLng = parseFloat(document.getElementById("map-lng").value);

                                        if (!isNaN(initLat) && !isNaN(initLng)) {
                                            const latLng = { lat: initLat, lng: initLng };
                                            placeCenterMarker(latLng);
                                        }
                                    }

                                    async function placeCenterMarker(latLng) {
                                        // Remove old
                                        if (centerMarker) centerMarker.map = null;
                                        if (searchCircle) searchCircle.setMap(null);

                                        const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");

                                        // Create a pin for the center
                                        const pinElement = new PinElement({
                                            background: "#2563eb",
                                            borderColor: "#1e40af",
                                            glyphColor: "white",
                                            scale: 1.2
                                        });

                                        // Add Marker (Advanced)
                                        centerMarker = new AdvancedMarkerElement({
                                            map: map,
                                            position: latLng,
                                            title: "Centro de búsqueda",
                                            content: pinElement.element
                                        });

                                        // Create Circle (radius logic remains same)
                                        const radiusKm = parseInt(document.getElementById("radius-slider").value);
                                        searchCircle = new google.maps.Circle({
                                            strokeColor: "#2563eb",
                                            strokeOpacity: 0.8,
                                            strokeWeight: 2,
                                            fillColor: "#2563eb",
                                            fillOpacity: 0.2,
                                            map: map,
                                            center: latLng,
                                            radius: radiusKm * 1000
                                        });

                                        // Update Inputs
                                        let lat = (typeof latLng.lat === 'function') ? latLng.lat() : latLng.lat;
                                        let lng = (typeof latLng.lng === 'function') ? latLng.lng() : latLng.lng;

                                        document.getElementById("map-lat").value = lat;
                                        document.getElementById("map-lng").value = lng;

                                        // Trigger search
                                        const pos = { lat: lat, lng: lng };
                                        buscarPorGeolocalizacion(pos);
                                    }

                                    function buscarPorGeolocalizacion(center) {
                                        const radius = document.getElementById("radius-slider").value;
                                        const url = "app?action=search&responseMode=json" +
                                            "&lat=" + center.lat +
                                            "&lng=" + center.lng +
                                            "&radius=" + radius;

                                        fetch(url)
                                            .then(response => response.json())
                                            .then(data => {
                                                mostrarResultadosGeo(data);
                                            })
                                            .catch(error => console.error('Error:', error));
                                    }

                                    async function mostrarResultadosGeo(habitaciones) {
                                        console.log("Resultados recibidos:", habitaciones);
                                        const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");

                                        // Clear previous results markers
                                        resultMarkers.forEach(m => m.map = null);
                                        resultMarkers = [];

                                        const resultsContainer = document.getElementById('results-container-private');
                                        resultsContainer.innerHTML = "";

                                        if (habitaciones.length === 0) {
                                            resultsContainer.innerHTML = "<p>No se encontraron habitaciones en esta zona.</p>";
                                            return;
                                        }

                                        habitaciones.forEach(h => {
                                            // Add to List
                                            const cardDiv = document.createElement("div");
                                            cardDiv.className = "room-card";
                                            cardDiv.innerHTML =
                                                '<img src="' + h.imagen + '" alt="Foto de habitación" class="room-img">' +
                                                '<div class="room-info">' +
                                                '<h4>' + h.direccion + '</h4>' +
                                                '<p><strong>Ciudad:</strong> ' + h.ciudad + '</p>' +
                                                '<p><strong>Precio:</strong> ' + h.precio + ' €/mes</p>' +
                                                '<p><strong>Disponible:</strong> ' + h.fechaDisponible + '</p>' +
                                                '</div>' +
                                                '<div class="room-actions">' +
                                                '<button class="btn-solicitar" onclick="abrirModalSolicitud(\'' + h.codHabi + '\', \'' + h.direccion.replace(/'/g, "\\'") + '\', ' + h.precio + ')">Solicitar 📩</button>' +
                                                '</div>';
                                            resultsContainer.appendChild(cardDiv);

                                            // Add Marker
                                            if (h.lat && h.lng) {
                                                const pinResult = new PinElement({
                                                    background: "#ef4444",
                                                    borderColor: "#b91c1c",
                                                    glyphColor: "white",
                                                    scale: 1.0
                                                });

                                                const marker = new AdvancedMarkerElement({
                                                    map: map,
                                                    position: { lat: h.lat, lng: h.lng },
                                                    title: h.direccion,
                                                    content: pinResult.element
                                                });

                                                // InfoWindow
                                                // InfoWindow
                                                const infoWindow = new google.maps.InfoWindow();
                                                const contentString =
                                                    '<div style="text-align:center; width: 180px;">' +
                                                    '<img src="' + h.imagen + '" style="width:100%; height:100px; object-fit:cover; border-radius:8px; margin-bottom:8px;">' +
                                                    '<h5 style="margin:0 0 5px 0; font-size:14px;">' + h.direccion + '</h5>' +
                                                    '<p style="margin:0; font-size:12px; color:#555;">Disponible desde: ' + h.fechaDisponible + '</p>' +
                                                    '<p style="margin:0; font-size:10px; color:#777;">' + h.emailPropietario + '</p>' +
                                                    '<p style="margin:5px 0 0 0; font-weight:bold; color:#4f46e5;">' + h.precio + ' €/mes</p>' +
                                                    '<button onclick="abrirModalSolicitud(\'' + h.codHabi + '\', \'' + h.direccion.replace(/'/g, "\\'") + '\', ' + h.precio + ')" ' +
                                                    'style="margin-top:8px; padding:4px 10px; background:#4f46e5; color:white; border:none; border-radius:4px; cursor:pointer;">Solicitar</button>' +
                                                    '</div>';

                                                marker.addListener("click", () => {
                                                    infoWindow.setContent(contentString);
                                                    infoWindow.open(map, marker);
                                                });
                                                resultMarkers.push(marker);
                                            }
                                        });
                                    }

                                    // Placeholder for plotResults needed to avoid break if called
                                    function plotResults() { }

                                    function toggleDropdown(event) {
                                        event.stopPropagation();

                                        // Find the dropdown content relative to the clicked element (which is the .nav-tab container)
                                        var target = event.currentTarget;
                                        var content = target.querySelector('.dropdown-content');

                                        // Close all other dropdowns
                                        var dropdowns = document.getElementsByClassName("dropdown-content");
                                        for (var i = 0; i < dropdowns.length; i++) {
                                            var openDropdown = dropdowns[i];
                                            if (openDropdown !== content) {
                                                openDropdown.classList.remove('show');
                                            }
                                        }

                                        // Toggle the current one
                                        if (content) {
                                            content.classList.toggle("show");
                                        }
                                    }

                                    function cerrarModalSolicitud() {
                                        document.getElementById('modal-solicitud').style.display = 'none';
                                    }

                                    // Check if we should switch to map tab on load
                                    window.onload = function () {
                                        <% if ("geo".equals(request.getAttribute("searchResultType"))) { %>
                                            switchSearchTab('map');
                                        <% } %>
                                    };
                                </script>
                                <!-- REPLACE 'YOUR_API_KEY' WITH YOUR REAL GOOGLE MAPS API KEY -->
                                <script async defer
                                    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBvdjFYsyR3pApY0mFmXSIyewD6tTMlQGU&callback=initMap&libraries=places,marker"></script>
                        </body>

                        </html>