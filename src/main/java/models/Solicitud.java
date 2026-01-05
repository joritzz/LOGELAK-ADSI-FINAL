/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author joritzz
 */
public class Solicitud {
    private int codHabi;
    private String emailInquilino;
    private String estado;

    public Solicitud() {
    }

    public int getCodHabi() {
        return codHabi;
    }

    public void setCodHabi(int codHabi) {
        this.codHabi = codHabi;
    }

    public String getEmailInquilino() {
        return emailInquilino;
    }

    public void setEmailInquilino(String emailInquilino) {
        this.emailInquilino = emailInquilino;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    private java.util.Date fechaPosibleInicioAlquiler;
    private java.util.Date fechaPosibleFinAlquiler;

    public java.util.Date getFechaPosibleInicioAlquiler() {
        return fechaPosibleInicioAlquiler;
    }

    public void setFechaPosibleInicioAlquiler(java.util.Date fechaPosibleInicioAlquiler) {
        this.fechaPosibleInicioAlquiler = fechaPosibleInicioAlquiler;
    }

    public java.util.Date getFechaPosibleFinAlquiler() {
        return fechaPosibleFinAlquiler;
    }

    public void setFechaPosibleFinAlquiler(java.util.Date fechaPosibleFinAlquiler) {
        this.fechaPosibleFinAlquiler = fechaPosibleFinAlquiler;
    }

    private Habitacion habitacion;
    private Usuario inquilino;

    public Habitacion getHabitacion() {
        return habitacion;
    }

    public void setHabitacion(Habitacion habitacion) {
        this.habitacion = habitacion;
    }

    public Usuario getInquilino() {
        return inquilino;
    }

    public void setInquilino(Usuario inquilino) {
        this.inquilino = inquilino;
    }
}