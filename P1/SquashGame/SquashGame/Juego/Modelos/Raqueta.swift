//
//  Raqueta.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/10/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation
import UIKit

class Raqueta: UIView {
    
    var centro = CGPoint(x: 0, y: 0)
    var animador: UIDynamicAnimator!
    
    /**
     Crea la raqueta inicial según las medidas de la pantalla.
     
     - Parameter anchoDePantalla: Ancho del dispositivo.
     - Parameter largoDePantalla: Largo del dispositivo.
     - Parameter animador: Encargado de agregar efectos en raqueta.
     */
    init(anchoDePantalla: CGFloat, largoDePantalla: CGFloat, animador: UIDynamicAnimator) {
        let ancho = anchoDePantalla / 12
        let largo = largoDePantalla / 6
        let puntoX = largoDePantalla / 2 - largo * 0.5
        let puntoY = anchoDePantalla - ancho * 1.7
        let raqueta = CGRect(x: puntoX, y: puntoY, width: largo, height: ancho)
        
        super.init(frame: raqueta)
        self.animador = animador
        self.agregarFuncionalidad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Agrega las características necesarias para usar la raqueta.
     */
    private func agregarFuncionalidad() {
        self.backgroundColor = .brown
        
        // "Drag gesture" para mover la raqueta horizontalmente
        let dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan))
        self.gestureRecognizers = [dragRecognizer]
    }
    
    /**
     Acción a realizar cuando se detecta un drag sobre la raqueta.
     
     - Parameter recognizer: Gesto detectado.
     */
    @objc func detectPan(_ recognizer: UIPanGestureRecognizer) {
        let translacion = recognizer.translation(in: self.superview)
        
        switch recognizer.state {
        case .began:
            self.centro = self.center
        case .changed:
            self.center = CGPoint(x: self.centro.x + translacion.x, y: self.centro.y)
            self.animador.updateItem(usingCurrentState: self)
        default:
            self.center = CGPoint(x: self.centro.x + translacion.x, y: self.centro.y)
        }
    }
}
