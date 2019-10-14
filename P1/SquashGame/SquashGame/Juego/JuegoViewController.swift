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
    
    // Comportamientos
    var limitesDelJuego: UICollisionBehavior!       // Pelota, raqueta, osbtáculo y fronteras
    var vectorDeFuerza: UIPushBehavior!             // Pelota
    var choques: UIDynamicItemBehavior!             // Pelota
    var efectosDeRaqueta: UIDynamicItemBehavior!    // Raqueta
    var animador: UIDynamicAnimator!
    
    // Elementos del juego
    var puntuacion: Puntuacion? = nil
    
    /**
     Inicializa el juego, carga los elementos e implementa comportamientos necesarios.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Elementos iniciales
        self.anchoDePantalla = self.view.bounds.maxY
        self.largoDePantalla = self.view.bounds.maxX
        self.animador = UIDynamicAnimator(referenceView: self.view)   // Comportamientos
        
        // Crear raqueta
        let raqueta = Raqueta(
            anchoDePantalla: self.anchoDePantalla,
            largoDePantalla: self.largoDePantalla,
            animador: self.animador
        )
        self.view.addSubview(raqueta)
        
        // Crear pelota
        let pelota = Pelota(
            anchoDePantalla: self.anchoDePantalla,
            largoDePantalla: self.largoDePantalla
        )
        self.view.addSubview(pelota)
        
        // Preparar puntuación
        let puntuacion = Puntuacion(
            anchoDePantalla: self.anchoDePantalla,
            largoDePantalla: self.largoDePantalla
        )
        self.view.addSubview(puntuacion)
        self.puntuacion = puntuacion
            
        // Añadir efectos
        self.añadirColisiones(pelota, raqueta)
        self.comportamientoDeRaqueta(raqueta)
        self.comportamientoDePelota(pelota)
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
        // Configurar choque elástico
        self.choques = UIDynamicItemBehavior(items: [pelota])
        self.choques.elasticity = 1.0
        self.choques.resistance = 0.0    // Contra el aire
        self.choques.friction = 0.0      // Al chocar
        self.choques.allowsRotation = false
        self.animador.addBehavior(choques)
        
        // Configurar vector de fuerza inicial
        self.vectorDeFuerza = UIPushBehavior(items: [pelota], mode: .instantaneous)
        let fuerzaEnY = CGFloat.random(in: 0.7...1) * -1    // Eje vertical invertido
        var fuerzaEnX: CGFloat
        repeat {
            fuerzaEnX = CGFloat.random(in: -1...1)
        } while fuerzaEnX > -0.4 && fuerzaEnX < 0.4
        
        self.vectorDeFuerza.pushDirection = CGVector(dx: fuerzaEnX, dy: fuerzaEnY)
        self.vectorDeFuerza.magnitude = CGFloat(0.3)    // Velocidad inicial
        self.animador.addBehavior(vectorDeFuerza)
    }
    
    /**
     Añade el comportamiento para que la raqueta funcione dentro del juego.
     
     - Parameter raqueta: Raqueta del juego.
     */
    private func comportamientoDeRaqueta(_ raqueta: UIView) {
        self.efectosDeRaqueta = UIDynamicItemBehavior(items: [raqueta])
        self.efectosDeRaqueta.density = 9000      // Masa inicial
        self.efectosDeRaqueta.isAnchored = true    // No moverse después de colisión
        self.efectosDeRaqueta.allowsRotation = false
        self.animador.addBehavior(efectosDeRaqueta)
    }
    
    /**
     Verifica si la pelota chocó contra la raqueta, si sí aumenta la puntuación en 1
     y checa si hay que agregar un nuevo obstáculo.
     */
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if item1 is Pelota && item2 is Raqueta {
            self.puntuacion!.sumaPunto()
            self.verificarPuntuacion()
        }
    }
    
    /**
     Verifica si la puntuación es múltiplo de 10 para agregar un nuevo obstáculo al juego.
     */
    private func verificarPuntuacion() {
        if self.puntuacion!.esMultiploDeDiez() {
            // Crear obstáculo
            let obstaculo = Obstaculo(anchoDePantalla: self.anchoDePantalla, largoDePantalla: self.largoDePantalla)
            self.view.addSubview(obstaculo)
            
            // Agregar colisión
            self.limitesDelJuego.addItem(obstaculo)
            
            // Añadir física
            let fisicaDelObstaculo = UIDynamicItemBehavior(items: [obstaculo])
            fisicaDelObstaculo.density = 9000       // Masa inicial
            fisicaDelObstaculo.isAnchored = true    // No moverse después de colisión
            fisicaDelObstaculo.allowsRotation = false
            self.limitesDelJuego.addChildBehavior(fisicaDelObstaculo)
        }
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
