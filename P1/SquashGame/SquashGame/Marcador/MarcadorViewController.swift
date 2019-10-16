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
    
    @IBOutlet weak var labelMaximaPuntuacion: UILabel!
    @IBOutlet weak var primerLabel: UILabel!
    @IBOutlet weak var segundoLabel: UILabel!
    @IBOutlet weak var tercerLabel: UILabel!
    @IBOutlet weak var cuartoLabel: UILabel!
    @IBOutlet weak var quintoLabel: UILabel!
    
    var marcador: Marcador? = nil
    var labels = [UILabel]()
    
    /**
     Realiza acciones después de que se instanció el view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.marcador = Marcador()
        self.marcador!.cargarHistorial()
        
        // Añadir labels en arreglo para fácil interacción
        self.labels.append(self.labelMaximaPuntuacion)
        self.labels.append(self.quintoLabel)
        self.labels.append(self.cuartoLabel)
        self.labels.append(self.tercerLabel)
        self.labels.append(self.segundoLabel)
        self.labels.append(self.primerLabel)
    }
    
    /**
     Realiza acciones antes de que aparezca el view.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.botonRegresar.layer.cornerRadius = 15
        self.botonBorrar.layer.cornerRadius = 15
        self.mostrarHistorial()
    }
    
    /**
     Borra el historial de puntuaciones.
     */
    @IBAction func borrarMarcador(_ sender: UIButton) {
        self.marcador!.borrar()
        self.mostrarHistorial()
    }
    
    /**
     Actualiza el contenido de los labels con las puntuaciones.
     */
    private func mostrarHistorial() {
        let totalDeElementos = self.marcador!.historial.count
        for indice in 0...5 {
            if totalDeElementos >= indice + 1 {
                self.labels[indice].text = self.marcador!.historial[indice]
            } else {
                self.labels[indice].text = "Sin puntuación"
            }
        }
    }
    
    /**
     Regresa al menú principal desde el modal.
     */
    @IBAction func regresaAlMenu() {
        let inicioVC = self.storyboard?.instantiateViewController(withIdentifier: "inicio")
        self.present(inicioVC!, animated: true, completion: nil)
    }
}
