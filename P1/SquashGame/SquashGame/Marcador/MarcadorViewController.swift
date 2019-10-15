//
//  MarcadorViewController.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/9/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class MarcadorViewController: UIViewController {

    @IBOutlet weak var botonRegresar: UIButton!
    @IBOutlet weak var botonBorrar: UIButton!
    
    // Rastreo de mejores puntuaciones
    var puntuaciones: [Int]? = nil
    var fechasDeCreacion: [String]? = nil
    
    /**
     Realiza acciones después de que cargó el controlador.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     Realiza acciones antes de que aparezca el controlador.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.botonRegresar.layer.cornerRadius = 15
        self.botonBorrar.layer.cornerRadius = 15
    }
    
    /**
     Regresa al menú principal desde el modal.
     */
    @IBAction func regresaAlMenu() {
        let inicioVC = self.storyboard?.instantiateViewController(withIdentifier: "inicio")
        self.present(inicioVC!, animated: true, completion: nil)
    }
    
    /**
     Borra el marcador del dispositivo y de la pantalla.
     */
    @IBAction func borrarMarcador(_ sender: UIButton) {
        self.puntuaciones?.removeAll()
        self.fechasDeCreacion?.removeAll()
        self.guardarHistorial()
    }
    
    /**
     Guarda el historial de puntuaciones en el dispositivo.
     */
    private func guardarHistorial() {
        let defaults = UserDefaults.standard
        defaults.set(self.fechasDeCreacion, forKey: "fechas")
        defaults.set(self.puntuaciones, forKey: "puntos")
    }
    
    /**
     Lee del dispositivo el historial de puntuaciones.
     */
    private func cargarHistorial() {
        let defaults = UserDefaults.standard
        self.fechasDeCreacion = defaults.stringArray(forKey: "fechas") ?? [String]()
        self.puntuaciones = defaults.array(forKey: "puntos") as? [Int] ?? [Int]()
    }
}
