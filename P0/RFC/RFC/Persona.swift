//
//  Persona.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

protocol Persona {
    var fecha: Date { get set }
    var digito: String { get set }
    var homoclave: String { get set }
    var dia: String { get set }
    var mes: String { get set }
    var año: String { get set }
    var tablaUno: Dictionary<String, String> { get }
    var tablaDos: Dictionary<String, String> { get }
    var tablaTres: Dictionary<Int, String> { get }
    
    func validaFecha() -> Bool
    func formatoFecha()
}

extension Persona {
    mutating func generaHomoclave() {
        
    }
    
    mutating func generaDigito() {
        
    }
    
    func seleccionaMes() -> String {
        return ""
    }
}
