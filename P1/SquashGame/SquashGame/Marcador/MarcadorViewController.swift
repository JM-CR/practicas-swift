//
//  MarcadorViewController.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/9/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class MarcadorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     Regresa al menú principal desde el modal.
     */
    @IBAction func regresaAlMenu() {
        let inicioVC = self.storyboard?.instantiateViewController(withIdentifier: "inicio")
        self.present(inicioVC!, animated: true, completion: nil)
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
