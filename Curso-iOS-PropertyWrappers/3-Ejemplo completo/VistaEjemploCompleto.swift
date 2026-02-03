//
//  VistaEjemploCompleto.swift
//  Curso-iOS-PropertyWrappers
//
//  Created by Equipo 2 on 2/2/26.
//

import SwiftUI

struct VistaEjemploCompleto: View {
    
    @Environment(AppData.self) var appData
    
    @State private var ocultarCompletados = false
    @State private var mostrarPerfilUsuario = false
    @State private var nuevoArticulo = ""
    
    var body: some View {
        @Bindable var datosBindable = appData
        
        NavigationStack {
            VStack {
                Toggle("Ocultar completados", isOn: $ocultarCompletados)
                
                if appData.cargando {
                    ProgressView("Cargando datos")
                } else {
                    List {
                        ForEach($datosBindable.articulos) { $articulo in
                            if !ocultarCompletados || !articulo.completado {
                                FilaArticulo(articulo: $articulo)
                            }
                        }
                        .onDelete {
                            appData.articulos.remove(atOffsets: $0)
                        }
                    }
                }
            }
            .navigationTitle("Lista de \(appData.usuario.nombre)")
            .toolbar {
                Button {
                    mostrarPerfilUsuario = true
                } label: {
                    Image(systemName: "person.circle")
                }
            }
            .sheet(isPresented: $mostrarPerfilUsuario) {
                Text("Datos de usuario \(appData.usuario.nombre)")
            }
            // Task se ejecuta al cargar el Navigation View, antes de mostrar la vista
            .task {
                if appData.articulos.isEmpty {
                    await appData.cargarDatos()
                }
            }
        }
    }
}

struct FilaArticulo: View {
    @Binding var articulo: Articulo
    
    var body: some View {
        HStack {
            Image(systemName: articulo.completado ? "checkmark.square.fill" : "square")
                .foregroundStyle(articulo.completado ? .green : .gray)
                .onTapGesture {
                    articulo.completado.toggle()
                }
            
            Text(articulo.titulo)
                .strikethrough(articulo.completado)
                .foregroundStyle(articulo.completado ? .gray : .primary)
        }
    }
}

#Preview {
    VistaEjemploCompleto()
        .environment(AppData())
}
