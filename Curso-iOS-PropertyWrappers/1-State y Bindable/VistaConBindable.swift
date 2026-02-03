//
//  VistaConBindable.swift
//  Curso-iOS-PropertyWrappers
//
//  Created by Equipo 2 on 2/2/26.
//

import SwiftUI

struct VistaConBindable: View {
    @State private var viewModel = ContadorViewModel()
    
    var body: some View {
        VStack {
            Text("VistaConBindable (la vista Padre)")
                .font(.title2)
            Text("Nombre del contador: \(viewModel.name)")
            Text("Conteo: \(viewModel.count)")
                .font(.largeTitle)
            
            Divider()
            
            // pasamos el viewModel por referencia, no por valor
            VistaEdicion(viewModel: viewModel)
            
            VistaLectura(viewModel: viewModel)
        }
    }
}

struct VistaEdicion: View {
    // Aquí usamos @Bindable, NO @Binding
    // Porque ContadorViewModel es una class
    @Bindable var viewModel: ContadorViewModel
    
    var body: some View {
        Form {
            Section("Configuración") {
                // Gracias a @Bindable generamos el Binding<String>
                TextField("Nombre del contador", text: $viewModel.name)
                
                Stepper("Contador: \(viewModel.count)") {
                    viewModel.incrementar()
                } onDecrement: { }
            }
        }
    }
}

struct VistaLectura: View {
    // No necesitamos Bindable SI solo vamos a LEER los datos.
    let viewModel: ContadorViewModel
    
    var body: some View {
        VStack {
            Text("Vista lectura")
                .font(.title2)
            Text("Nombre: \(viewModel.name)")
            Text("Conteo: \(viewModel.count)")
                .font(.largeTitle)
        }.background(.yellow.opacity(0.2))
    }
}

#Preview {
    VistaConBindable()
}
