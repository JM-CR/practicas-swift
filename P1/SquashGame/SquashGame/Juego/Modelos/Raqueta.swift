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
    var efectosDeRaqueta: UIDynamicItemBehavior!
    
    /**
     Crea la raqueta según las medidas y origen dado.
     
     - Parameter coordenada: Origen.
     - Parameter tamaño: Medidas del obstáculo.
     */
    private init(coordenada: CGPoint, tamaño: CGSize) {
        super.init(frame: CGRect(origin: coordenada, size: tamaño))
    }
    
    /**
     Crea la raqueta inicial según las medidas de la pantalla.
     
     - Parameter anchoDePantalla: Ancho del dispositivo.
     - Parameter largoDePantalla: Largo del dispositivo.
     - Parameter animador: Encargado de agregar comportamientos de raqueta.
     - Parameter view: View donde se añadirá la raqueta.
     */
    convenience init(anchoDePantalla: CGFloat, largoDePantalla: CGFloat, animador: UIDynamicAnimator, en view: UIView) {
        let ancho = anchoDePantalla / 12
        let largo = largoDePantalla / 6
        let puntoX = largoDePantalla / 2 - largo * 0.5
        let puntoY = anchoDePantalla - ancho * 1.7
        
        // Llamar inicializador designado
        let origen = CGPoint(x: puntoX, y: puntoY)
        let medidas = CGSize(width: largo, height: ancho)
        
        self.init(coordenada: origen, tamaño: medidas)
        view.addSubview(self)
        self.animador = animador
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
        self.backgroundColor = .brown
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        // "Drag gesture" para mover la raqueta horizontalmente
        let dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(raquetaMovida))
        self.isUserInteractionEnabled = true
        self.gestureRecognizers = [dragRecognizer]
        
        // Añadir físicas
        self.comportamientoDeRaqueta()
    }
    
    /**
     Acción a realizar cuando se detecta un drag sobre la raqueta.
     
     - Parameter recognizer: Gesto detectado.
     */
    @objc func raquetaMovida(_ recognizer: UIPanGestureRecognizer) {
        let translacion = recognizer.translation(in: self.superview)
        
        switch recognizer.state {
        case .began:
            self.centro = self.center
        case .changed:
            self.center = CGPoint(x: self.centro.x + translacion.x, y: self.centro.y)
            self.animador.updateItem(usingCurrentState: self)   // Actualizar posición en el animador
        default:
            self.center = CGPoint(x: self.centro.x + translacion.x, y: self.centro.y)
        }
    }
    
    /**
     Añade el comportamiento para que la raqueta funcione dentro del juego.
     */
    private func comportamientoDeRaqueta() {
        self.efectosDeRaqueta = UIDynamicItemBehavior(items: [self])
        self.efectosDeRaqueta.density = 9000      // Masa inicial
        self.efectosDeRaqueta.isAnchored = true    // No moverse después de colisión
        self.efectosDeRaqueta.allowsRotation = false
        self.animador.addBehavior(efectosDeRaqueta)
    }
}
