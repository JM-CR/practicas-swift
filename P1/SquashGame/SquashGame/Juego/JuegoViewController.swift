//
//  JuegoViewController.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/9/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import UIKit

class JuegoViewController: UIViewController {
    
    var anchoDePantalla: CGFloat = 0.0
    var largoDePantalla: CGFloat = 0.0
    
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
