/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author joritzz
 */
public class Usuario {
    private String email;
    private String password;
    private String nombre;
    private String imagenUsuario;

    public Usuario() {
    }

    public Usuario(String email, String nombre, String password, String imagenUsuario) {
        this.email = email;
        this.nombre = nombre;
        this.password = password;
        this.imagenUsuario = imagenUsuario;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFoto() {
        return imagenUsuario;
    }

    public void setFoto(String imagenUsuario) {
        this.imagenUsuario = imagenUsuario;
    }
}
