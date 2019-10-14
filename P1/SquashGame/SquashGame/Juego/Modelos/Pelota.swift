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
    
    var animador: UIDynamicAnimator!
    var vectorDeFuerza: UIPushBehavior!
    var choques: UIDynamicItemBehavior!
    
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
     - Parameter animador: Encargado de agregar comportamientos de pelota.
     - Parameter view: View donde se añadirá la pelota.
     */
    convenience init(anchoDePantalla: CGFloat, largoDePantalla: CGFloat, animador: UIDynamicAnimator, en view: UIView) {
        let ancho = anchoDePantalla / 12
        let largo = anchoDePantalla / 12
        let puntoX = largoDePantalla / 2 - largo * 0.5
        let puntoY = anchoDePantalla - ancho * 3
        
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
     Agrega las características necesarias para usar la pelota.
     */
    private func agregarFuncionalidad() {
        self.backgroundColor = .orange
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        // Añadir física
        self.comportamientoDePelota()
    }
    
    /**
     Añade el comportamiento para que la pelota funcione dentro del juego.
     */
    private func comportamientoDePelota() {
        // Configurar choque elástico
        self.choques = UIDynamicItemBehavior(items: [self])
        self.choques.elasticity = 1.0
        self.choques.resistance = 0.0    // Contra el aire
        self.choques.friction = 0.0      // Al chocar
        self.choques.allowsRotation = false
        self.animador.addBehavior(self.choques)
        
        // Configurar vector de fuerza inicial
        self.vectorDeFuerza = UIPushBehavior(items: [self], mode: .instantaneous)
        let fuerzaEnY = CGFloat.random(in: 0.7...1) * -1    // Eje vertical invertido
        var fuerzaEnX: CGFloat
        repeat {
            fuerzaEnX = CGFloat.random(in: -1...1)
        } while fuerzaEnX > -0.4 && fuerzaEnX < 0.4
        
        self.vectorDeFuerza.pushDirection = CGVector(dx: fuerzaEnX, dy: fuerzaEnY)
        self.vectorDeFuerza.magnitude = CGFloat(0.5)    // Velocidad inicial
        self.animador.addBehavior(self.vectorDeFuerza)
    }
}
