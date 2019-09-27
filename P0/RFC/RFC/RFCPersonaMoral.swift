//
//  RFCPersonaMoral.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/27/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

struct RFCPersonaMoral: PersonaMoral {
    var nombre = ""
    
    var digito = ""
    var homoclave = ""
    
    var fecha = ""
    var dia = 1
    var mes = 1
    var año = 1900
    
    var tablas: Tablas
    var tablaUno: Dictionary<String, String>
    var tablaDos: Dictionary<Int, String>
    var tablaTres: Dictionary<String, String>
    var tablaCinco: Array<String>
    
    init() {
        self.tablas = Tablas()
        self.tablaUno = tablas.tablaUno
        self.tablaDos = tablas.tablaDos
        self.tablaTres = tablas.tablaTres
        self.tablaCinco = tablas.tablaCinco
    }
}
