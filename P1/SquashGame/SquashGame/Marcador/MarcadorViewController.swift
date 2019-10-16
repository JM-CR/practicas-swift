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
    
    var marcador: Marcador? = nil
    
    /**
     Realiza acciones después de que se instanció el view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.marcador = Marcador()
        self.marcador!.cargarHistorial()
    }
    
    /**
     Realiza acciones antes de que aparezca el view.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.botonRegresar.layer.cornerRadius = 15
        self.botonBorrar.layer.cornerRadius = 15
    }
    
    /**
     Borra el historial de puntuaciones.
     */
    @IBAction func borrarMarcador(_ sender: UIButton) {
        self.marcador!.borrar()
    }
    
    /**
     Regresa al menú principal desde el modal.
     */
    @IBAction func regresaAlMenu() {
        let inicioVC = self.storyboard?.instantiateViewController(withIdentifier: "inicio")
        self.present(inicioVC!, animated: true, completion: nil)
    }
}
