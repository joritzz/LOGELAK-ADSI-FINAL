/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package models;

/**
 *
 * @author joritzz
 */
import java.util.Date;

public class Alquiler {
    private int idAlquiler;
    private int codHabi;
    private String emailInquilino;
    private Date fechaInicio;
    private Date fechaFin;

    // Transient
    private Habitacion habitacion;

    public Alquiler() {
    }

    public int getIdAlquiler() {
        return idAlquiler;
    }

    public void setIdAlquiler(int idAlquiler) {
        this.idAlquiler = idAlquiler;
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

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public Habitacion getHabitacion() {
        return habitacion;
    }

    public void setHabitacion(Habitacion habitacion) {
        this.habitacion = habitacion;
    }
}
