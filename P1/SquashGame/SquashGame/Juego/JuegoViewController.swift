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
    var limitesDelJuego: UICollisionBehavior!    // Pelota, raqueta, osbtáculo y fronteras
    var animador: UIDynamicAnimator!
    
    // Elementos del juego
    var puntuacion: Puntuacion? = nil
    var pelota: Pelota? = nil
    var raqueta: Raqueta? = nil
    
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
        self.raqueta = Raqueta(
            anchoDePantalla: self.anchoDePantalla,
            largoDePantalla: self.largoDePantalla,
            animador: self.animador,
            en: self.view
        )
        
        // Crear pelota
        self.pelota = Pelota(
            anchoDePantalla: self.anchoDePantalla,
            largoDePantalla: self.largoDePantalla,
            animador: self.animador,
            en: self.view
        )
        
        // Preparar puntuación
        self.puntuacion = Puntuacion(
            anchoDePantalla: self.anchoDePantalla,
            largoDePantalla: self.largoDePantalla,
            en: self.view
        )
        
        // Añadir efectos
        self.añadirColisiones(pelota!, raqueta!)
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
        
        // Añadir frontera
        self.agregarZonaPerdedora()
        self.animador.addBehavior(self.limitesDelJuego)
    }
    
    /**
     Añade la frontera inferior donde pierde el usuario.
     */
    private func agregarZonaPerdedora() {
        // Entre puntos
        let puntoUno = CGPoint(x: 0, y: anchoDePantalla)
        let puntoDos = CGPoint(x: largoDePantalla, y: anchoDePantalla)
        
        // Agregar a colisiones
        self.limitesDelJuego.addBoundary(
            withIdentifier: "inferior" as NSCopying,
            from: puntoUno,
            to: puntoDos
        )
    }
        
    /**
     Verifica si la pelota chocó contra la raqueta, si sí aumenta la puntuación en 1
     y checa si hay que agregar un nuevo obstáculo.
     */
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if (item1 is Pelota && item2 is Raqueta) || (item1 is Raqueta && item2 is Pelota) {
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
            let obstaculo = Obstaculo(
                anchoDePantalla: self.anchoDePantalla,
                largoDePantalla: self.largoDePantalla,
                animador: self.animador,
                en: self.view
            )
            
            // Agregar a colisiones
            self.limitesDelJuego.addItem(obstaculo)
        }
    }
    
    /**
     Informa al usuario que perdió el juego si la pelota toca la parte inferior de la pantalla.
     Redirecciona hacia marcadores y detiene el juego.
     */
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if item is Pelota && identifier as? String == "inferior" {
            let alerta = UIAlertController(
                title: "!Has perdido!",
                message: "Presiona el botón para continuar.",
                preferredStyle: .alert
            )
            
            let haciaMarcadores = UIAlertAction(title: "Ir a marcadores.", style: .default) { action in
                // TODO: Agregar navegación hacia marcadores.
            }
            
            alerta.addAction(haciaMarcadores)
            self.present(alerta, animated: true, completion: nil)
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
