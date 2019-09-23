//
//  Saludos.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

class Saludos {
    let entradaYSalida = EntradaYSalida()
    var formatoFecha: DateFormatter = {
        let formato = DateFormatter()
        formato.dateStyle = .long
        return formato
    }()
    func saluda() {
        if CommandLine.argc > 1 {
            entradaYSalida.imprimeUso()
        } else {
            entradaYSalida.imprimeAConsola("Este programa te preguntará tu nombre y apellido dándote la fecha.")
            entradaYSalida.imprimeAConsola("¿Cuál es tu nombre?")
            let nombre = entradaYSalida.obtieneInput()
            entradaYSalida.imprimeAConsola("¿Cuá es tu apellido?")
            let apellido = entradaYSalida.obtieneInput()
            let fecha = Date()
            entradaYSalida.imprimeAConsola("Hola \(nombre) \(apellido), hoy es \(formatoFecha.string(from: fecha))")
        }
    }
}
