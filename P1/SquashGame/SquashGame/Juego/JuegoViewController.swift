//
//  JuegoViewController.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/9/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class JuegoViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var anchoDePantalla: CGFloat = 0.0
    var largoDePantalla: CGFloat = 0.0
    var limitesDelJuego: UICollisionBehavior!
    var vectorDeFuerza: UIPushBehavior!
    var choques: UIDynamicItemBehavior!
    var efectosDeRaqueta: UIDynamicItemBehavior!
    var animador: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preparar efectos
        self.animador = UIDynamicAnimator(referenceView: self.view)
        
        // Crear raqueta
        self.anchoDePantalla = self.view.bounds.maxY
        self.largoDePantalla = self.view.bounds.maxX
        let raqueta = Raqueta(anchoDePantalla: self.anchoDePantalla, largoDePantalla: self.largoDePantalla, animador: self.animador)
        self.view.addSubview(raqueta)
        
        // Crear pelota
        let pelota = Pelota(anchoDePantalla: self.anchoDePantalla, largoDePantalla: self.largoDePantalla)
        self.view.addSubview(pelota)
    
        // Añadir efectos
        self.añadirColisiones(pelota, raqueta)
        self.comportamientoDePelota(pelota)
        self.comportamientoDeRaqueta(raqueta)
    }

    /**
     Añade los límites de colisión para que la pelota rebote.
     
     - Parameter pelota: Pelota del juego.
     - Parameter raqueta: Raqueta del juego.
     */
    private func añadirColisiones(_ pelota: UIView, _ raqueta: UIView) {
        // Configurar colisiones
        self.limitesDelJuego = UICollisionBehavior(items: [pelota, raqueta])
        self.limitesDelJuego.translatesReferenceBoundsIntoBoundary = true
        self.limitesDelJuego.collisionMode = .everything
        self.limitesDelJuego.collisionDelegate = self
        
        // Añadir límites
        self.agregarLimitesDePantalla()
        self.animador.addBehavior(self.limitesDelJuego)
    }
    
    /**
     Crea el perímetro que contendrá al juego.
     */
    private func agregarLimitesDePantalla() {
        // Límite superior
        var puntoUno = CGPoint(x: 0, y: 0)
        var puntoDos = CGPoint(x: 0, y: largoDePantalla)
        crearFrontera(inicio: puntoUno, fin: puntoDos, nombre: "superior")
        
        // Límite izquierdo
        puntoDos = CGPoint(x: 0, y: anchoDePantalla)
        crearFrontera(inicio: puntoUno, fin: puntoDos, nombre: "izquierda")
        
        // Límite derecho
        puntoUno = CGPoint(x: 0, y: largoDePantalla)
        puntoDos = CGPoint(x: largoDePantalla, y: largoDePantalla)
        crearFrontera(inicio: puntoUno, fin: puntoDos, nombre: "derecha")
        
        // Límite inferior
        puntoUno = CGPoint(x: 0, y: anchoDePantalla)
        puntoDos = CGPoint(x: anchoDePantalla, y: largoDePantalla)
        crearFrontera(inicio: puntoUno, fin: puntoDos, nombre: "inferior")
    }
    
    /**
     Añade una frontera entre los puntos dados al límite del juego.
     
     - Parameter inicio: Punto inicial.
     - Parameter fin: Punto final.
     - Parameter nombre: Identificador de la frontera.
     */
    private func crearFrontera(inicio: CGPoint, fin: CGPoint, nombre: String) {
        self.limitesDelJuego.addBoundary(
            withIdentifier: NSString(string: nombre),
            from: inicio,
            to: fin
        )
    }
    
    /**
     Añade el comportamiento para que la pelota funcione dentro del juego.
     
     - Parameter pelota: Pelota del juego.
     */
    private func comportamientoDePelota(_ pelota: UIView) {
        // Configurar vector de fuerza inicial
        self.vectorDeFuerza = UIPushBehavior(items: [pelota], mode: UIPushBehavior.Mode.instantaneous)
        let fuerzaEnX = CGFloat.random(in: 0.4...1)
        let fuerzaEnY = CGFloat(1)
        self.vectorDeFuerza.pushDirection = CGVector(dx: fuerzaEnX, dy: fuerzaEnY)
        self.vectorDeFuerza.magnitude = CGFloat(0.6)    // Velocidad inicial
        self.animador.addBehavior(vectorDeFuerza)
        
        // Configurar choque elástico
        self.choques = UIDynamicItemBehavior(items: [pelota])
        self.choques.elasticity = 1.0
        self.choques.resistance = 0.0    // Contra el aire
        self.choques.friction = 0.0      // Al chocar
        self.choques.allowsRotation = false
        self.animador.addBehavior(choques)
    }
    
    /**
     Añade el comportamiento para que la raqueta funcione dentro del juego.
     
     - Parameter raqueta: Raqueta del juego.
     */
    private func comportamientoDeRaqueta(_ raqueta: UIView) {
        self.efectosDeRaqueta = UIDynamicItemBehavior(items: [raqueta])
        self.efectosDeRaqueta.density = 10000
        self.efectosDeRaqueta.resistance = 100
        self.efectosDeRaqueta.allowsRotation = false
        self.efectosDeRaqueta.isAnchored = true    // No moverse después de colisión
        self.animador.addBehavior(efectosDeRaqueta)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
