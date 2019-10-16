//
//  Marcador.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/10/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

class Marcador {
    
    var puntuaciones = [Int]()
    var fechas = [String]()
    
    /**
     Carga el historial del dispositivo.
     */
    init() {
        self.cargarHistorial()
    }
    
    /**
     Determina si una nueva puntuación entra en el top.
     
     - Parameter puntaje: Puntuación obtenida en la partida.
     */
    func nuevaPuntuacion(puntaje: Int) {
        // No añadir si el puntaje es cero
        guard puntaje != 0 else {
            return
        }
        
        // Añadir elemento si el historial está vacío
        guard self.puntuaciones.count != 0 else {
            self.puntuaciones.append(puntaje)
            self.fechas.append(self.fechaDeCreacion())
            self.guardarHistorial()
            return
        }
        
        // Verificar si entra en el top
        var nuevoElemento = false    // Bandera
        for (index, numero) in self.puntuaciones.enumerated() {
            if puntaje >= numero {
                self.puntuaciones.insert(puntaje, at: index)
                self.fechas.insert(self.fechaDeCreacion(), at: index)
                nuevoElemento.toggle()
                break
            }
        }
        
        if !nuevoElemento && self.puntuaciones.count < 6 {
            self.puntuaciones.append(puntaje)
            self.fechas.append(self.fechaDeCreacion())
            self.guardarHistorial()
            return
        }
        
        // Borrar elementos que salgan del top
        if self.puntuaciones.count > 6 {
            self.puntuaciones.removeLast()
            self.fechas.removeLast()
        }
        self.guardarHistorial()
    }
    
    /**
     Obtiene la fecha en que se agrega una nueva puntuacion al historial.
     */
    private func fechaDeCreacion() -> String {
        let calendarioActual = Calendar.current
        let fechaActual = Date()
        
        // Obtener tiempo
        let hora = calendarioActual.component(.hour, from: fechaActual)
        let minutos = calendarioActual.component(.minute, from: fechaActual)
        let formatoMinutos = minutos < 9 ? "0\(minutos)" : "\(minutos)"
        let tiempo = "\(hora):\(formatoMinutos)"
        
        // Obtener fecha
        let dia = calendarioActual.component(.day, from: fechaActual)
        let mes = calendarioActual.component(.month, from: fechaActual)
        let año = calendarioActual.component(.year, from: fechaActual)
        let fecha = "\(dia)/\(mes)/\(año)"
        
        return "\(fecha) \(tiempo)";
    }
    
    /**
     Guarda el historial de puntuaciones en el dispositivo.
     */
    func guardarHistorial() {
        let defaults = UserDefaults.standard
        defaults.set(self.fechas, forKey: "fechas")
        defaults.set(self.puntuaciones, forKey: "puntos")
    }
    
    /**
     Lee del dispositivo el historial de puntuaciones.
     */
    func cargarHistorial() {
        let defaults = UserDefaults.standard
        self.fechas = defaults.stringArray(forKey: "fechas") ?? [String]()
        self.puntuaciones = defaults.array(forKey: "puntos") as? [Int] ?? [Int]()
    }
    
    /**
     Borra el historial del dispositivo.
     */
    func borrar() {
        self.puntuaciones.removeAll()
        self.fechas.removeAll()
        self.guardarHistorial()
    }
}
