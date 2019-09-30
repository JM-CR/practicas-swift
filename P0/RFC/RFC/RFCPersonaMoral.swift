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
    
    private var componentesDelNombre: [String] = []
    
    init() {
        let tablas = Tablas()
        self.tablaUno = tablas.tablaUno
        self.tablaDos = tablas.tablaDos
        self.tablaTres = tablas.tablaTres
        self.tablaCinco = tablas.tablaCinco
    }
    
    /**
     Crea las siglas del contribuyente.
     */
    mutating func creaSiglas() {
        // Separa componentes de la razon socuial por espacios.
        self.componentesDelNombre = self.nombre.contains(" ") ?
            self.nombre.components(separatedBy: " ") : [self.nombre]
        
        self.componentesDelNombre = self.componentesDelNombre.filter({ (elemento) -> Bool in
            elemento != ""
        })
        
        // Match con reglas
        if self.componentesDelNombre.count >= 3 {
            self.coincidenciaMasLarga()
        } else if self.componentesDelNombre.count == 2 {
            self.coincidenciaIntermedia()
        } else {
            self.coincidenciaMasCorta()
        }
    }
    
    /**
     Calcula las siglas del contribuyente cuando tiene tres o más palabras.
     El formato es PST.
     */
    private mutating func coincidenciaMasLarga() {
        let primerLetra = self.componentesDelNombre[0].first!
        let segundaLetra = self.componentesDelNombre[1].first!
        let tercerLetra = self.componentesDelNombre[2].first!
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)"
    }
    
    /**
     Calcula las siglas del contribuyente cuando tiene dos palabras.
     El formato es PSS.
     */
    private mutating func coincidenciaIntermedia() {
        let primerLetra = self.componentesDelNombre[0].first!
        let segundaLetra = self.componentesDelNombre[1].first!
        
        let index = self.componentesDelNombre[1].index(self.componentesDelNombre[1].startIndex, offsetBy: 1)
        let tercerLetra = self.componentesDelNombre[1][index]
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)"
    }
    
    /**
     Calcula las siglas del contribuyente cuando tiene una palabra.
     El formato es PPP.
     */
    private mutating func coincidenciaMasCorta() {
        let primerLetra = self.componentesDelNombre[0].first!
        
        let indexDos = self.componentesDelNombre[0].index(self.componentesDelNombre[0].startIndex, offsetBy: 1)
        let segundaLetra = self.componentesDelNombre[0][indexDos]
        
        let indexTres = self.componentesDelNombre[0].index(self.componentesDelNombre[0].startIndex, offsetBy: 2)
        let tercerLetra = self.componentesDelNombre[0][indexTres]
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)"
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
        let reemplazo = ["C", "L", "", " "]
        
        // Find & Replace
        for i in 0..<porReemplazar.count {
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
