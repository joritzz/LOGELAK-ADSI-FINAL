/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.MultipartConfig;

/**
 *
 * @author joritzz
 */
@MultipartConfig
@WebServlet(name = "app", urlPatterns = { "/app" })
public class app extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // 1. Session Validation
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        models.Usuario usuario = (session != null) ? (models.Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Initialize BD connection (safe to call multiple times if handled in BD)
        utils.BD.getConexion();

        String result = "";
        String view = request.getParameter("view");
        String action = request.getParameter("action");

        if (view == null) {
            view = "consultar"; // Default view
        }

        try {
            // 2. Action Handling
            if (action != null) {
                switch (action) {
                    case "logout":
                        session.invalidate();
                        response.sendRedirect("index.jsp");
                        return;

                    case "search":
                        String ciudad = request.getParameter("ciudad");
                        String fechaInicioStr = request.getParameter("fechaInicio");
                        String fechaFinStr = request.getParameter("fechaFin");
                        String latStr = request.getParameter("lat");
                        String lngStr = request.getParameter("lng");

                        if ((fechaInicioStr != null && !fechaInicioStr.isEmpty() && fechaFinStr != null
                                && !fechaFinStr.isEmpty()) ||
                                (latStr != null && !latStr.isEmpty() && lngStr != null && !lngStr.isEmpty())) {

                            java.util.Date fechaInicio = null;
                            java.util.Date fechaFin = null;

                            if (fechaInicioStr != null && !fechaInicioStr.isEmpty() && fechaFinStr != null
                                    && !fechaFinStr.isEmpty()) {
                                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                                fechaInicio = sdf.parse(fechaInicioStr);
                                fechaFin = sdf.parse(fechaFinStr);
                            }

                            java.util.List<models.Habitacion> habitaciones;

                            // If geolocation is provided
                            if (latStr != null && !latStr.isEmpty() && lngStr != null && !lngStr.isEmpty()) {
                                double myLat = Double.parseDouble(latStr);
                                double myLng = Double.parseDouble(lngStr);

                                double radius = 20.0; // Default
                                String radiusStr = request.getParameter("radius");
                                if (radiusStr != null && !radiusStr.isEmpty()) {
                                    try {
                                        radius = Double.parseDouble(radiusStr);
                                    } catch (NumberFormatException e) {
                                        // Keep default
                                    }
                                }

                                habitaciones = utils.BD.getHabitacionesCercanas(myLat, myLng, radius, fechaInicio,
                                        fechaFin, usuario.getEmail());
                                request.setAttribute("searchResultType", "geo");
                                request.setAttribute("searchLat", myLat);
                                request.setAttribute("searchLng", myLng);
                                request.setAttribute("searchRadius", radius);
                            } else {
                                // Standard City Search (Dates Required)
                                if (fechaInicio != null && fechaFin != null) {
                                    habitaciones = utils.BD.getHabitacionesDisponibles(ciudad, fechaInicio, fechaFin,
                                            usuario.getEmail());
                                } else {
                                    habitaciones = new java.util.ArrayList<>(); // Should not happen given outer if, but
                                                                                // safety
                                }
                            }

                            // JSON Response for AJAX
                            String responseMode = request.getParameter("responseMode");
                            if ("json".equals(responseMode)) {
                                response.setContentType("application/json");
                                response.setCharacterEncoding("UTF-8");
                                java.io.PrintWriter out = response.getWriter();
                                out.print("[");
                                for (int i = 0; i < habitaciones.size(); i++) {
                                    models.Habitacion h = habitaciones.get(i);
                                    String img = (h.getImagenHabitacion() != null)
                                            ? h.getImagenHabitacion().replace("\\", "/")
                                            : "https://placehold.co/200x150?text=Sin+Foto";
                                    String direccion = (h.getDireccion() != null)
                                            ? h.getDireccion().replace("\"", "\\\"")
                                            : "";
                                    String ciudadH = (h.getCiudad() != null) ? h.getCiudad().replace("\"", "\\\"") : "";
                                    String email = (h.getEmailPropietario() != null)
                                            ? h.getEmailPropietario().replace("\"", "\\\"")
                                            : "";

                                    out.print("{");
                                    out.print("\"codHabi\": " + h.getCodHabi() + ",");
                                    out.print("\"lat\": " + h.getLatitudH() + ",");
                                    out.print("\"lng\": " + h.getLongitudH() + ",");
                                    out.print("\"direccion\": \"" + direccion + "\",");
                                    out.print("\"ciudad\": \"" + ciudadH + "\",");
                                    out.print("\"emailPropietario\": \"" + email + "\",");
                                    out.print("\"precio\": " + h.getPrecioMes() + ",");
                                    out.print("\"imagen\": \"" + img + "\",");
                                    out.print("\"fechaDisponible\": \""
                                            + utils.BD.getProximaFechaDisponible(h.getCodHabi()) + "\"");
                                    out.print("}");
                                    if (i < habitaciones.size() - 1)
                                        out.print(",");
                                }
                                out.print("]");
                                out.flush();
                                System.out.println("JSON Response sent. Rooms count: " + habitaciones.size());
                                return; // Stop execution here, do not forward to JSP
                            }

                            request.setAttribute("searchResults", habitaciones);
                            request.setAttribute("searchCity", ciudad); // To keep selected option
                            request.setAttribute("searchDateStart", fechaInicioStr);
                            request.setAttribute("searchDateEnd", fechaFinStr);
                        }
                        view = "consultar";
                        break;

                    case "addRoom":
                        String direccion = request.getParameter("direccion");
                        String ciudadRoom = request.getParameter("ciudad");
                        System.out.println("Processing addRoom: Dir=" + direccion + ", Ciudad=" + ciudadRoom);

                        int precio = request.getParameter("precio") != null
                                ? Integer.parseInt(request.getParameter("precio"))
                                : 0;

                        // Handle File Upload
                        String imagenPath = "https://placehold.co/600x400?text=Sin+Foto"; // Default
                        try {
                            jakarta.servlet.http.Part filePart = request.getPart("imagen");
                            if (filePart != null && filePart.getSize() > 0) {
                                String fileName = java.nio.file.Paths.get(filePart.getSubmittedFileName()).getFileName()
                                        .toString();
                                // Clean filename to avoid issues
                                fileName = System.currentTimeMillis() + "_" + fileName.replaceAll("\\s+", "_");

                                String uploadPath = getServletContext().getRealPath("") + java.io.File.separator
                                        + "image";
                                java.io.File uploadDir = new java.io.File(uploadPath);
                                if (!uploadDir.exists())
                                    uploadDir.mkdir();

                                String fullPath = uploadPath + java.io.File.separator + fileName;
                                System.out.println("Uploading to: " + fullPath);
                                filePart.write(fullPath);

                                imagenPath = "image/" + fileName;
                            }
                        } catch (Exception ex) {
                            System.out.println("Error uploading file: " + ex.getMessage());
                            ex.printStackTrace();
                        }

                        String coords = request.getParameter("coords");
                        double lat = 0, lng = 0;
                        if (coords != null && coords.contains(",")) {
                            try {
                                String[] parts = coords.split(",");
                                lat = Double.parseDouble(parts[0].trim());
                                lng = Double.parseDouble(parts[1].trim());
                            } catch (NumberFormatException nfe) {
                                System.out.println("Error parsing coords: " + nfe.getMessage());
                            }
                        }

                        models.Habitacion h = new models.Habitacion();
                        h.setEmailPropietario(usuario.getEmail());
                        h.setDireccion(direccion);
                        h.setCiudad(ciudadRoom);
                        h.setPrecioMes(precio);
                        h.setLatitudH(lat);
                        h.setLongitudH(lng);
                        h.setImagenHabitacion(imagenPath);

                        utils.BD.insertHabitacion(h);
                        result = "Habitación publicada correctamente.";
                        view = "habitaciones";
                        break;

                    case "requestRoom":
                        int codHabi = Integer.parseInt(request.getParameter("codHabi"));
                        String fInicio = request.getParameter("fechaInicio");
                        String fFin = request.getParameter("fechaFin");

                        models.Solicitud s = new models.Solicitud();
                        s.setCodHabi(codHabi);
                        s.setEmailInquilino(usuario.getEmail());
                        s.setEstado("Pendiente");

                        if (fInicio != null && !fInicio.isEmpty() && fFin != null && !fFin.isEmpty()) {
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                            s.setFechaPosibleInicioAlquiler(sdf.parse(fInicio));
                            s.setFechaPosibleFinAlquiler(sdf.parse(fFin));
                        } else {
                            // Fallback or error handling if dates are missing, though UI enforces them
                            s.setFechaPosibleInicioAlquiler(new java.util.Date()); // Prevents null pointer in BD
                            s.setFechaPosibleFinAlquiler(new java.util.Date());
                        }

                        boolean inserted = utils.BD.insertSolicitud(s);
                        if (inserted) {
                            result = "Solicitud enviada.";
                        } else {
                            result = "Error: Ya has enviado una solicitud para esta habitación (o ocurrió un error interno).";
                        }
                        view = "inquilino_solicitudes"; // Redirect to specific view
                        break;

                    case "updateRequest":
                        int codHabiReq = Integer.parseInt(request.getParameter("codHabi"));
                        String emailInquilino = request.getParameter("emailInquilino");
                        String nuevoEstado = request.getParameter("nuevoEstado");
                        String fechaInicioStrRequest = request.getParameter("fechaInicio");
                        String fechaFinStrRequest = request.getParameter("fechaFin");

                        java.util.Date fechaInicioRequest = null;
                        java.util.Date fechaFinRequest = null;
                        try {
                            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                            if (fechaInicioStrRequest != null && !fechaInicioStrRequest.isEmpty()) {
                                fechaInicioRequest = sdf.parse(fechaInicioStrRequest);
                            }
                            if (fechaFinStrRequest != null && !fechaFinStrRequest.isEmpty()) {
                                fechaFinRequest = sdf.parse(fechaFinStrRequest);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        utils.BD.updateEstadoSolicitud(codHabiReq, emailInquilino, fechaInicioRequest, nuevoEstado);

                        if ("Aceptada".equals(nuevoEstado)) {
                            // Crear alquiler
                            models.Alquiler a = new models.Alquiler();
                            a.setCodHabi(codHabiReq);
                            a.setEmailInquilino(emailInquilino);
                            if (fechaInicioRequest != null)
                                a.setFechaInicio(fechaInicioRequest);
                            if (fechaFinRequest != null)
                                a.setFechaFin(fechaFinRequest);
                            utils.BD.insertAlquiler(a);
                        }

                        result = "Solicitud " + nuevoEstado.toLowerCase() + ".";
                        view = "propietario";
                        break;
                }
            }
        } catch (

        Exception e) {
            e.printStackTrace();
            result = "Error: " + e.getMessage();
        }

        // 3. View Data Loading
        switch (view) {
            case "habitaciones":
                java.util.List<models.Habitacion> misHabitaciones = utils.BD.getMisHabitaciones(usuario.getEmail());
                request.setAttribute("misHabitaciones", misHabitaciones);
                break;
            case "inquilino_solicitudes":
                java.util.List<models.Solicitud> misSolicitudes = utils.BD.getMisSolicitudes(usuario.getEmail());
                request.setAttribute("misSolicitudes", misSolicitudes);
                break;
            case "inquilino_alquileres":
                java.util.List<models.Alquiler> misAlquileresInquilino = utils.BD
                        .getAlquileresComoInquilino(usuario.getEmail());
                request.setAttribute("misAlquileres", misAlquileresInquilino);
                break;
            case "propietario_solicitudes":
                java.util.List<models.Solicitud> solicitudesEntrantes = utils.BD
                        .getSolicitudesEntrantes(usuario.getEmail());
                // Group requests by Habitacion
                java.util.Map<Integer, java.util.List<models.Solicitud>> solicitudesPorHabitacion = new java.util.HashMap<>();
                for (models.Solicitud s : solicitudesEntrantes) {
                    models.Habitacion h = s.getHabitacion();
                    if (h != null) {
                        solicitudesPorHabitacion.computeIfAbsent(h.getCodHabi(), k -> new java.util.ArrayList<>())
                                .add(s);
                    }
                }
                request.setAttribute("solicitudesPorHabitacion", solicitudesPorHabitacion);
                break;
            case "propietario_alquileres":
                java.util.List<models.Alquiler> misAlquileresPropietario = utils.BD
                        .getAlquileresComoPropietario(usuario.getEmail());
                request.setAttribute("misAlquileres", misAlquileresPropietario); // Reuse attribute name or use
                                                                                 // separate? "misAlquileres" is fine if
                                                                                 // JSP adapts
                break;
            // Legacy/Direct mappings if needed fallback, or just for "Consultar"
        }

        request.setAttribute("currentView", view);
        if (!result.isEmpty()) {
            request.setAttribute("result", result);
        }

        request.getRequestDispatcher("app.jsp").forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
