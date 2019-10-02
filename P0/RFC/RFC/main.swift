//
//  main.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

var rfcPersonaFisica = RFCPersonaFisica()
var rfcPersonaMoral = RFCPersonaMoral()

// Descripción del programa
rfcPersonaFisica.limpiaConsola()
rfcPersonaFisica.imprimeUso()

while true {
    var opcionDelMenu: Int? = nil
    
    // Elegir tipo de persona
    while opcionDelMenu == nil {
        opcionDelMenu = rfcPersonaFisica.seleccionaTipoRFC()
    }

    // Introducir fecha
    print("\n-------------")
    if opcionDelMenu == 1 {
        print("\nIntroduce la fecha de nacimiento")
        repeat {
            while !rfcPersonaFisica.seleccionaAño() { }
            while !rfcPersonaFisica.seleccionaMes() { }
            while !rfcPersonaFisica.seleccionaDia() { }
        } while rfcPersonaFisica.esMenorDeEdad()
    } else {
        print("\nIntroduce la fecha de creación")
        while !rfcPersonaMoral.seleccionaAño() { }
        while !rfcPersonaMoral.seleccionaMes() { }
        while !rfcPersonaMoral.seleccionaDia() { }
    }

    // Introducir nombre
    print("\n-------------")
    if opcionDelMenu == 1 {
        print("\nIntroduce los siguientes datos personales")
        while !rfcPersonaFisica.introduceNombre() { }
        while !rfcPersonaFisica.introduceApellidoPaterno() { }
        while !rfcPersonaFisica.introduceApellidoMaterno() { }
    } else {
        print("\nIntroduce los siguientes datos de la empresa")
        while !rfcPersonaMoral.seleccionaTipoDeSociedad() { }
        while !rfcPersonaMoral.introduceNombre() { }
    }

    // Calcular RFC
    print("\n-------------")
    if opcionDelMenu == 1 {
        rfcPersonaFisica.filtraNombre()
        rfcPersonaFisica.creaFechaContribuyente()
        rfcPersonaFisica.creaSiglas()
        rfcPersonaFisica.generaHomoclave()
        rfcPersonaFisica.generaDigitoVerificador()
        rfcPersonaFisica.imprimeRFC()
    } else {
        rfcPersonaMoral.filtraNombre()
        rfcPersonaMoral.creaFechaContribuyente()
        rfcPersonaMoral.creaSiglas()
        rfcPersonaMoral.generaHomoclave()
        rfcPersonaMoral.generaDigitoVerificador()
        rfcPersonaMoral.imprimeRFC()
    }
    
    rfcPersonaFisica.esperaParaContinuar()
    rfcPersonaFisica.limpiaConsola()
}
