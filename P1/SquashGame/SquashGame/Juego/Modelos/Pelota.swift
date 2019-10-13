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
     Crea la pelota según las medidas de la pantalla.
     
     - Parameter anchoDePantalla: Ancho del dispositivo.
     - Parameter largoDePantalla: Largo del dispositivo.
     */
    init(anchoDePantalla: CGFloat, largoDePantalla: CGFloat) {
        let ancho = anchoDePantalla / 12
        let largo = anchoDePantalla / 12
        let puntoX = largoDePantalla / 2 - largo * 0.5
        let puntoY = anchoDePantalla - ancho * 3
        
        let pelota = CGRect(x: puntoX, y: puntoY, width: largo, height: ancho)
        super.init(frame: pelota)
        self.agregarFuncionalidad()
    }
    
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
