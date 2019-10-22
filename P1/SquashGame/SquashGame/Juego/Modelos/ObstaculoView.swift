//
//  Obstaculo.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/10/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class ObstaculoView: UIView {

    var tipoDeObstaculo = 1    // Hay de tres tipos
    var animador: UIDynamicAnimator!
    var fisicaDelObstaculo: UIDynamicItemBehavior!
    var largoDePantalla: CGFloat = 0.0
    var anchoDePantalla: CGFloat = 0.0
    static var obstaculos = [ObstaculoView]()    // Usado para verificar colisiones
    
    /**
     Crea un obstáculo según las medidas y origen dado.
     
     - Parameter coordenada: Origen.
     - Parameter tamaño: Medidas del obstáculo.
     */
    private init(coordenada: CGPoint, tamaño: CGSize) {
        super.init(frame: CGRect(origin: coordenada, size: tamaño))
    }
    
    /**
     Crea un obstáculo de tamaño aleatorio según las medidas de la pantalla.
     
     - Parameter anchoDePantalla: Ancho del dispositivo.
     - Parameter largoDePantalla: Largo del dispositivo.
     - Parameter animador: Encargado de agregar comportamientos de obstáculo.
     - Parameter view: View donde se añadirá el obstáculo.
     */
    convenience init(anchoDePantalla: CGFloat, largoDePantalla: CGFloat, animador: UIDynamicAnimator, en view: UIView) {
        // Generar tamaño del obstáculo
        let ancho = anchoDePantalla / 18
        var largoAleatorio: CGFloat
        let tipoDeObstaculo = Int.random(in: 1...3)
        switch tipoDeObstaculo {
            case 1: largoAleatorio = largoDePantalla / 12
            case 2: largoAleatorio = largoDePantalla / 15
            default: largoAleatorio = largoDePantalla / 18
        }
        
        // Llamar inicializador designado
        let origen = CGPoint(x: 0, y: 0)
        let medidas = CGSize(width: largoAleatorio, height: ancho)
        
        self.init(coordenada: origen, tamaño: medidas)
        self.animador = animador
        self.tipoDeObstaculo = tipoDeObstaculo
        self.largoDePantalla = largoDePantalla
        self.anchoDePantalla = anchoDePantalla
        
        // Verificar colisión entre obstáculos
        self.origenSinColision(en: view)
        ObstaculoView.obstaculos.append(self)
        self.agregarFuncionalidad()
    }
    
    /**
     Implementación de storyboard.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Agrega las características necesarias para usar el obstáculo.
     */
    private func agregarFuncionalidad() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        // Color según el tipo de obstáculo
        var colorAsignado: UIColor
        switch tipoDeObstaculo {
            case 1: colorAsignado = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            case 2: colorAsignado = UIColor(red: 0.55, green: 0.45, blue: 0.35, alpha: 0.5)
            default: colorAsignado = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        }
        self.backgroundColor = colorAsignado
        
        // Añadir fìsica
        self.comportamientoDeObstaculo()
    }
    
    /**
     Añade el comportamiento para que el obstáculo funcione dentro del juego.
     */
    private func comportamientoDeObstaculo() {
        self.fisicaDelObstaculo = UIDynamicItemBehavior(items: [self])
        self.fisicaDelObstaculo.isAnchored = true    // No moverse después de colisión
        self.fisicaDelObstaculo.allowsRotation = false
        self.animador.addBehavior(self.fisicaDelObstaculo)
    }
    
    /**
     Crea un origen aleatorio que no colisione con otros obstáculos.
     
     - Parameter view: View donde se añadirá el obstáculo.
     */
    private func origenSinColision(en view: UIView) {
        var obstaculoValido = false    // Bandera
        
        // Verificar obstáculo creado
        var punto = CGPoint(x: 0, y: 0)
        while !obstaculoValido {
            // Crear punto aleatorio
            punto.x = CGFloat.random(in: 0...self.largoDePantalla - self.bounds.maxX)
            punto.y = CGFloat.random(in: 0...self.anchoDePantalla * (1 - 1/3) - self.bounds.maxY)
            self.frame.origin = punto
            
            // Verificar si es el primer elemento
            guard ObstaculoView.obstaculos.count != 0 else {
                obstaculoValido.toggle()
                view.addSubview(self)
                break
            }
            
            // Verificar colisión
            view.addSubview(self)
            for obstaculo in ObstaculoView.obstaculos {
                if self.frame.intersects(obstaculo.frame) {
                    self.removeFromSuperview()
                    obstaculoValido = false
                    break
                } else {
                    obstaculoValido = true
                }
            }
        }
    }
}
