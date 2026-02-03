//
//  ContadorViewModel.swift
//  Curso-iOS-PropertyWrappers
//
//  Created by Equipo 2 on 2/2/26.
//

import Observation // usar este import cuando no importamos SwiftUI

@Observable
class ContadorViewModel {
    var count: Int = 0
    var name: String = "Contador App"
    
    func incrementar() {
        count += 1
    }
}
