//
//  InicioViewController.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/9/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

/**
 Controla el root view de la aplicación.
 */
class InicioViewController: UIViewController {

    @IBOutlet weak var botonJugar: UIButton!
    @IBOutlet weak var botonMarcadores: UIButton!
    @IBOutlet weak var botonInstrucciones: UIButton!
    
    /**
     Da formato a los botones.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.botonJugar.layer.cornerRadius = 15
        self.botonMarcadores.layer.cornerRadius = 15
        self.botonInstrucciones.layer.cornerRadius = 15
    }
    
}
