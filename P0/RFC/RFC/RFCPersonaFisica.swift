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
        let casoNombre = self.nombre.contains(" ") ? self.nombre.components(separatedBy: " ") : [self.nombre]
        let casoPaterno = self.apellidoPaterno.contains(" ") ? self.apellidoPaterno.components(separatedBy: " ") : [self.apellidoPaterno]
        let casoMaterno = self.apellidoMaterno.contains(" ") ? self.apellidoMaterno.components(separatedBy: " ") : [self.apellidoMaterno]
        
        if casoNombre.count == 1 && casoPaterno.count == 1 && casoMaterno.count == 1 {
            if casoPaterno[0].count > 2 && casoMaterno[0] != "" {
                self.reglaUno()
            } else if casoPaterno[0].count <= 2 && casoMaterno[0] != "" {
                self.reglaCuatro()
            }
        }
    }
    
    /**
     Calcula las siglas del contribuyente cuando no hay nombre ni apellidos compuestos
     y si estos tienen más de dos letras. El formato es PPMN.
     */
    mutating private func reglaUno() {
        let vocales = ["A", "E", "I", "O", "U"]
        
        // Buscar primer vocal en el apellido paterno
        var primerVocal = ""
        for letra in self.apellidoPaterno where vocales.contains(String(letra)) {
            primerVocal = String(letra)
            break
        }
        
        let letraPaterno = self.apellidoPaterno.first!
        let letraMaterno = self.apellidoMaterno.first!
        let letraNombre = self.nombre.first!
        
        self.siglas = "\(letraPaterno)\(primerVocal)\(letraMaterno)\(letraNombre)"
    }
    
    /**
     Calcula las siglas del contribuyente cuando no hay nombre ni apellidos compuestos
     y si el paterno tiene menos de dos letras. El formato es PMNN.
     */
    mutating private func reglaCuatro() {
        let letraPaterno = self.apellidoPaterno.first!
        let letraMaterno = self.apellidoMaterno.first!
        let primerLetraNombre = self.nombre.first!
        
        let index = self.nombre.index(self.nombre.startIndex, offsetBy: 1)
        let segundaLetraNombre = self.nombre[index]
        
        self.siglas = "\(letraPaterno)\(letraMaterno)\(primerLetraNombre)\(segundaLetraNombre)"
    }
    
    /**
     
     */
    private func reglaCinco() {
        
    }
    
    /**
     
     */
    private func reglaSeis() {
        
    }
    
    /**
     
     */
    private func reglaSiete() {
        
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
     Elimina artículos, preposiciones, conjunciones o contracciones en el nombre o apellido(s).
     Reemplaza las letras "Ch" -> "C" y "Ll" -> "L".
     */
    mutating func filtraNombre() {
        let palabrasAFiltrar = [
            #"\bY\b"#, #"\bE\b"#, #"\bDE\b"#, #"\bLA\b"#, #"\bLAS\b"#, #"\bLOS\b"#,
            #"\bU\b"#, #"\bSR\b"#, #"\bSRA\b"#, #"\bA\b"#, #"\bM\b"#, #"\bDEL\b"#
        ]
        
        let porReemplazar = ["CH", "LL"]
        let reemplazo = ["C", "L"]
        
        // Pasar todo a mayúsculas
        self.nombre = self.nombre.uppercased()
        self.apellidoPaterno = self.apellidoPaterno.uppercased()
        self.apellidoMaterno = self.apellidoMaterno.uppercased()
        
        // Find & Replace
        for i in 0..<2 {
            let porCambiar = porReemplazar[i]
            let cambio = reemplazo[i]
            
            self.nombre = self.nombre.replacingOccurrences(of: porCambiar, with: cambio)
            self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: porCambiar, with: cambio)
            self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: porCambiar, with: cambio)
        }
        
        // Filtrar palabras
        for palabra in palabrasAFiltrar {
            self.nombre = self.nombre.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
            self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
            self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: palabra, with: "", options: .regularExpression, range: nil)
        }
        
        // Remover inconsistencias
        self.nombre = self.nombre.replacingOccurrences(of: "�", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.apellidoPaterno = self.apellidoPaterno.replacingOccurrences(of: "�", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.apellidoMaterno = self.apellidoMaterno.replacingOccurrences(of: "�", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.nombre = self.nombre.trimmingCharacters(in: .whitespaces)
        self.apellidoPaterno = self.apellidoPaterno.trimmingCharacters(in: .whitespaces)
        self.apellidoMaterno = self.apellidoMaterno.trimmingCharacters(in: .whitespaces)
    }
}
