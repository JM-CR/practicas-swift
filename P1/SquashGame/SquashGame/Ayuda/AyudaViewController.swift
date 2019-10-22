//
//  AyudaViewController.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/9/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

/**
 Controla la vista de instrucciones del juego.
 */
class AyudaViewController: UIViewController {

    @IBOutlet weak var botonRegresar: UIButton!
    
    /**
     Da formato al botón.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.botonRegresar.layer.cornerRadius = 15
    }

    /**
     Regresa al menú principal desde el modal.
     */
    @IBAction func regresarAlMenu() {
        dismiss(animated: true, completion: nil)
    }
}
