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
    
    private var componentesDelNombre: [String] = []
    private var componentesDelPaterno: [String] = []
    private var componentesDelMaterno: [String] = []
    
    init() {
        self.tablas = Tablas()
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
        self.separaNombreYApellidos()
        
        // Match con reglas
        if self.componentesDelPaterno.count > 1 || self.componentesDelMaterno.count > 1 {
            self.reglaCinco()
        } else if self.componentesDelNombre.count > 1 {
            self.reglaSeis()
        } else if self.componentesDelPaterno[0].count > 2 && self.componentesDelMaterno[0] != "" {
            self.reglaUno()
        } else if self.componentesDelPaterno[0].count <= 2 && self.componentesDelMaterno[0] != "" {
            self.reglaCuatro()
        } else {
            self.reglaSiete()
        }
    }
    
    /**
     Separa componentes del nombre y apellido por espacios.
     */
    private mutating func separaNombreYApellidos() {
        // Split
        self.componentesDelNombre = self.nombre.contains(" ") ?
            self.nombre.components(separatedBy: " ") : [self.nombre]
        
        self.componentesDelPaterno = self.apellidoPaterno.contains(" ") ?
            self.apellidoPaterno.components(separatedBy: " ") : [self.apellidoPaterno]
            
        self.componentesDelMaterno = self.apellidoMaterno.contains(" ") ?
            self.apellidoMaterno.components(separatedBy: " ") : [self.apellidoMaterno]
        
        // Eliminar elementos vacíos
        self.componentesDelNombre = self.componentesDelNombre.filter { (elemento) -> Bool in
            elemento != ""
        }
        self.componentesDelPaterno = self.componentesDelPaterno.filter { (elemento) -> Bool in
            elemento != ""
        }
        self.componentesDelMaterno = self.componentesDelMaterno.filter { (elemento) -> Bool in
            elemento != ""
        }
    }
    
    /**
     Calcula las siglas del contribuyente cuando no hay nombre ni apellidos compuestos
     y si el paterno tiene más de dos letras. El formato es PPMN.
     */
    private mutating func reglaUno() {
        let vocalPaterno = self.primerVocal(palabra: self.apellidoPaterno)
        let letraPaterno = self.apellidoPaterno.first!
        let letraMaterno = self.apellidoMaterno.first!
        let letraNombre = self.nombre.first!
        
        self.siglas = "\(letraPaterno)\(vocalPaterno)\(letraMaterno)\(letraNombre)"
    }
    
    /**
     Calcula las siglas del contribuyente cuando no hay nombre ni apellidos compuestos
     y si el paterno tiene menos de tres letras. El formato es PMNN.
     */
    private mutating func reglaCuatro() {
        let letraPaterno = self.apellidoPaterno.first!
        let letraMaterno = self.apellidoMaterno.first!
        let primerLetraNombre = self.nombre.first!
        
        let index = self.nombre.index(self.nombre.startIndex, offsetBy: 1)
        let segundaLetraNombre = self.nombre[index]
        
        self.siglas = "\(letraPaterno)\(letraMaterno)\(primerLetraNombre)\(segundaLetraNombre)"
    }
    
    /**
     Calcula las siglas del contribuyente cuando algún apellido es compuesto.
     El formato es PPMN.
     */
    private mutating func reglaCinco() {
        if self.componentesDelPaterno[0].count > 2 && self.componentesDelMaterno[0] != "" {
            self.reglaUno()
        } else if self.componentesDelPaterno[0].count < 3 && self.componentesDelMaterno[0] != "" {
            self.reglaCuatro()
        }
    }
    
    /**
     
     */
    private mutating func reglaSeis() {
        
    }
    
    /**
     
     */
    private mutating func reglaSiete() {
        
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
     Toma el dia, mes y año de nacimiento y genera la clave YYMMDD.
     */
    mutating func creaFechaContribuyente() {
        let dia = self.dia < 9 ? "0\(self.dia)" : "\(self.dia)"
        let mes = self.mes < 9 ? "0\(self.mes)" : "\(self.mes)"
        let año = "\(self.año)".suffix(2)
        
        self.fecha = "\(año)\(mes)\(dia)"
    }
    
    /**
     Elimina artículos, preposiciones, conjunciones, contracciones y palabras
     innecesarias del nombre(s) o apellido(s).
     */
    mutating func filtraNombre() {
        let palabrasAFiltrar = [
            #"\bY\b"#, #"\bE\b"#, #"\bDE\b"#, #"\bLA\b"#, #"\bLAS\b"#, #"\bLOS\b"#,
            #"\bU\b"#, #"\bSR\b"#, #"\bSRA\b"#, #"\bA\b"#, #"\bM\b"#, #"\bDEL\b"#
        ]
        
        // Pasar todo a mayúsculas
        self.nombre = self.nombre.uppercased()
        self.apellidoPaterno = self.apellidoPaterno.uppercased()
        self.apellidoMaterno = self.apellidoMaterno.uppercased()
        
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
        for i in 0..<2 {
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
