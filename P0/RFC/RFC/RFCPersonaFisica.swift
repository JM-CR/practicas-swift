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
    var tablaTres: Dictionary<String, Int>
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
        
        // Validar caso con paterno de un solo caracter
        var segundaLetra: String
        if self.apellidoPaterno.count == 1 {
            segundaLetra = "X"
        } else {
            segundaLetra = self.primerVocal(palabra: self.apellidoPaterno)
        }
        
        let tercerLetra = self.apellidoMaterno.first!
        let cuartaLetra = self.nombre.first!
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)\(cuartaLetra)"
    }
    
    /**
     Obtiene la primer vocal de una palabra, omitiendo el primer caracter.
     
     - Parameter palabra: Texto en el que se desea buscar.
     - Returns: Vocal encontrada.
     */
    private mutating func primerVocal(palabra: String) -> String {
        let vocales = ["A", "E", "I", "O", "U"]
        var primerVocal = ""
        for (index, letra) in palabra.enumerated() where vocales.contains(String(letra)) {
            guard index != 0 else {
                continue
            }
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
        
        // Caso con nombre de un caracter
        var cuartaLetra: String
        if self.nombre.count == 1 {
            cuartaLetra = "X"
        } else {
            let index = self.nombre.index(self.nombre.startIndex, offsetBy: 1)
            cuartaLetra = String(self.nombre[index])
        }
        
        self.siglas = "\(primerLetra)\(segundaLetra)\(tercerLetra)\(cuartaLetra)"
    }
    
    /**
     Calcula las siglas del contribuyente cuando el apellido es único.
     El formato es PPNN.
     */
    private mutating func apellidoUnico() {
        let primerLetra = self.apellidoPaterno.first!
        
        // Validar caso con paterno de un solo caracter
        var segundaLetra: String
        if self.apellidoPaterno.count == 1 && self.apellidoMaterno == "" {
            segundaLetra = "X"
        } else {
            let indexPaterno = self.apellidoPaterno.index(self.apellidoPaterno.startIndex, offsetBy: 1)
            segundaLetra = String(self.apellidoPaterno[indexPaterno])
        }
        
        let tercerLetra = self.nombre.first!
        
        // Validar caso con nombre de un solo caracter
        var cuartaLetra: String
        if self.nombre.count == 1 {
            cuartaLetra = "X"
        } else {
            let indexNombre = self.nombre.index(self.nombre.startIndex, offsetBy: 1)
            cuartaLetra = String(self.nombre[indexNombre])
        }
        
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
        // Pasar todo a mayúsculas
        self.nombre = self.nombre.uppercased()
        self.apellidoPaterno = self.apellidoPaterno.uppercased()
        self.apellidoMaterno = self.apellidoMaterno.uppercased()
        
        self.limpiaNombrePersona()
        if self.apellidoMaterno != "" {
            self.nombreCompleto = "\(self.apellidoPaterno) \(self.apellidoMaterno) \(self.nombre)"
        } else {
            self.nombreCompleto = "\(self.apellidoPaterno) \(self.nombre)"
        }
        
        // Filtrar palabras
        let palabrasAFiltrar = self.tablaSeis
        for palabra in palabrasAFiltrar {
            self.nombre = self.nombre.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
            self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
            self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
        }
        
        // Verificar caso del nombre Jose Maria
        self.verificaJoseMaria()
        
        self.limpiaNombrePersona()
        self.buscaYReemplaza()
    }
    
    /**
     Valida el caso cuando el nombre empieza con Jose Maria o Maria Jose.
     */
    private mutating func verificaJoseMaria() {
        let regExArray: Array<String> = [#"\bJOSE\b"#, #"\bMARIA\b"#]
        
        if self.nombre.contains("JOSE") && self.nombre.contains("MARIA") {
            if self.nombre.starts(with: "JOSE") {
                self.nombre = self.nombre.replacingOccurrences(of: regExArray[0], with: "", options: .regularExpression, range: nil)
            } else {
                self.nombre = self.nombre.replacingOccurrences(of: regExArray[1], with: "", options: .regularExpression, range: nil)
            }
        }
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
     Elimina caracteres innecesarios antes y después del filtrado.
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
