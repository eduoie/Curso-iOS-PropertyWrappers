//
//  App-con-Environment.swift
//  Curso-iOS-PropertyWrappers
//
//  Created by Equipo 2 on 2/2/26.
//

import SwiftUI

@Observable
class ThemeManager {
    var isDarkMode: Bool = false
    var accentColor: Color = .blue
}

//@main
struct App_con_Environment: App {
    // Aquí creamos la instancia
    @State private var theme = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            VistaHome()
                // inyectamos el objeto en el entorno (environment)
                .environment(theme)
        }
    }
}
