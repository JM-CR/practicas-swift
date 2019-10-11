//
//  AyudaViewController.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/9/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class AyudaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /**
     Regresa al menú principal desde el modal.
     */
    @IBAction func regresarAlMenu() {
        dismiss(animated: true, completion: nil)
    }
}
