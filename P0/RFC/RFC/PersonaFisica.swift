//
//  PersonaFisica.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

protocol PersonaFisica: Persona {
    var nombre: String { get set }
    var apellidoPaterno: String { get set }
    var apellidoMaterno: String { get set }
    var tablaCuatro: Dictionary<String, String> { get }
    var tablaSeis: Array<String> { get }
}

extension PersonaFisica {
    func validaNombreCompleto() -> Bool {
        return true
    }
}
