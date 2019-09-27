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
 
    mutating func reglaTresYOcho()
}

extension PersonaFisica {
    func esMenorDeEdad() -> Bool {
        return false
    }
    
    /**
     Permite al usuario introducir su nombre y lo guarda en la propiedad nombre.
     
     - Returns: Regresa true si el nombre es válido.
     */
    mutating func introduceNombre() -> Bool {
        var nombreValido = false
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nIngresa el nombre: ")
            self.nombre = try validaPersona(texto: entradaDelUsuario)
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
            self.apellidoPaterno = try validaPersona(texto: entradaDelUsuario)
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
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nIngresa el segundo apellido: ")
            self.apellidoMaterno = try validaPersona(texto: entradaDelUsuario)
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
     - Throws: InputError.InvalidCharacter
     - Returns: Texto validado.
     */
    private func validaPersona(texto: String) throws -> String {
        var buscaRegEx = texto.range(of: #"[\d?_!'¿¡|@,=()-:.#·&/*}{^`+¨]"#, options: .regularExpression)
        guard buscaRegEx == nil else {
            throw InputError.InvalidCharacter(descripcion: "Texto inválido.")
        }
        
        buscaRegEx = texto.range(of: #"[áéíóúÁÉÍÓÚ]"#, options: .regularExpression)
        guard buscaRegEx == nil else {
            throw InputError.InvalidCharacter(descripcion: "No introduzcas acentos.")
        }
        
        // TODO: Ver casos para entrada vacía.
        
        return texto
    }
}
