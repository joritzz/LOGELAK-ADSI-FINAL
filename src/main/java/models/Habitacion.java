/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author joritzz
 */
public class Habitacion {
    private int codHabi;
    private String emailPropietario;
    private String direccion;
    private String ciudad;
    private int precioMes;
    private double latitudH;
    private double longitudH;
    private String imagenHabitacion;

    public Habitacion() {
    }

    public int getCodHabi() {
        return codHabi;
    }

    public void setCodHabi(int codHabi) {
        this.codHabi = codHabi;
    }

    public String getEmailPropietario() {
        return emailPropietario;
    }

    public void setEmailPropietario(String emailPropietario) {
        this.emailPropietario = emailPropietario;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public int getPrecioMes() {
        return precioMes;
    }

    public void setPrecioMes(int precioMes) {
        this.precioMes = precioMes;
    }

    public double getLatitudH() {
        return latitudH;
    }

    public void setLatitudH(double latitudH) {
        this.latitudH = latitudH;
    }

    public double getLongitudH() {
        return longitudH;
    }

    public void setLongitudH(double longitudH) {
        this.longitudH = longitudH;
    }

    public String getImagenHabitacion() {
        return imagenHabitacion;
    }

    public void setImagenHabitacion(String imagenHabitacion) {
        this.imagenHabitacion = imagenHabitacion;
    }

}
