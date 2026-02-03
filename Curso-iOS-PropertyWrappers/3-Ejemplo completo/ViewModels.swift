//
//  ViewModels.swift
//  Curso-iOS-PropertyWrappers
//
//  Created by Equipo 2 on 2/2/26.
//

import SwiftUI

struct Articulo: Identifiable {
    let id = UUID()
    var titulo: String
    var completado = false
}

@Observable
class PerfilUsuario {
    var nombre = "María"
    var edad = 45
}

@Observable
class AppData {
    var articulos: [Articulo] = []
    var cargando = false
    var usuario = PerfilUsuario()
    
    func cargarDatos() async {
        cargando = true
        
        // simulamos una espera para cargar los datos desde internet
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            articulos = [
                Articulo(titulo: "Aprender SwiftUI"),
                Articulo(titulo: "Comprar el nuevo iPhone"),
                Articulo(titulo: "Viajar a Japón", completado: true)
            ]
            cargando = false
        }
    }
    
    func anadirArticulo(titulo: String) {
        articulos.append(Articulo(titulo: titulo))
    }
}
