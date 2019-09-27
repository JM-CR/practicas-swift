//
//  RFCPersonaFisica.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

struct RFCPersonaFisica: PersonaFisica {
    var nombre = ""
    var apellidoPaterno = ""
    var apellidoMaterno = ""
    
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
    var tablaCuatro: Dictionary<String, String>
    var tablaSeis: Array<String>
    
    init() {
        self.tablas = Tablas()
        self.tablaUno = tablas.tablaUno
        self.tablaDos = tablas.tablaDos
        self.tablaTres = tablas.tablaTres
        self.tablaCuatro = tablas.tablaCuatro
        self.tablaSeis = tablas.tablaSeis
    }
    
    /**
     Toma el dia, mes y año de nacimiento y genera la clave YYMMDD.
     */
    mutating func reglaDos() {
        let dia = self.dia < 9 ? "0\(self.dia)" : "\(self.dia)"
        let mes = self.mes < 9 ? "0\(self.mes)" : "\(self.mes)"
        let año = "\(self.año)".suffix(2)
        
        self.fecha = "\(año)\(mes)\(dia)"
    }
    
    /**
     Elimina artículos, preposiciones, conjunciones o contracciones en el nombre o apellido(s).
     Reemplaza las letras "Ch" -> "C" y "Ll" -> "L".
     */
    mutating func reglaTresYOcho() {
        let palabrasAFiltrar = [
            " Y ", " E ", " NI ", " O ", " DE ", " DEL ", " LOS ", " LA ", " LAS ",
            " U ", "SR. ", "SRA. ", "SR ", "SRA ", "A. ", "M. ", "A ", "M ",
        ]
        
        let porReemplazar = ["Á", "É", "Í", "Ó", "Ú", "CH", "LL"]
        let reemplazo = ["A", "E", "I", "O", "U", "C", "L"]
        
        // Pasar todo a mayúsculas
        self.nombre = self.nombre.uppercased()
        self.apellidoPaterno = self.apellidoPaterno.uppercased()
        self.apellidoMaterno = self.apellidoMaterno.uppercased()
        
        // Remover inconsistencias
        self.nombre = self.nombre.replacingOccurrences(of: "�", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: "�", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: "�", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        // Quitar acentos
        for i in 0..<5 {
            let porCambiar = porReemplazar[i]
            let cambio = reemplazo[i]
            
            self.nombre = self.nombre.replacingOccurrences(of: porCambiar, with: cambio)
            self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: porCambiar, with: cambio)
            self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: porCambiar, with: cambio)
        }
        
        // Filtrar palabras
        for palabra in palabrasAFiltrar {
            self.nombre = self.nombre.replacingOccurrences(of: palabra, with: " ")
            self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: palabra, with: " ")
            self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: palabra, with: " ")
        }
    }
}
