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
     Inicializa el marcador de golpes según las medidas de la pantalla.
     
     - Parameter anchoDePantalla: Ancho del dispositivo.
     - Parameter largoDePantalla: Largo del dispositivo.
     */
    init(anchoDePantalla: CGFloat, largoDePantalla: CGFloat) {
        let ancho = anchoDePantalla / 14
        let largo = largoDePantalla / 14
        let puntoX = largoDePantalla * 0.05
        let puntoY = anchoDePantalla * 0.05
        let puntuacion = CGRect(x: puntoX, y: puntoY, width: largo, height: ancho)
        
        super.init(frame: puntuacion)
        self.agregarFuncionalidad()
    }
    
    /**
     Implementación de storyboard.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Agrega las características necesarias para usar la raqueta.
     */
    private func agregarFuncionalidad() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        // Texto inicial
        self.text = "\(self.puntosTotales)"
        self.font = UIFont(name: self.font.fontName, size: 25)
        self.textAlignment = .center
        self.textColor = .brown
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
