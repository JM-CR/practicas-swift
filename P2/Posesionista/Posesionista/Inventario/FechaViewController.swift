//
//  FechaViewController.swift
//  Posesionista
//
//  Created by Josue Mosiah Contreras Rocha on 11/3/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

class FechaViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: DatePickerDelegate?
    
    /**
     Realiza acciones cuando el view se terminó de instanciar.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fechaMaxima = Date()
        self.datePicker.maximumDate = fechaMaxima
    }
    
    /**
     Realiza acciones cuando el view está por desaparecer.
     */
    override func viewWillDisappear(_ animated: Bool) {
        let fecha = self.datePicker.date
        self.delegate?.readyToDisplay(fecha)
    }

    /**
     Informa al usuario que se actualizó la fecha de creación.
     
     - Parameter sender: Objeto DatePicker que invocó al método.
     */
    @IBAction func fechaNuevaElegida(_ sender: Any) {
        let alerta = UIAlertController(title: "Cambios guardados", message: "", preferredStyle: .alert)
        let accion = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
}
