//
//  PersonaMoral.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

protocol PersonaMoral: PersonaGeneral {
    var nombre: String { get set }
    var tipoDeSociedad: String { get set }
    var tablaCinco: Array<String> { get }
}

extension PersonaMoral {
    func validaNombre() -> Bool {
        return true
    }
    
    /**
     Muestra un menú al usuario para seleccionar el tipo de sociedad y
     guarda su elección en la propiedad tipoDeSociedad.
     
     - Returns: Regresa true si el usuario escoge una opción válida.
     */
    mutating func seleccionaTipoDeSociedad() -> Bool {
        var opcionValida = false
        let opciones = [
            "A. en P.", "A.C.", "E. en N.C.", "S. en N.C.", "S. en C.",
            "S. de R.L.", "S. en C. por A.", "S.A.", "S.A de C.V.", "S.C.",
            "S.C.L.", "S.C.S.", "S.N.C.", "I.A.P.", "R.L."
        ]
        let texto =
        """
        Elige el tipo de sociedad
            1. A. en P.            10. S.C.
            2. A.C.                11. S.C.L.
            3. E. en N.C.          12. S.C.S.
            4. S. en N.C.          13. S.N.C.
            5. S. en C.            14. I.A.P.
            6. S. de R.L.          15. R.L.
            7. S. en C. por A.
            8. S.A.
            9. S.A de C.V.
        """
        print("\n\(texto)")
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nOpción: ")
            let tipoDeSociedad = try validaTipoDeSociedad(opcion: entradaDelUsuario)
            self.tipoDeSociedad = opciones[tipoDeSociedad - 1]
            opcionValida.toggle()
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch InputError.InvalidNumberInRange(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return opcionValida
    }
    
    /**
     Valida la opción del menú seleccionaTipoDeSociedad().
     
     - Parameter opcion: Entrada de usuario.
     - Throws: InputError.InvalidCharacter, InputError.InvalidNumberInRange
     - Returns: Opción escogida.
     */
    private func validaTipoDeSociedad(opcion: String) throws -> Int {
        let buscaRegEx = opcion.range(of: #"^\d*$"#, options: .regularExpression)
        guard buscaRegEx != nil else {
            throw InputError.InvalidCharacter(descripcion: "Solo debes introducir una opción del menú.")
        }
        
        let tipo: Int = Int(opcion)!
        guard tipo >= 1 && tipo <= 15 else {
            throw InputError.InvalidNumberInRange(descripcion: "Opción inválida.")
        }
        
        return tipo
    }
    
    /**
     Permite al usuario introducir la razón social y la guarda en la propiedad nombre.
     
     - Returns: Regresa true si la razón es válida.
     */
    mutating func introduceNombre() -> Bool {
        var razonValida = false
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nIngresa la razón social: ")
            self.nombre = try validaEmpresa(empresa: entradaDelUsuario)
            razonValida.toggle()
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return razonValida
    }
    
    /**
     Valida la razón social introducida.
     
     - Parameter empresa: Razón social.
     - Throws: InputError.InvalidCharacter
     - Returns: Texto validado.
     */
    private func validaEmpresa(empresa: String?) throws -> String {
        if let valor = empresa {
            guard valor != "" else {
                throw InputError.InvalidCharacter(descripcion: "No puedes dejar el campo vacío.")
            }
        } else {
            throw InputError.InvalidCharacter(descripcion: "Error desconocido, introdúcelo de nuevo.")
        }
        
        var buscaRegEx = empresa!.range(of: #":"#, options: .regularExpression)
        guard buscaRegEx == nil else {
            throw InputError.InvalidCharacter(descripcion: "Texto inválido.")
        }
        
        buscaRegEx = empresa!.range(of: #"[^.{1,}$]"#, options: .regularExpression)
        guard buscaRegEx != nil else {
            throw InputError.InvalidCharacter(descripcion: "Texto inválido.")
        }
        
        buscaRegEx = empresa!.range(of: #"[?_!'¿¡|@=()-#·&/*}{^`+¨ªº\[\]Ç;ç´]"#, options: .regularExpression)
        guard buscaRegEx == nil else {
            throw InputError.InvalidCharacter(descripcion: "Texto inválido.")
        }
        
        buscaRegEx = empresa!.range(of: #"[áéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜâêîôûÂÊÎÔÛ]"#, options: .regularExpression)
        guard buscaRegEx == nil else {
            throw InputError.InvalidCharacter(descripcion: "No introduzcas acentos.")
        }
        
        // TODO: Validar doble punto y doble coma
        
        return empresa!
    }
}
