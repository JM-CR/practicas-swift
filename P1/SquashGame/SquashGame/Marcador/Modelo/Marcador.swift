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
    var historial = [String]()
    
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
            self.creaRegistro(totalDePuntos: puntaje, en: 0)
            return
        }
        
        // Verificar si es el mejor
        if puntaje > self.puntuaciones[0] {
            self.creaRegistro(totalDePuntos: puntaje, en: 0)
        } else {
            self.creaRegistro(totalDePuntos: puntaje, en: nil)
        }
    }
    
    /**
     Añade un elemento al historial de partidas.
     
     - Parameter totalDePuntos: Puntuación obtenida en la partida.
     - Parameter indice: Indica la posición donde agregar al elemento. Si es nil al final.
     */
    private func creaRegistro(totalDePuntos: Int, en indice: Int?) {
        // No agregar más si ya son seis
        guard self.puntuaciones.count <= 6 else {
            return
        }
        
        // Crear entrada
        var texto: String
        let fechaDeRegistro = self.fechaDeCreacion()
        if totalDePuntos == 1 {
            texto = "Obtuviste \(totalDePuntos) punto el \(fechaDeRegistro)"
        } else {
            texto = "Obtuviste \(totalDePuntos) puntos el \(fechaDeRegistro)"
        }
        
        // Agregar al historial
        if let posicion = indice {
            self.puntuaciones.insert(totalDePuntos, at: posicion)
            self.historial.insert(texto, at: posicion)
        } else {
            self.puntuaciones.append(totalDePuntos)
            self.historial.append(texto)
        }
        
        // Borrar elementos extra
        if self.puntuaciones.count > 6 {
            self.puntuaciones.remove(at: 1)
            self.historial.remove(at: 1)
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
        
        return "\(fecha) a las \(tiempo)";
    }
    
    /**
     Guarda el historial de puntuaciones en el dispositivo.
     */
    func guardarHistorial() {
        let defaults = UserDefaults.standard
        defaults.set(self.historial, forKey: "historial")
        defaults.set(self.puntuaciones, forKey: "puntos")
    }
    
    /**
     Lee del dispositivo el historial de puntuaciones.
     */
    func cargarHistorial() {
        let defaults = UserDefaults.standard
        self.historial = defaults.stringArray(forKey: "historial") ?? [String]()
        self.puntuaciones = defaults.array(forKey: "puntos") as? [Int] ?? [Int]()
    }
    
    /**
     Borra el historial del dispositivo.
     */
    func borrar() {
        self.puntuaciones.removeAll()
        self.historial = [String]()
        self.guardarHistorial()
    }
}
