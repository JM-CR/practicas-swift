//
//  RFCPersonaFisica.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

struct RFCPersonaFisica: PersonaFisica {
    var siglas = ""
    var nombre = ""
    var apellidoPaterno = ""
    var apellidoMaterno = ""
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
    var tablaCuatro: Dictionary<String, String>
    var tablaSeis: Array<String>
    
    init() {
        let tablas = Tablas()
        self.tablaUno = tablas.tablaUno
        self.tablaDos = tablas.tablaDos
        self.tablaTres = tablas.tablaTres
        self.tablaCuatro = tablas.tablaCuatro
        self.tablaSeis = tablas.tablaSeis
    }
    
    /**
     Crea las siglas del contribuyente.
     */
    mutating func creaSiglas() {
        //Separa componentes de los apellidos por espacios.
        let componentesDelPaterno = self.apellidoPaterno.contains(" ") ?
            self.apellidoPaterno.components(separatedBy: " ") : [self.apellidoPaterno]
        
        let componentesDelMaterno = self.apellidoMaterno.contains(" ") ?
            self.apellidoMaterno.components(separatedBy: " ") : [self.apellidoMaterno]
        
        // Match con reglas
        if componentesDelPaterno[0].count > 2 && componentesDelMaterno[0] != "" {
            self.paternoMayor()
        } else if componentesDelPaterno[0].count <= 2 && componentesDelMaterno[0] != "" {
            self.paternoMenor()
        } else {
            self.apellidoUnico()
        }
        
        // Comparar sigla contra palabras inconvenientes
        self.verificaSigla()
    }
    
    /**
     Calcula las siglas del contribuyente cuando el apellido paterno tiene más de dos letras.
     El formato es PPMN.
     */
    private mutating func paternoMayor() {
        let primerLetra = self.apellidoPaterno.first!
        let segundaLetra = self.primerVocal(palabra: self.apellidoPaterno)
        let tercerLetra = self.apellidoMaterno.first!
        let cuartaLetra = self.nombre.first!
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)\(cuartaLetra)"
    }
    
    /**
     Obtiene la primer vocal de una palabra.
     
     - Parameter palabra: Texto en el que se desea buscar.
     - Returns: Vocal encontrada.
     */
    private mutating func primerVocal(palabra: String) -> String {
        let vocales = ["A", "E", "I", "O", "U"]
        var primerVocal = ""
        for letra in palabra where vocales.contains(String(letra)) {
            primerVocal = String(letra)
            break
        }
        
        return primerVocal
    }
    
    /**
     Calcula las siglas del contribuyente cuando el apellido paterno tiene menos de tres letras.
     El formato es PMNN.
     */
    private mutating func paternoMenor() {
        let primerLetra = self.apellidoPaterno.first!
        let segundaLetra = self.apellidoMaterno.first!
        let tercerLetra = self.nombre.first!
        
        let index = self.nombre.index(self.nombre.startIndex, offsetBy: 1)
        let cuartaLetra = self.nombre[index]
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)\(cuartaLetra)"
    }
    
    /**
     Calcula las siglas del contribuyente cuando el apellido es único.
     El formato es PPNN.
     */
    private mutating func apellidoUnico() {
        let primerLetra = self.apellidoPaterno.first!
        let indexPaterno = self.apellidoPaterno.index(self.apellidoPaterno.startIndex, offsetBy: 1)
        let segundaLetra = self.apellidoPaterno[indexPaterno]
        let tercerLetra = self.nombre.first!
        let indexNombre = self.nombre.index(self.nombre.startIndex, offsetBy: 1)
        let cuartaLetra = self.nombre[indexNombre]
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)\(cuartaLetra)"
    }
    
    /**
     Compara la sigla contra la tabla 4 en busca de palabras inconvenientes.
     */
    private mutating func verificaSigla() {
        let necesitaCambio = self.tablaCuatro.keys.contains(self.siglas)
        if necesitaCambio {
            self.siglas = self.tablaCuatro[self.siglas]!
        }
    }
    
    /**
     Elimina artículos, preposiciones, conjunciones, contracciones y palabras
     innecesarias del nombre(s) o apellido(s).
     */
    mutating func filtraNombre() {
        let palabrasAFiltrar = [
            #"\bY\b"#, #"\bE\b"#, #"\bDE\b"#, #"\bLA\b"#, #"\bLAS\b"#, #"\bLOS\b"#,
            #"\bU\b"#, #"\bSR\b"#, #"\bSRA\b"#, #"\bA\b"#, #"\bM\b"#, #"\bDEL\b"#,
            #"\bJOSE\b"#, #"\bMARIA\b"#
        ]
        
        // Pasar todo a mayúsculas
        self.nombre = self.nombre.uppercased()
        self.apellidoPaterno = self.apellidoPaterno.uppercased()
        self.apellidoMaterno = self.apellidoMaterno.uppercased()
        
        self.nombreCompleto = "\(self.nombre) \(self.apellidoPaterno) \(self.apellidoMaterno)"
        
        // Filtrar palabras
        for palabra in palabrasAFiltrar {
            self.nombre = self.nombre.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
            self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
            self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
        }
        
        self.limpiaNombrePersona()
        self.buscaYReemplaza()
    }
    
    /**
     Reemplaza las letras "Ch" por "C" y "Ll" por "L".
     */
    private mutating func buscaYReemplaza() {
        let porReemplazar = ["CH", "LL"]
        let reemplazo = ["C", "L"]
        
        // Find & Replace
        for i in 0..<porReemplazar.count {
            let porCambiar = porReemplazar[i]
            let cambio = reemplazo[i]
            
            self.nombre = self.nombre.replacingOccurrences(of: porCambiar, with: cambio)
            self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: porCambiar, with: cambio)
            self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: porCambiar, with: cambio)
        }
    }
    
    /**
     Elimina caracteres innecesarios después del filtrado.
     */
    private mutating func limpiaNombrePersona() {
        // Remover basura
        self.nombre = self.nombre.replacingOccurrences(of: "�", with: "", options: .literal, range: nil)
        self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: "�", with: "", options: .literal, range: nil)
        self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: "�", with: "", options: .literal, range: nil)
        
        // Remover espacios
        self.nombre = self.nombre.trimmingCharacters(in: .whitespaces)
        self.apellidoPaterno = self.apellidoPaterno.trimmingCharacters(in: .whitespaces)
        self.apellidoMaterno = self.apellidoMaterno.trimmingCharacters(in: .whitespaces)
    }
}
