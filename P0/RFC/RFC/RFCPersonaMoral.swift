//
//  RFCPersonaMoral.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/27/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

struct RFCPersonaMoral: PersonaMoral {
    var siglas = ""
    var nombre = ""
    var tipoDeSociedad = ""
    var nombreCompleto = ""
    
    var digito = ""
    var homoclave = ""
    
    var fecha = ""
    var dia = 1
    var mes = 1
    var año = 1900
    
    var tablaUno: Dictionary<String, String>
    var tablaDos: Dictionary<Int, String>
    var tablaTres: Dictionary<String, String>
    var tablaCinco: Array<String>
    
    init() {
        let tablas = Tablas()
        self.tablaUno = tablas.tablaUno
        self.tablaDos = tablas.tablaDos
        self.tablaTres = tablas.tablaTres
        self.tablaCinco = tablas.tablaCinco
    }
    
    /**
     Elimina artículos, preposiciones, conjunciones, contracciones y palabras
     innecesarias de la razón social.
     */
    mutating func filtraNombre() {
        // Pasar todo a mayúsculas
        self.nombre = self.nombre.uppercased()
        self.tipoDeSociedad = self.tipoDeSociedad.uppercased()
        self.nombreCompleto = "\(self.nombre), \(self.tipoDeSociedad)"
        
        // Filtrar palabras
        let palabrasAFiltrar = self.tablaCinco
        for palabra in palabrasAFiltrar {
            self.nombre = self.nombre.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
        }
        
        self.limpiaNombreEmpresa()
        self.buscaYReemplaza()
    }
    
    /**
     Reemplaza las letras "Ch" por "C" y "Ll" por "L".
     */
    private mutating func buscaYReemplaza() {
        let porReemplazar = ["CH", "LL", ",", "."]
        let reemplazo = ["C", "L", "", ""]
        
        // Find & Replace
        for i in 0..<2 {
            let porCambiar = porReemplazar[i]
            let cambio = reemplazo[i]
            
            self.nombre = self.nombre.replacingOccurrences(of: porCambiar, with: cambio)
        }
    }
    
    /**
     Elimina caracteres innecesarios después del filtrado.
     */
    private mutating func limpiaNombreEmpresa() {
        // Remover basura
        self.nombre = self.nombre.replacingOccurrences(of: "�", with: "", options: .literal, range: nil)
        
        // Remover espacios
        self.nombre = self.nombre.trimmingCharacters(in: .whitespaces)
    }
}
