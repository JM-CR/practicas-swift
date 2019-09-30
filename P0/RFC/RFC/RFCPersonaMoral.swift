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
    var tablaTres: Dictionary<String, Int>
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
        
        // Convertir números arábigos a letra
        for (index, elemento) in self.componentesDelNombre.enumerated() where Int(elemento) != nil {
            self.componentesDelNombre[index] = self.convierteNumeroALetras(numero: elemento, posicion: index + 1)
        }
        
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
     Convierte números arábigos en la razón social a letras fáciles de procesar.
     
     - Parameter numero: Número a convertir.
     - Parameter posicion: Posición dentro del arreglo componentesDelNombre.
     - Returns: Número en letras.
     */
    private mutating func convierteNumeroALetras(numero: String, posicion: Int) -> String {
        // Traducciones
//        let unidades: Dictionary<Int, String> = [0: "C", 1: "U", 2: "D", 3: "T", 4: "C", 5: "C", 6: "S", 7: "S", 8: "O", 9: "N"]
//        let decenas: Dictionary<Int, String> = [1: "D", 2: "V", 3: "T", 4: "C", 5: "C", 6: "S", 7: "S", 8: "O", 9: "N"]
//        let centenas: Dictionary<Int, String> = [1: "C", 2: "D", 3: "T", 4: "C", 5: "C", 6: "S", 7: "S", 8: "O", 9: "N"]
//        let millares: Dictionary<Int, String> = [1: "M", 2: "D", 3: "T", 4: "C", 5: "C", 6: "S", 7: "S", 8: "O", 9: "N"]
//
        // Verificar posición dentro de arreglo componentesDelNombre
//        var siglasDelNumero = ""
//        switch posicion {
//        case 1:
//            print("")
//        case 2:
//            print("")
//        case 3:
//            print("")
//        default:
//            siglasDelNumero = numero
//        }
        
        // Match contra diccionarios
        
        return numero
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
        
        // Verificar si hay al menos tres letras
        var tercerLetra: String
        if self.componentesDelNombre[1].count == 1 {
            tercerLetra = "X"
        } else {
            let index = self.componentesDelNombre[1].index(self.componentesDelNombre[1].startIndex, offsetBy: 1)
            tercerLetra = String(self.componentesDelNombre[1][index])
        }
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)"
    }
    
    /**
     Calcula las siglas del contribuyente cuando tiene una palabra.
     El formato es PPP.
     */
    private mutating func coincidenciaMasCorta() {
        let primerLetra = self.componentesDelNombre[0].first!
        
        // Verificar si hay al menos tres letras
        var segundaLetra: String
        var tercerLetra: String
        switch self.componentesDelNombre[0].count {
        case 1:
            segundaLetra = "X"
            tercerLetra = "X"
        case 2:
            let indexDos = self.componentesDelNombre[0].index(self.componentesDelNombre[0].startIndex, offsetBy: 1)
            segundaLetra = String(self.componentesDelNombre[0][indexDos])
            tercerLetra = "X"
        default:
            let indexDos = self.componentesDelNombre[0].index(self.componentesDelNombre[0].startIndex, offsetBy: 1)
            segundaLetra = String(self.componentesDelNombre[0][indexDos])
            
            let indexTres = self.componentesDelNombre[0].index(self.componentesDelNombre[0].startIndex, offsetBy: 2)
            tercerLetra = String(self.componentesDelNombre[0][indexTres])
        }
        
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
        
        self.limpiaNombreEmpresa()
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
     Elimina caracteres innecesarios antes y después del filtrado.
     */
    private mutating func limpiaNombreEmpresa() {
        // Remover basura
        self.nombre = self.nombre.replacingOccurrences(of: "�", with: "", options: .literal, range: nil)
        
        // Remover espacios
        self.nombre = self.nombre.trimmingCharacters(in: .whitespaces)
    }
}
