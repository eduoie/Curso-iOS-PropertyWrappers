//
//  VistaDashboard.swift
//  Curso-iOS-PropertyWrappers
//
//  Created by Equipo 2 on 4/2/26.
//

import SwiftUI

@Observable
class UserContext {
    var username: String = "Usuario iPhone"
    var esPremium: Bool = false
}

@Observable
class CardDesigner {
    var colorTarjeta: Color = .blue.opacity(0.2) {
        didSet {
            print("El color de tarjeta ha cambiado de \(oldValue) a \(colorTarjeta)")
        }
    }
    var mostrarBorde: Bool = true
}

struct VistaDashboard: View {
    
    @Environment(UserContext.self) private var user
    
    @State private var designer = CardDesigner()
    
    @State private var mostrarEditor = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                // Tarjeta
                VStack {
                    Image(systemName: user.esPremium ? "crown.fill" : "person.fill")
                        .font(.largeTitle)
                        .foregroundStyle(user.esPremium ? .yellow : .gray)
                    
                    Text(user.username)
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(designer.colorTarjeta)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: designer.mostrarBorde ? 2 : 0)
                )
                .padding()
                
                Spacer()
                
                Button("Editar tarjeta y usuario") {
                    mostrarEditor = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            .navigationTitle("Dashboard")
            .sheet(isPresented: $mostrarEditor) {
                VistaEditor(designer: designer)
            }
        }
    }
}

struct VistaEditor: View {
    @Bindable var designer: CardDesigner
    
    @Environment(UserContext.self) private var user
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        @Bindable var bindableUser = user
        
        NavigationStack {
            Form {
                Section("Diseño de tarjeta") {
                    ColorPicker("Color de fondo", selection: $designer.colorTarjeta)
                    Toggle("Mostrar borde", isOn: $designer.mostrarBorde)
                }
                
                Section("Datos de usuario") {
                    TextField("Nombre", text: $bindableUser.username)
                    Toggle("Usuario Premium", isOn: $bindableUser.esPremium)
                }
            }
            
            .navigationTitle("Configuración")
            .toolbar {
                Button("Hecho") { dismiss() }
            }
        }
    }
}

#Preview {
    VistaDashboard()
        .environment(UserContext())
}
