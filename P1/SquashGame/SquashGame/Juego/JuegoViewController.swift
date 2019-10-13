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
    var animador: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Crear raqueta
        self.anchoDePantalla = self.view.bounds.maxY
        self.largoDePantalla = self.view.bounds.maxX
        let raqueta = Raqueta(anchoDePantalla: self.anchoDePantalla, largoDePantalla: self.largoDePantalla)
        self.view.addSubview(raqueta)
        
        // Crear pelota
        let pelota = Pelota(anchoDePantalla: self.anchoDePantalla, largoDePantalla: self.largoDePantalla)
        self.view.addSubview(pelota)
    
        // Añadir efectos
        self.animador = UIDynamicAnimator(referenceView: self.view)
        self.limitesDelJuego = UICollisionBehavior(items: [pelota, raqueta])
        self.añadirColisiones()
    }

    /**
     Añade los límites de colisión para que la pelota rebote.
     */
    private func añadirColisiones() {
        // Configurar colisiones
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
