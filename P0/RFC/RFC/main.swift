//
//  main.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

var opcionDelMenu: Int? = nil
var rfcPersonaFisica = RFCPersonaFisica()
var rfcPersonaMoral = RFCPersonaMoral()

// Menú inicial
while opcionDelMenu == nil {
    opcionDelMenu = rfcPersonaFisica.seleccionaTipoRFC()
}

// Introducir fecha
print("\n-------------")
if opcionDelMenu == 1 {
    print("\nIntroduce la fecha de nacimiento")
    while !rfcPersonaFisica.seleccionaAño() { }
    while !rfcPersonaFisica.seleccionaMes() { }
    while !rfcPersonaFisica.seleccionaDia() { }
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

// CalcularRFC
print("\n-------------")
if opcionDelMenu == 1 {
    rfcPersonaFisica.filtraNombre()
    rfcPersonaFisica.creaFechaContribuyente()
    rfcPersonaFisica.creaSiglas()
    print(rfcPersonaFisica.siglas)
    rfcPersonaFisica.generaHomoclave()
} else {
    rfcPersonaMoral.filtraNombre()
    rfcPersonaMoral.creaFechaContribuyente()
    rfcPersonaMoral.creaSiglas()
    print(rfcPersonaMoral.siglas)
    rfcPersonaMoral.generaHomoclave()
}
