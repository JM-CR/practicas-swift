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

// Menú inicial
while (!rfcPersonaFisica.seleccionaAño()) { }

// Calcular RFC
