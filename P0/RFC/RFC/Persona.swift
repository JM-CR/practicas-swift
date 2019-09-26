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
     Muestra un menú que permite elegir entre persona física y moral.
     
     - Returns: Opción elegida; 1 = Física | 2 = Moral.
     */
    func seleccionaTipoRFC() -> Int? {
        var opcion: Int? = nil
        let texto =
        """
        Selecciona el tipo de RFC a calcular
            1. Persona física
            2. Persona moral
        """
        print("\n\(texto)")
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nOpción: ")
            opcion = try validaTipoRFC(opcion: entradaDelUsuario)
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch InputError.InvalidNumberInRange(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return opcion
    }
    
    /**
     Valida si la opción del menú seleccionaTipoRFC() es válida.
     
     - Parameter opcion: Entrada de usuario.
     - Throws: InputError.InvalidCharacter, InputError.NumberTooHigh, InputError.NumberTooLow
     - Returns: Opción escogida.
     */
    private func validaTipoRFC(opcion: String) throws -> Int {
        let buscaRegEx = opcion.range(of: #"^\d$"#, options: .regularExpression)
        guard buscaRegEx != nil else {
            throw InputError.InvalidCharacter(descripcion: "Solo debes introducir un número.")
        }
        
        let numero: Int = Int(opcion)!
        guard numero > 0 && numero < 3 else {
            throw InputError.InvalidNumberInRange(descripcion: "Opción inválida.")
        }
        
        return numero
    }
    
    mutating func seleccionaDia() {
        
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
        print("\n\(texto)")
        self.mes = self.entradaDeTeclado(mensaje: "\nOpción: ")
    }
    
    mutating func seleccionaAño() {
        
    }
    
    func formatoFecha() {
        
    }
}
