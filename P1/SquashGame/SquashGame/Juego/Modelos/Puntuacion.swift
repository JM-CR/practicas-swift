//
//  Puntuacion.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/10/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation
import UIKit

class Puntuacion: UILabel {
    
    var puntosTotales = 0
    
    /**
     Crea el elemento según las medidas y origen dado.
     
     - Parameter coordenada: Origen.
     - Parameter tamaño: Medidas del obstáculo.
     */
    private init(coordenada: CGPoint, tamaño: CGSize) {
        super.init(frame: CGRect(origin: coordenada, size: tamaño))
    }
    
    /**
     Inicializa el marcador de golpes según las medidas de la pantalla.
     
     - Parameter anchoDePantalla: Ancho del dispositivo.
     - Parameter largoDePantalla: Largo del dispositivo.
     */
    convenience init(anchoDePantalla: CGFloat, largoDePantalla: CGFloat) {
        let ancho = anchoDePantalla / 14
        let largo = largoDePantalla / 14
        let puntoX = largoDePantalla * 0.05
        let puntoY = anchoDePantalla * 0.05
        
        // Llamar inicializador designado
        let origen = CGPoint(x: puntoX, y: puntoY)
        let medidas = CGSize(width: largo, height: ancho)
        
        self.init(coordenada: origen, tamaño: medidas)
        self.agregarFuncionalidad()
    }
    
    /**
     Implementación de storyboard.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Agrega las características necesarias para usar la puntuación.
     */
    private func agregarFuncionalidad() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        // Texto inicial
        self.text = "\(self.puntosTotales)"
        self.font = UIFont(name: self.font.fontName, size: 30)
        self.textAlignment = .center
        self.sizeToFit()
    }
    
    /**
     Agrega un punto al marcador si el jugador devuelve la pelota.
     */
    func sumaPunto() {
        self.puntosTotales += 1
    }
    
    /**
     Indica si se debe agregar un nuevo obstáculo.
     
     - Returns: True si el marcador es múltiplo de 10.
     */
    func nuevoObstaculo() -> Bool {
        return self.puntosTotales.isMultiple(of: 10)
    }
}
