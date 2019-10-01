//
//  PersonaGeneral.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/27/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

protocol PersonaGeneral: Consola {
    var nombreCompleto: String { get set }
    var siglas: String { get set }
    var digito: String { get set }
    var homoclave: String { get set }
    var fecha: String { get set }
    var dia: Int { get set }
    var mes: Int { get set }
    var año: Int { get set }
    var tablaUno: Dictionary<String, String> { get }
    var tablaDos: Dictionary<Int, String> { get }
    var tablaTres: Dictionary<String, Int> { get }
}

extension PersonaGeneral {
    /**
     Calcula la homoclave según el nombre completo de la persona física o moral.
     */
    mutating func generaHomoclave() {
        // Crear string según la tabla 1
        var numeroEquivalente = "0"
        for caracter in self.nombreCompleto {
            numeroEquivalente += self.tablaUno["\(caracter)"]!
        }
        
        // Suma de multiplicaciones
        let tamaño = numeroEquivalente.count - 1
        var suma = 0
        for (index, primerDigito) in numeroEquivalente.enumerated() where index < tamaño {
            let index = numeroEquivalente.index(numeroEquivalente.startIndex, offsetBy: index + 1)
            let segundoDigito = String(numeroEquivalente[index])
            let factor = Int("\(primerDigito)\(segundoDigito)")!
            suma += factor * Int(segundoDigito)!
        }
        
        // Calcular cociente y residuo
        let index = String(suma).index(String(suma).endIndex, offsetBy: -3)
        let ultimosDigitos = Int(String(suma).suffix(from: index))!
        let residuo = (ultimosDigitos % 34)
        let cociente = (ultimosDigitos - residuo) / 34
        
        // Asignar homoclave
        let primerLetra = self.tablaDos[cociente]!
        let segundaLetra = self.tablaDos[residuo]!
        self.homoclave = "\(primerLetra)\(segundaLetra)"
    }
    
    /**
     Calcula el digito verificador para una persona física o moral.
     */
    mutating func generaDigitoVerificador() {
        // Verificar si es persona moral
        var rfcParcial = "\(self.siglas)\(self.fecha)\(self.homoclave)"
        if self is RFCPersonaMoral {
            rfcParcial = " \(rfcParcial)"
        }
        
        // Calcular suma
        var suma = 0
        for i in 1...12 {
            let index = rfcParcial.index(rfcParcial.startIndex, offsetBy: i - 1)
            let valor = self.tablaTres[String(rfcParcial[index])]!
            suma += valor * (14 - i)
        }
        
        // Match con reglas
        let valor = suma % 11
        switch valor {
        case 0:
            self.digito = "0"
        case 1...9:
            self.digito = "\(11 - valor)"
        default:
            self.digito = "A"
        }
    }
    
    /**
     Permite al usuario introducir un día del mes y guarda su elección en la propiedad dia.
     
     - Returns: Regresa true si el usuario introduce un día válido.
     */
    mutating func seleccionaDia() -> Bool {
        var diaValido = false
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nIngresa el día: ")
            self.dia = try validaDia(valor: entradaDelUsuario)
            diaValido.toggle()
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch InputError.InvalidDayInMonth(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return diaValido
    }
    
    /**
     Valida el día dado en seleccionaDia().
     
     - Parameter valor: Entrada de usuario.
     - Throws: InputError.InvalidCharacter, InputError.InvalidDayInMonth
     - Returns: Día validado.
     */
    private func validaDia(valor: String) throws -> Int {
        let buscaRegEx = valor.range(of: #"^\d*$"#, options: .regularExpression)
        guard buscaRegEx != nil else {
            throw InputError.InvalidCharacter(descripcion: "Introduce un día válido.")
        }
        
        let dia: Int = Int(valor)!
        guard dia > 0 && dia < 32 else {
            throw InputError.InvalidDayInMonth(descripcion: "Día fuera de rango.")
        }
        
        let fechaDelUsuario = DateComponents(calendar: .current, year: Int(self.año), month: Int(self.mes), day: Int(valor))
        guard fechaDelUsuario.isValidDate(in: .current) else {
            throw InputError.InvalidDayInMonth(descripcion: "No existe ese día en el mes.")
        }
        
        let fechaMaxima = Date()
        guard Calendar.current.date(from: fechaDelUsuario)! <= fechaMaxima else {
            throw InputError.InvalidDayInMonth(descripcion: "No puedes ingresar un día futuro.")
        }
        
        return dia
    }
    
    /**
     Muestra un menú al usuario para seleccionar el mes y guarda su elección en la propiedad mes.
     
     - Returns: Regresa true si el usuario escoge una opción válida.
     */
    mutating func seleccionaMes() -> Bool {
        var opcionValida = false
        let texto =
        """
        Selecciona el mes correspondiente
            1. Enero
            2. Febrero
            3. Marzo
            4. Abril
            5. Mayo
            6. Junio
            7. Julio
            8. Agosto
            9. Septiembre
            10. Octubre
            11. Noviembre
            12. Diciembre
        """
        print("\n\(texto)")
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nOpción: ")
            self.mes = try validaMes(opcion: entradaDelUsuario)
            opcionValida.toggle()
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch InputError.InvalidNumberInRange(let descripcion) {
            print(descripcion)
        } catch InputError.InvalidMonth(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return opcionValida
    }
    
    /**
     Valida la opción del menú seleccionaMes().
     
     - Parameter opcion: Entrada de usuario.
     - Throws: InputError.InvalidCharacter, InputError.InvalidNumberInRange
     - Returns: Opción escogida.
     */
    private func validaMes(opcion: String) throws -> Int {
        let buscaRegEx = opcion.range(of: #"^\d*$"#, options: .regularExpression)
        guard buscaRegEx != nil else {
            throw InputError.InvalidCharacter(descripcion: "Solo debes introducir una opción del menú.")
        }
        
        let mes: Int = Int(opcion)!
        guard mes >= 1 && mes <= 12 else {
            throw InputError.InvalidNumberInRange(descripcion: "Opción inválida.")
        }
        
        let mesDelUsuario = mes
        let mesMaximo = Calendar.current.component(.month, from: Date())
        guard mesDelUsuario <= mesMaximo else {
            throw InputError.InvalidMonth(descripcion: "No puedes ingresar un mes futuro.")
        }
        
        return mes
    }
    
    /**
     Permite al usuario introducir un año y guarda su elección en la propiedad año.
     
     - Returns: Regresa true si el usuario introduce un día válido.
     */
    mutating func seleccionaAño() -> Bool {
        var añoValido = false
        
        do {
            let entradaDelUsuario = self.entradaDeTeclado(mensaje: "\nIngresa el año: ")
            self.año = try validaAño(valor: entradaDelUsuario)
            añoValido.toggle()
        } catch InputError.InvalidCharacter(let descripcion) {
            print(descripcion)
        } catch InputError.InvalidYear(let descripcion) {
            print(descripcion)
        } catch {
            print("Error, intenta de nuevo.")
        }
        
        return añoValido
    }
    
    /**
     Valida el año dado en seleccionaAño().
     
     - Parameter valor: Entrada de usuario.
     - Throws: InputError.InvalidCharacter, InputError.InvalidYear
     - Returns: Año validado.
     */
    private func validaAño(valor: String) throws -> Int {
        let buscaRegEx = valor.range(of: #"^\d{4}$"#, options: .regularExpression)
        guard buscaRegEx != nil else {
            throw InputError.InvalidCharacter(descripcion: "Introduce un año válido.")
        }
        
        let año: Int = Int(valor)!
        guard año > 1899 else {
            throw InputError.InvalidYear(descripcion: "Año fuera de rango.")
        }
        
        let añoDelUsuario = Int(valor)!
        let añoMaximo = Calendar.current.component(.year, from: Date())
        guard añoDelUsuario <= añoMaximo else {
            throw InputError.InvalidYear(descripcion: "No puedes ingresar un año futuro.")
        }
        
        return año
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
     Muestra el RFC final.
     */
    func imprimeRFC() {
        print("\n[\(self.nombreCompleto)]")
        print("RFC Asignado: \(self.siglas)-\(self.fecha)-\(self.homoclave)-\(self.digito)")
    }
}
