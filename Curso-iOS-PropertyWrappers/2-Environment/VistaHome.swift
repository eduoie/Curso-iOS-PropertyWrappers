//
//  VistaHome.swift
//  Curso-iOS-PropertyWrappers
//
//  Created by Equipo 2 on 2/2/26.
//

import SwiftUI

struct VistaHome: View {
    
    @Environment(ThemeManager.self) var theme
    
    var body: some View {
        ZStack {
            (theme.isDarkMode ? Color.black : .white)
                .ignoresSafeArea()
            
            VStack {
                Text("Pantalla principal (Home)")
                    .foregroundStyle(theme.accentColor)
                
                Divider()
                
                VistaEditarTheme()
            }
        }
    }
}

struct VistaEditarTheme: View {
    @Environment(ThemeManager.self) var theme
    
    var body: some View {
        // Dentro, y solo dentro, del body, definimos:
        @Bindable var themeBindable = theme
        // Para poder acceder a los bindings de una variable obtenida de @Environment
        
        Text("Modo oscuro está a: \(String(theme.isDarkMode))")
        
        Toggle("Modo oscuro", isOn: $themeBindable.isDarkMode)
        
        ColorPicker("Color de Acento", selection: $themeBindable.accentColor)
    }
}

#Preview {
    @Previewable @State var theme = ThemeManager()
    
    VistaHome()
        .environment(theme)
}
