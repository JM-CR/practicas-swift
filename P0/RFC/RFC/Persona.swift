//
//  Persona.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

protocol Persona: Consola {
    var fecha: Date? { get set }
    var digito: String { get set }
    var homoclave: String { get set }
    var dia: String { get set }
    var mes: String { get set }
    var año: String { get set }
    var tablas: Tablas { get set }
    var tablaUno: Dictionary<String, String> { get }
    var tablaDos: Dictionary<Int, String> { get }
    var tablaTres: Dictionary<String, String> { get }
}

extension Persona {
    mutating func generaHomoclave() {
        
    }
    
    mutating func generaDigito() {
        
    }
    
    /**
     Muestra un menú al usuario para seleccionar el mes y guarda su opción.
    */
    mutating func seleccionaMes() {
        let texto =
        """
        Selecciona el mes correspondiente:
            1. Enero
            2. Febrero
            3. Marzo
            4. Abril
            5. Mayo
            6. Junio
            7. Julio
            8. Agosto
            9. Septiembre
            10. Octubre
            11. Noviembre
            12. Diciembre
        """
        print(texto)
        self.mes = self.entradaDeTeclado(mensaje: "Opción: ")
    }
    
    func validaFecha() -> Bool {
        return true
    }
    
    func formatoFecha() {
        
    }
}
