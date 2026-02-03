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
    
    var instanceId: ObjectIdentifier {
        ObjectIdentifier(self)
    }
    
    init() {
        print("Se ha creado una instancia de AppData: \(instanceId)")
    }
    deinit {
        print("Se ha destruido una instancia de AppData: \(instanceId)")
    }
    
    func cargarDatos() async {
        cargando = true
        print("cargando datos")
        
        // simulamos una espera para cargar los datos desde internet
//        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Forzar error y crash.
//        try! await Task.sleep(nanoseconds: 2_000_000_000)
        
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        // Controlamos error de cancelación (cuando el task se cancela al borrar la vista, entra por aquí)
        } catch is CancellationError {
            print("Se ha cancelado la carga de datos")
        // Aquí gestionamos todos los errores
        } catch {
            print("Otro error: \(error.localizedDescription)")
        }
        
        await MainActor.run {
            articulos = [
                Articulo(titulo: "Aprender SwiftUI"),
                Articulo(titulo: "Comprar el nuevo iPhone"),
                Articulo(titulo: "Viajar a Japón", completado: true)
            ]
            cargando = false
            print("datos cargados")
        }
    }
    
    func anadirArticulo(titulo: String) {
        articulos.append(Articulo(titulo: titulo))
    }
}
