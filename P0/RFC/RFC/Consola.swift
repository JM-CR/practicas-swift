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
        
    }
    
    /**
     Imprime un mensaje para guiar al usuario y lee lo que introduce.
     
     - Parameter mensaje: Texto a imprimir.
     - Returns: Texto que introdujo el usuario.
     */
    func entradaDeTeclado(mensaje: String) -> String {
        print(mensaje)
        
        let teclado = FileHandle.standardInput
        let datosTecleados = teclado.availableData
        let dataEnStr = String(data: datosTecleados, encoding: String.Encoding.utf8)!
        return dataEnStr.trimmingCharacters(in: CharacterSet.newlines)
    }
}
