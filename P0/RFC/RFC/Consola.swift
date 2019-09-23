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
    func imprimeAConsola(_ mensaje: String) {
        print(mensaje)
    }
    
    func imprimeUso() {
        _ = (CommandLine.arguments[0] as NSString).lastPathComponent
        imprimeAConsola("Descripción")
        imprimeAConsola("\tCalcula el RFC de una persona física o moral.")
        imprimeAConsola("Opciones")
        imprimeAConsola("\t-h Imprime ayuda")
    }
    
    func entradaDeTeclado() -> String {
        let teclado = FileHandle.standardInput
        let datosTecleados = teclado.availableData
        let dataEnStr = String(data: datosTecleados, encoding: String.Encoding.utf8)!
        return dataEnStr.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    func run() {
        let (argc, argumentos) = (CommandLine.argc, CommandLine.arguments)
        print("Se recibieron los siguientes \(argc) argumentos: \(argumentos)")
    }
}
