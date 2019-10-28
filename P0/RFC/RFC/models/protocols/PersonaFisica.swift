//
//  PersonaFisica.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

protocol PersonaFisica: PersonaGeneral {
    var nombre: String { get set }
    var apellidoPaterno: String { get set }
    var apellidoMaterno: String { get set }
    var tablaCuatro: Dictionary<String, String> { get }
    var tablaSeis: Array<String> { get }
 
    mutating func creaSiglas()
    mutating func creaFechaContribuyente()
    mutating func filtraNombre()
}

extension PersonaFisica {
    /**
     Valida si la persona es menor de edad.
     
     - Returns: True si la persona tiene menos de 18 años.
     */
    func esMenorDeEdad() -> Bool {
        var esMenor = false
        let fechaActual = Date()
        
        // Calcular fecha mínima para ser legal
        var mayoriaDeEdad = DateComponents(calendar: .current)
        mayoriaDeEdad.setValue(-18, for: .year)
        mayoriaDeEdad.setValue(-6, for: .hour)
        let fechaMinima = Calendar.current.date(byAdding: mayoriaDeEdad, to: fechaActual)!
        let fechaDelUsuario = DateComponents(calendar: .current, timeZone: .current, year: Int(self.año), month: Int(self.mes), day: Int(self.dia))
        let fechaAComparar = Calendar.current.date(from: fechaDelUsuario)!
        
        // Ver si es menor de edad
        if fechaAComparar > fechaMinima {
            esMenor.toggle()
            print("\nNo puedes calcular el RFC para una persona menor de edad.")
            print("Introduce una fecha válida.")
        }
        
        return esMenor
    }
    
    /**
     Permite al usuario introducir su nombre y lo guarda en la propiedad nombre.
     
     - Returns: Regresa true si el nombre es válido.
     */
    mutating func introduceNombre() -> Bool {
        var nombreValido = false
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nIngresa el nombre: ")
            self.nombre = try validaPersona(texto: entradaDelUsuario, vacio: false)
            nombreValido.toggle()
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return nombreValido
    }
    
    /**
     Permite al usuario introducir su apellido paterno y lo guarda en la propiedad apellidoPaterno.
     
     - Returns: Regresa true si el apellido es válido.
     */
    mutating func introduceApellidoPaterno() -> Bool {
        var apellidoValido = false
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nIngresa el primer apellido: ")
            self.apellidoPaterno = try validaPersona(texto: entradaDelUsuario, vacio: false)
            apellidoValido.toggle()
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return apellidoValido
    }
    
    /**
     Permite al usuario introducir su apellido materno y lo guarda en la propiedad apellidoMaterno.
     
     - Returns: Regresa true si el apellido es válido.
     */
    mutating func introduceApellidoMaterno() -> Bool {
        var apellidoValido = false
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nIngresa el segundo apellido [Si no aplica dar Enter]: ")
            self.apellidoMaterno = try validaPersona(texto: entradaDelUsuario, vacio: true)
            apellidoValido.toggle()
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return apellidoValido
    }
    
    /**
     Valida los apellidos o nombres dados.
     
     - Parameter texto: Entrada de usuario.
     - Parameter vacio: Indica si el parámetro puede estar vacío.
     - Throws: InputError.InvalidCharacter
     - Returns: Texto validado.
     */
    private func validaPersona(texto: String?, vacio: Bool) throws -> String {
        if let valor = texto {
            if !vacio {
                guard valor != "" else {
                    throw InputError.InvalidCharacter(descripcion: "No puedes dejar el campo vacío.")
                }
            }
        } else {
            throw InputError.InvalidCharacter(descripcion: "Error desconocido, introdúcelo de nuevo.")
        }
        
        var buscaRegEx = texto!.range(of: #"\d"#, options: .regularExpression)
        guard buscaRegEx == nil else {
            throw InputError.InvalidCharacter(descripcion: "Texto inválido.")
        }
        
        let caracteresInvalidos = [
            "?", "_", "!", "'", "¿", "¡", "|", "@", "=", "(", ")", "-", "#", "·",
            "&", "/", "}", "{", "`", "+", "¨", "ª", "º", "Ç", ";", "ç", "´", "^",
            "[", "]", "\\", "*", ".", "¨", "ª", "º", "·", ":", "'"]
        for valor in caracteresInvalidos {
            guard !texto!.contains(valor) else {
                throw InputError.InvalidCharacter(descripcion: "Texto inválido.")
            }
        }
        
        buscaRegEx = texto!.range(of: #"[áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜâêîôûÂÊÎÔÛ]"#, options: .regularExpression)
        guard buscaRegEx == nil else {
            throw InputError.InvalidCharacter(descripcion: "No introduzcas acentos.")
        }
        
        return texto!
    }
}
