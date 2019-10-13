//
//  Pelota.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/10/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation
import UIKit

class Pelota: UIView {
    
    /**
     Crea la pelota según las medidas y origen dado.
     
     - Parameter coordenada: Origen.
     - Parameter tamaño: Medidas del obstáculo.
     */
    private init(coordenada: CGPoint, tamaño: CGSize) {
        super.init(frame: CGRect(origin: coordenada, size: tamaño))
    }
    
    /**
     Crea la pelota según las medidas de la pantalla.
     
     - Parameter anchoDePantalla: Ancho del dispositivo.
     - Parameter largoDePantalla: Largo del dispositivo.
     */
    convenience init(anchoDePantalla: CGFloat, largoDePantalla: CGFloat) {
        let ancho = anchoDePantalla / 12
        let largo = anchoDePantalla / 12
        let puntoX = largoDePantalla / 2 - largo * 0.5
        let puntoY = anchoDePantalla - ancho * 3
        
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
     Agrega las características necesarias para usar la pelota.
     */
    private func agregarFuncionalidad() {
        self.backgroundColor = .orange
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.orange.cgColor
        self.clipsToBounds = true
    }
}
