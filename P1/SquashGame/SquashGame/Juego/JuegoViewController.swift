//
//  JuegoViewController.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/9/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

/**
 Controla todo el comportamiento del juego.
 */
class JuegoViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var botonPausa: UIButton!
    var anchoDePantalla: CGFloat = 0.0
    var largoDePantalla: CGFloat = 0.0
    
    // Comportamientos
    var limitesDelJuego: UICollisionBehavior!    // Pelota, raqueta, osbtáculo y fronteras
    var animador: UIDynamicAnimator!
    
    // Elementos del juego
    var puntuacion: Puntuacion? = nil
    var pelota: PelotaView? = nil
    var raqueta: RaquetaView? = nil
    var sonido = Sonido()
    
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
        self.raqueta = RaquetaView(
            anchoDePantalla: self.anchoDePantalla,
            largoDePantalla: self.largoDePantalla,
            animador: self.animador,
            en: self.view
        )
        
        // Crear pelota
        self.pelota = PelotaView(
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
        self.añadirColisiones()
    }
    
    /**
     Arroja la pelota después de escuchar el sonido inicial del juego.
     */
    override func viewDidAppear(_ animated: Bool) {
        self.sonido.reproduce(archivoSinExtension: "Start")
        
        // Esperar a que acabe el sonido
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.pelota!.lanzar()
            
            // Mostrar pausa
            self.botonPausa.isHidden = false
        }
    }

    /**
     Añade los límites de colisión para que la pelota rebote.
     */
    private func añadirColisiones() {
        // Configurar colisiones
        self.limitesDelJuego = UICollisionBehavior(items: [self.pelota!, self.raqueta!])
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
        if (item1 is PelotaView && item2 is RaquetaView) || (item1 is RaquetaView && item2 is PelotaView) {
            self.pelota!.cambiarColor()
            self.sonido.reproduce(archivoSinExtension: "Racket")
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
            let obstaculo = ObstaculoView(
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
     Detecta si el usuario perdió cuando la pelota toca la parte inferior de la pantalla.
     */
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if item is PelotaView {
            switch identifier as? String {
            case "inferior":
                self.finDelJuego()
            default:
                self.sonido.reproduce(archivoSinExtension: "Boundary")
            }
        }
    }
    
    /**
     Detiene el juego, manda una alerta y reproduce un sonido cuando el usuario pierde.
     */
    private func finDelJuego() {
        // Eliminar pelota
        self.limitesDelJuego.removeItem(self.pelota!)
        self.pelota!.removeFromSuperview()
        
        // Eliminar comportamientos
        self.limitesDelJuego.removeAllBoundaries()
        self.animador.removeAllBehaviors()
        
        // Vaciar arreglo de obstáculos
        ObstaculoView.obstaculos.removeAll()
        
        // Sonido de que perdió
        self.sonido.reproduce(archivoSinExtension: "End")
        
        // Mensaje de que perdió
        self.mensajeFinDeJuego()
    }
    
    /**
     Muestra una alerta indicando al usuario que perdió el juego y redirecciona hacia marcadores.
     */
    private func mensajeFinDeJuego() {
        // Crear alerta
        let alerta = UIAlertController(
            title: "!Has perdido!",
            message: "Presiona el botón para continuar.",
            preferredStyle: .alert
        )
        
        // Configurar acción
        let haciaMarcador = UIAlertAction(title: "Ir a marcadores.", style: .default) { evento in
            // Mandar nueva puntuacion al marcador
            let marcador = Marcador()
            marcador.nuevaPuntuacion(puntaje: self.puntuacion!.puntosTotales)
            
            // Crear y redireccionar
            let marcadorVC = self.storyboard?.instantiateViewController(withIdentifier: "marcador")
            self.present(marcadorVC!, animated: true, completion: nil)
        }
        alerta.addAction(haciaMarcador)
        
        // Mostrar
        self.present(alerta, animated: true, completion: nil)
    }
    
    /**
     Pausa el juego y lo reanuda.
     */
    @IBAction func pausarJuego(_ sender: UIButton) {
        let alerta = self.pelota!.pausa()
        self.present(alerta, animated: true, completion: nil)
    }
}
