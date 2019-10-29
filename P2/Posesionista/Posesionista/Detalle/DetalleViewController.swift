//
//  DetalleViewController.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/16/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var campoNombre: UITextField!
    @IBOutlet weak var campoSerie: UITextField!
    @IBOutlet weak var campoPrecio: UITextField!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var foto: UIImageView!
    
    var inventarioDeImagenes: InventarioDeImagenes!
    var cosaADetallar: Cosa! {
        didSet {
            navigationItem.title = self.cosaADetallar.nombre
        }
    }
    
    let formatoDeFecha: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let formatoDePrecio: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegado
        self.campoNombre.delegate = self
        self.campoPrecio.delegate = self
        self.campoSerie.delegate = self
        
        // Mostrar texto
        self.campoNombre.text = cosaADetallar.nombre
        self.campoSerie.text = cosaADetallar.numeroDeSerie
        self.campoPrecio.text = formatoDePrecio.string(from: NSNumber(value: cosaADetallar.valorEnPesos))
        self.labelFecha.text = formatoDeFecha.string(from: cosaADetallar.fechaDeCreacion)
        
        // Cargar imagen
        self.foto.image = self.inventarioDeImagenes.getImagen(paraLaLlave: cosaADetallar.llaveDeCosa)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cosaADetallar.nombre = self.campoNombre.text ?? ""
        self.cosaADetallar.numeroDeSerie = self.campoSerie.text ?? ""
        if let valor = self.campoPrecio.text, let valorEntero = self.formatoDePrecio.number(from: valor) {
            self.cosaADetallar.valorEnPesos = valorEntero.intValue
        } else {
            self.cosaADetallar.valorEnPesos = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     Trata la imagen después de que el usuario la selecciona.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagen = info[.originalImage] as! UIImage
        self.foto.image = imagen
        self.inventarioDeImagenes.setImagen(imagen, paraLaLlave: self.cosaADetallar.llaveDeCosa)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tomaFoto(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        
        // Configurar tipo de cámera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        // Delegado
        picker.delegate = self
        
        // Presentar
        present(picker, animated: true, completion: nil)
    }

}
