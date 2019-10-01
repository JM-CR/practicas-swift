//
//  Consola.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

protocol Consola {
    
}

extension Consola {
    /**
     Muestra el propósito del programa.
     */
    func imprimeUso() {
        let descripcion =
        """
        Calculadora de RFC
        Práctica 0 de aplicaciones móviles
        Desarrollado por: Josue Mosiah Contreras Rocha

        Para ver la descripción y uso ingresa algún argumento al ejecutar
            Ejemplo: ./RFC ayuda
        """
        print("\n\(descripcion)")
        print("\n-------------")
        menuDeAyuda()
    }
    
    /**
     Muestra la sección de ayuda para el usuario.
     */
    private func menuDeAyuda() {
        if CommandLine.argc > 1 {
            let ayuda =
            """
            DESCRIPCION Y USO

            Este programa te permite calcular el RFC para una persona moral o física

            El proceso que tienes que realizar es:
                1. Elegir el tipo de persona
                2. Introducir la fecha correspondiente
                3. Introducir el nombre en el formato solicitado

            El programa continuará ejecutándose hasta que eligas la opción salir
            """
            print("\n\(ayuda)")
            print("\n-------------")
        }
    }
    
    /**
     Imprime un mensaje para guiar al usuario y lee lo que introduce.
     
     - Parameter mensaje: Texto a imprimir.
     - Returns: Texto que introdujo el usuario.
     */
    func entradaDeTeclado(mensaje: String) -> String {
        print(mensaje)
        
        var dataEnStr = ""
        if let texto = readLine() {
            dataEnStr = texto
        }
        
        return dataEnStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
     - Throws: InputError.InvalidCharacter, InputError.InvalidNumberInRange
     - Returns: Opción escogida.
     */
    private func validaTipoRFC(opcion: String) throws -> Int {
        let buscaRegEx = opcion.range(of: #"^\d$"#, options: .regularExpression)
        guard buscaRegEx != nil else {
            throw InputError.InvalidCharacter(descripcion: "Solo debes introducir una opción del menú.")
        }
        
        let numero: Int = Int(opcion)!
        guard numero > 0 && numero < 3 else {
            throw InputError.InvalidNumberInRange(descripcion: "Opción inválida.")
        }
        
        return numero
    }
    
    /**
     Limpia la consola de texto
     */
    func limpiaConsola() {
        print("\u{001B}[2J")
    }
}
