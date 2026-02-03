//
//  VistaEjemploCompleto.swift
//  Curso-iOS-PropertyWrappers
//
//  Created by Equipo 2 on 2/2/26.
//

import SwiftUI

struct VistaEjemploCompleto: View {
    
    @Environment(AppData.self) var appData;
    
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
                
                HStack {
                    TextField("Nuevo deseo...", text: $nuevoArticulo)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Añadir") {
                        guard !nuevoArticulo.isEmpty else { return }
                        appData.anadirArticulo(titulo: nuevoArticulo)
                        nuevoArticulo = ""
                    }
                }
                .padding()
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
                VistaEditarPerfil(perfil: appData.usuario)
            }
            // Task se ejecuta al cargar el Navigation, antes de mostrar la vista
            .task {
                if appData.articulos.isEmpty {
                    await appData.cargarDatos()
                }
            }
        }
        .onAppear {
            print("Entrando en onAppear")
            print(appData.instanceId)
        }
    }
}

struct VistaEditarPerfil: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var perfil: PerfilUsuario
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Editar perfil") {
                    TextField("Nombre", text: $perfil.nombre)
                    Stepper("Edad: \(perfil.edad)", value: $perfil.edad)
                }
                
                VistaEstadisticas()
            }
            
            .navigationTitle("Perfil")
            .toolbar {
                Button("Hecho") {
                    dismiss()
                }
            }
        }
    }
}

struct VistaEstadisticas: View {
    
    @Environment(AppData.self) var appData
    
    var body: some View {
        HStack {
            Text("Total: \(appData.articulos.count) deseos")
            Spacer()
            Text("Completados: \(appData.articulos.filter(\.completado).count)")
        }
        .font(.footnote)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(Capsule())
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
