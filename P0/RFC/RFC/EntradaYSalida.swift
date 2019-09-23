//
//  EntradaYSalida.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

class EntradaYSalida {
    func imprimeAConsola(_ message: String) {
        print(message)
    }
    func imprimeUso() {
        let ejecutable = (CommandLine.arguments[0] as NSString).lastPathComponent
        imprimeAConsola("Descripción:")
        imprimeAConsola("\t\(ejecutable) saluda al usuario preguntándole su nombre e imprimiendo la hora de saludo")
        imprimeAConsola("Opciones")
        imprimeAConsola("\t-h imprime esta ayuda")
    }
    
    func obtieneInput() -> String {
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
