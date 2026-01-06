/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.*;
import java.util.*;
import java.util.Date;

import models.*;

/**
 *
 * @author MCO
 */
public class BD {

    private static Connection conn;

    public static Connection getConexion() {
        if (conn == null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/logelakbd?serverTimezone=UTC", "root",
                        "root");
                System.out.println("Se ha conectado.");
            } catch (ClassNotFoundException ex1) {
                System.out.println("No se ha conectado: " + ex1);
            } catch (SQLException ex2) {
                System.out.println("No se ha conectado:" + ex2);
            }
        }
        return conn;
    }

    // ----------------------------------------------------------------------------------------------------------------------------------
    public static List<Habitacion> getHabitacionesDisponibles(String ciudad, Date fechaInicio, Date fechaFin,
            String excludeEmail) {
        List<Habitacion> lista = new ArrayList<>();
        String sql = "SELECT * FROM habitacion h WHERE h.ciudad = ? AND (? IS NULL OR h.emailPropietario != ?) AND NOT EXISTS ("
                +
                "SELECT * FROM alquiler a WHERE a.codHabi = h.codHabi AND " +
                "(a.fechaInicioAlqui <= ? AND a.fechaFinAlqui >= ?))";

        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, ciudad);
            pstmt.setString(2, excludeEmail);
            pstmt.setString(3, excludeEmail);
            pstmt.setDate(4, new java.sql.Date(fechaFin.getTime()));
            pstmt.setDate(5, new java.sql.Date(fechaInicio.getTime()));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Habitacion h = new Habitacion();
                    h.setCodHabi(rs.getInt("codHabi"));
                    h.setEmailPropietario(rs.getString("emailPropietario"));
                    h.setDireccion(rs.getString("dirección"));
                    h.setCiudad(rs.getString("ciudad"));
                    h.setPrecioMes(rs.getInt("precioMes"));
                    h.setLatitudH(rs.getDouble("latitudH"));
                    h.setLongitudH(rs.getDouble("longitudH"));
                    h.setImagenHabitacion(rs.getString("imagenHabitacion"));
                    lista.add(h);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static List<Habitacion> getHabitacionesCercanas(double myLat, double myLng, double radioKm, Date fechaInicio,
            Date fechaFin, String excludeEmail) {
        List<Habitacion> lista = new ArrayList<>();
        // Haversine formula in SQL
        String sql;
        boolean checkDates = (fechaInicio != null && fechaFin != null);

        if (checkDates) {
            sql = "SELECT h.*, " +
                    " (6371 * acos(cos(radians(?)) * cos(radians(latitudH)) * cos(radians(longitudH) - radians(?)) + sin(radians(?)) * sin(radians(latitudH)))) AS distancia"
                    +
                    " FROM habitacion h" +
                    " WHERE (? IS NULL OR h.emailPropietario != ?) AND NOT EXISTS (" +
                    "   SELECT * FROM alquiler a WHERE a.codHabi = h.codHabi AND" +
                    "   (a.fechaInicioAlqui <= ? AND a.fechaFinAlqui >= ?)" +
                    " )" +
                    " HAVING distancia < ?" +
                    " ORDER BY distancia";
        } else {
            sql = "SELECT h.*, " +
                    " (6371 * acos(cos(radians(?)) * cos(radians(latitudH)) * cos(radians(longitudH) - radians(?)) + sin(radians(?)) * sin(radians(latitudH)))) AS distancia"
                    +
                    " FROM habitacion h" +
                    " WHERE (? IS NULL OR h.emailPropietario != ?)" +
                    " HAVING distancia < ?" +
                    " ORDER BY distancia";
        }

        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setDouble(1, myLat);
            pstmt.setDouble(2, myLng);
            pstmt.setDouble(3, myLat);
            pstmt.setString(4, excludeEmail);
            pstmt.setString(5, excludeEmail);

            if (checkDates) {
                pstmt.setDate(6, new java.sql.Date(fechaFin.getTime()));
                pstmt.setDate(7, new java.sql.Date(fechaInicio.getTime()));
                pstmt.setDouble(8, radioKm);
                System.out.println("Executing SQL (Dates): Lat=" + myLat + ", Lng=" + myLng + ", Radius=" + radioKm);
            } else {
                pstmt.setDouble(6, radioKm);
                System.out.println("Executing SQL (No Dates): Lat=" + myLat + ", Lng=" + myLng + ", Radius=" + radioKm);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Habitacion h = new Habitacion();
                    h.setCodHabi(rs.getInt("codHabi"));
                    h.setEmailPropietario(rs.getString("emailPropietario"));
                    h.setDireccion(rs.getString("dirección"));
                    h.setCiudad(rs.getString("ciudad"));
                    h.setPrecioMes(rs.getInt("precioMes"));
                    h.setLatitudH(rs.getDouble("latitudH"));
                    h.setLongitudH(rs.getDouble("longitudH"));
                    h.setImagenHabitacion(rs.getString("imagenHabitacion"));
                    lista.add(h);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error en Geolocation: " + e.getMessage());
        }
        return lista;
    }

    public static List<Habitacion> getMisHabitaciones(String emailPropietario) {
        List<Habitacion> lista = new ArrayList<>();
        String sql = "SELECT * FROM habitacion WHERE emailPropietario = ?";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, emailPropietario);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Habitacion h = new Habitacion();
                    h.setCodHabi(rs.getInt("codHabi"));
                    h.setEmailPropietario(rs.getString("emailPropietario"));
                    h.setDireccion(rs.getString("dirección"));
                    h.setCiudad(rs.getString("ciudad"));
                    h.setPrecioMes(rs.getInt("precioMes"));
                    h.setLatitudH(rs.getDouble("latitudH"));
                    h.setLongitudH(rs.getDouble("longitudH"));
                    h.setImagenHabitacion(rs.getString("imagenHabitacion"));
                    lista.add(h);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static void insertHabitacion(Habitacion h) {
        String sql = "INSERT INTO habitacion (emailPropietario, dirección, ciudad, precioMes, latitudH, longitudH, imagenHabitacion) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, h.getEmailPropietario());
            pstmt.setString(2, h.getDireccion());
            pstmt.setString(3, h.getCiudad());
            pstmt.setInt(4, h.getPrecioMes());
            pstmt.setDouble(5, h.getLatitudH());
            pstmt.setDouble(6, h.getLongitudH());
            pstmt.setString(7, h.getImagenHabitacion());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static boolean insertSolicitud(Solicitud s) {
        String sql = "INSERT INTO solicitud (codHabi, emailInquilino, estado, fechaPosibleInicioAlquiler, fechaPosibleFinAlquiler) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setInt(1, s.getCodHabi());
            pstmt.setString(2, s.getEmailInquilino());
            pstmt.setString(3, s.getEstado());
            pstmt.setDate(4, new java.sql.Date(s.getFechaPosibleInicioAlquiler().getTime()));
            pstmt.setDate(5, new java.sql.Date(s.getFechaPosibleFinAlquiler().getTime()));
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<Solicitud> getMisSolicitudes(String emailInquilino) {
        List<Solicitud> lista = new ArrayList<>();
        String sql = "SELECT s.*, h.dirección, h.precioMes, h.imagenHabitacion, h.emailPropietario FROM solicitud s JOIN habitacion h ON s.codHabi = h.codHabi WHERE s.emailInquilino = ?";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, emailInquilino);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Solicitud s = new Solicitud();
                    s.setCodHabi(rs.getInt("codHabi"));
                    s.setEmailInquilino(rs.getString("emailInquilino"));
                    s.setEstado(rs.getString("estado"));
                    s.setFechaPosibleInicioAlquiler(rs.getDate("fechaPosibleInicioAlquiler"));
                    s.setFechaPosibleFinAlquiler(rs.getDate("fechaPosibleFinAlquiler"));

                    Habitacion h = new Habitacion();
                    h.setDireccion(rs.getString("dirección"));
                    h.setPrecioMes(rs.getInt("precioMes"));
                    h.setImagenHabitacion(rs.getString("imagenHabitacion"));
                    h.setEmailPropietario(rs.getString("emailPropietario"));
                    s.setHabitacion(h);
                    lista.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static List<Solicitud> getSolicitudesEntrantes(String emailPropietario) {
        List<Solicitud> lista = new ArrayList<>();
        String sql = "SELECT s.*, h.dirección, h.precioMes, h.ciudad, h.imagenHabitacion, u.nombre, u.imagenUsuario FROM solicitud s "
                +
                "JOIN habitacion h ON s.codHabi = h.codHabi " +
                "JOIN usuario u ON s.emailInquilino = u.email " +
                "WHERE h.emailPropietario = ? AND s.estado = 'pendiente'";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, emailPropietario);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Solicitud s = new Solicitud();
                    s.setCodHabi(rs.getInt("codHabi"));
                    s.setEmailInquilino(rs.getString("emailInquilino"));
                    s.setEstado(rs.getString("estado"));
                    s.setFechaPosibleInicioAlquiler(rs.getDate("fechaPosibleInicioAlquiler"));
                    s.setFechaPosibleFinAlquiler(rs.getDate("fechaPosibleFinAlquiler"));

                    Habitacion h = new Habitacion();
                    h.setCodHabi(rs.getInt("codHabi"));
                    h.setDireccion(rs.getString("dirección"));
                    h.setPrecioMes(rs.getInt("precioMes"));
                    h.setCiudad(rs.getString("ciudad"));
                    h.setImagenHabitacion(rs.getString("imagenHabitacion"));
                    s.setHabitacion(h);

                    Usuario u = new Usuario();
                    u.setNombre(rs.getString("nombre"));
                    u.setFoto(rs.getString("imagenUsuario"));
                    s.setInquilino(u);

                    lista.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static void updateEstadoSolicitud(int codHabi, String emailInquilino, java.util.Date fechaInicio,
            String estado) {
        String sql = "UPDATE solicitud SET estado = ? WHERE codHabi = ? AND emailInquilino = ? AND fechaPosibleInicioAlquiler = ?";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, estado);
            pstmt.setInt(2, codHabi);
            pstmt.setString(3, emailInquilino);
            pstmt.setDate(4, new java.sql.Date(fechaInicio.getTime()));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void insertAlquiler(Alquiler a) {
        String sql = "INSERT INTO alquiler (codHabi, emailInquilino, fechaInicioAlqui, fechaFinAlqui) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setInt(1, a.getCodHabi());
            pstmt.setString(2, a.getEmailInquilino());
            pstmt.setDate(3, new java.sql.Date(a.getFechaInicio().getTime()));
            pstmt.setDate(4, new java.sql.Date(a.getFechaFin().getTime()));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static List<Alquiler> getAlquileres(String email) {
        List<Alquiler> lista = new ArrayList<>();
        String sql = "SELECT a.*, h.dirección, h.precioMes, h.imagenHabitacion FROM alquiler a " +
                "JOIN habitacion h ON a.codHabi = h.codHabi " +
                "WHERE a.emailInquilino = ? OR h.emailPropietario = ?";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Alquiler a = new Alquiler();
                    a.setIdAlquiler(rs.getInt("idAlquiler"));
                    a.setCodHabi(rs.getInt("codHabi"));
                    a.setEmailInquilino(rs.getString("emailInquilino"));
                    a.setFechaInicio(rs.getDate("fechaInicioAlqui"));
                    a.setFechaFin(rs.getDate("fechaFinAlqui"));

                    Habitacion h = new Habitacion();
                    h.setDireccion(rs.getString("dirección"));
                    h.setPrecioMes(rs.getInt("precioMes"));
                    h.setImagenHabitacion(rs.getString("imagenHabitacion"));
                    a.setHabitacion(h);

                    lista.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static List<Alquiler> getAlquileresComoInquilino(String email) {
        List<Alquiler> lista = new ArrayList<>();
        String sql = "SELECT a.*, h.dirección, h.precioMes, h.imagenHabitacion FROM alquiler a " +
                "JOIN habitacion h ON a.codHabi = h.codHabi " +
                "WHERE a.emailInquilino = ? " +
                "ORDER BY a.codHabi, a.fechaInicioAlqui DESC";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Alquiler a = new Alquiler();
                    a.setIdAlquiler(rs.getInt("idAlquiler"));
                    a.setCodHabi(rs.getInt("codHabi"));
                    a.setEmailInquilino(rs.getString("emailInquilino"));
                    a.setFechaInicio(rs.getDate("fechaInicioAlqui"));
                    a.setFechaFin(rs.getDate("fechaFinAlqui"));

                    Habitacion h = new Habitacion();
                    h.setDireccion(rs.getString("dirección"));
                    h.setPrecioMes(rs.getInt("precioMes"));
                    h.setImagenHabitacion(rs.getString("imagenHabitacion"));
                    a.setHabitacion(h);

                    lista.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static List<Alquiler> getAlquileresComoPropietario(String email) {
        List<Alquiler> lista = new ArrayList<>();
        String sql = "SELECT a.*, h.dirección, h.precioMes, h.imagenHabitacion FROM alquiler a " +
                "JOIN habitacion h ON a.codHabi = h.codHabi " +
                "WHERE h.emailPropietario = ? ORDER BY h.codHabi, a.fechaInicioAlqui DESC";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Alquiler a = new Alquiler();
                    a.setIdAlquiler(rs.getInt("idAlquiler"));
                    a.setCodHabi(rs.getInt("codHabi"));
                    a.setEmailInquilino(rs.getString("emailInquilino"));
                    a.setFechaInicio(rs.getDate("fechaInicioAlqui"));
                    a.setFechaFin(rs.getDate("fechaFinAlqui"));

                    Habitacion h = new Habitacion();
                    h.setDireccion(rs.getString("dirección"));
                    h.setPrecioMes(rs.getInt("precioMes"));
                    h.setImagenHabitacion(rs.getString("imagenHabitacion"));
                    a.setHabitacion(h);

                    lista.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public static Solicitud getSolicitud(int codHabi, String emailInquilino) {
        String sql = "SELECT * FROM solicitud WHERE codHabi = ? AND emailInquilino = ?";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setInt(1, codHabi);
            pstmt.setString(2, emailInquilino);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Solicitud s = new Solicitud();
                    s.setCodHabi(rs.getInt("codHabi"));
                    s.setEmailInquilino(rs.getString("emailInquilino"));
                    s.setEstado(rs.getString("estado"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static Usuario login(String email, String password) {
        String sql = "SELECT * FROM usuario WHERE email = ? AND contraseña = ?";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setEmail(rs.getString("email"));
                    u.setNombre(rs.getString("nombre"));
                    u.setPassword(rs.getString("contraseña"));
                    u.setFoto(rs.getString("imagenUsuario"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static java.sql.Date getProximaFechaDisponible(int codHabi) {
        String sql = "SELECT GREATEST(CURDATE(), COALESCE(MAX(DATE_ADD(fechaFinAlqui, INTERVAL 1 DAY)), CURDATE())) FROM alquiler WHERE codHabi = ?";
        try (PreparedStatement pstmt = getConexion().prepareStatement(sql)) {
            pstmt.setInt(1, codHabi);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDate(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new java.sql.Date(System.currentTimeMillis());
    }

}
