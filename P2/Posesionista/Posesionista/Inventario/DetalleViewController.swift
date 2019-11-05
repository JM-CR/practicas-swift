//
//  DetalleViewController.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/16/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var campoNombre: UITextField!
    @IBOutlet weak var campoSerie: UITextField!
    @IBOutlet weak var campoPrecio: UITextField!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var botonModificar: UIButton!
    @IBOutlet weak var botonBorrar: UIButton!
    
    let picker = UIImagePickerController()
    var inventarioDeImagenes: InventarioDeImagenes!
    var cosaADetallar: Cosa! {
        didSet {
            self.navigationItem.title = self.cosaADetallar.nombre
        }
    }
    
    // - MARK: Formatters
    
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
    
    // - MARK: Life Cycle
    
    /**
     Realiza acciones después de que se instancia el view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Propiedades
        self.botonModificar.layer.cornerRadius = 10
        
        // Delegado
        self.campoNombre.delegate = self
        self.campoPrecio.delegate = self
        self.campoSerie.delegate = self
        self.picker.delegate = self
        
        // Recuperar datos
        self.campoNombre.text = self.cosaADetallar.nombre
        self.campoSerie.text = self.cosaADetallar.numeroDeSerie
        self.campoPrecio.text = self.formatoDePrecio.string(from: NSNumber(value: cosaADetallar.valorEnPesos))
        self.labelFecha.text = self.formatoDeFecha.string(from: cosaADetallar.fechaDeCreacion)
        
        // Cargar imagen
        if let fotoDeCosa = self.inventarioDeImagenes.getImagen(para: cosaADetallar.llaveDeCosa) {
            self.foto.image = fotoDeCosa
            self.botonBorrar.isHidden = false
        } else {
            self.foto.image = UIImage(named: "No Disponible")
        }
        
        // Agregar gesto para quitar keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tap)
    }
    
    /**
     Realiza acciones cuando la vista está por desaparecer de pantalla.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pasar datos de regreso
        self.cosaADetallar.nombre = self.campoNombre.text!
        self.cosaADetallar.numeroDeSerie = self.campoSerie.text!
        if let valor = self.campoPrecio.text, let valorEntero = self.formatoDePrecio.number(from: valor) {
            self.cosaADetallar.valorEnPesos = valorEntero.intValue
        }
    }
    
    // - MARK: Delegates
    
    /**
     Evita que el usuario salga del controlador al editar un campo.
     
     - Parameter textField: Objeto que acciona el método.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.botonModificar.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    /**
     Responde ante acciones del keyboard en un UITextField.
     
     - Parameter textField: Objeto que acciona el método.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Desaparecer keyboard
        self.view.endEditing(true)
        self.botonModificar.isEnabled = true
        self.navigationItem.setHidesBackButton(false, animated: true)
        return true
    }
    
    /**
     Da tratamiento a la imagen después de que el usuario la selecciona.
     
     - Parameter picker: Controlador que maneja la imagen.
     - Parameter info: Diccionario con propiedades de la imagen.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagen = info[.originalImage] as! UIImage
        self.foto.image = imagen
        self.inventarioDeImagenes.setImagen(imagen, para: self.cosaADetallar.llaveDeCosa)
        self.botonBorrar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    // - MARK: Actions
    
    /**
     Toma una foto para la cosa de la cámara o biblioteca.
     
     - Parameter sender: Objeto que accionó el método.
     */
    @IBAction func tomaFoto(_ sender: UIBarButtonItem) {
        // Origen de la imagen
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        // Mostrar
        present(picker, animated: true, completion: nil)
    }
    
    /**
     Verifica que el usuario no haya dejado campos vacíos.
     
     - Parameter sender: Objeto que invocó al método.
     */
    @IBAction func campoModificado(_ sender: UITextField) {
        do {
            // Validar
            try self.verificaCamposVacios()
        } catch InputError.EmptyField(let descripcion) {
            // Crear alerta con error
            let alerta = UIAlertController(title: "Campo vacío", message: descripcion, preferredStyle: .alert)
            let accion = UIAlertAction(title: "Ok", style: .default) { accion in
                sender.becomeFirstResponder()
            }
            alerta.addAction(accion)
            present(alerta, animated: true, completion: nil)
        } catch { }
    }
    
    /**
     Borra la imagen que eligió el usuario.
     
     - Parameter sender: Botón que invocó al método.
     */
    @IBAction func botonBorrarImagen(_ sender: UIButton) {
        sender.isHidden = true
        self.inventarioDeImagenes.borraImagen(para: self.cosaADetallar.llaveDeCosa)
        self.foto.image = UIImage(named: "No Disponible")
    }
    
    // - MARK: Métodos
    
    /**
     Desaparece el keyboard al dar tap fuera del objeto.
     */
    @objc func didTapView(){
        self.view.endEditing(true)
        self.botonModificar.isEnabled = true
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    /**
     Verifica que ningún detalle quede vacío.
     
     - Throws: InputError.EmptyField
     */
    func verificaCamposVacios() throws {
        guard !(self.campoNombre.text?.isEmpty)! else {
            throw InputError.EmptyField(descripcion: "Debes asignarle un nombre.")
        }
        
        guard !(self.campoSerie.text?.isEmpty)! else {
            throw InputError.EmptyField(descripcion: "Debe haber un número de serie.")
        }
        
        guard self.formatoDePrecio.number(from: self.campoPrecio.text!) != nil else {
            if self.campoPrecio.text?.first != "$" {
                self.campoPrecio.text = "$"
            }
            throw InputError.EmptyField(descripcion: "No puedes dejar el precio vacío.")
        }
    }
    
    /**
     Realiza una acción cuando está por realizarse un segue.
     
     - Parameter segue: Identificador del segue.
     - Parameter sender: Objeto que inició la transición.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seleccionaFecha" {
            // Identificar destino
            let fechaVC = segue.destination as! FechaViewController
            
            // Pasar datos al destino
            fechaVC.delegate = self
            fechaVC.fechaInicial = self.cosaADetallar.fechaDeCreacion
        }
    }
}

/**
 Delegate para actualizar la fecha desde el UIDatePicker.
 */
extension DetalleViewController: DatePickerDelegate {
    
    /**
     Actualiza el texto para el labelFecha.
     
     - Parameter date: Fecha a desplegar.
     */
    func readyToDisplay(_ date: Date) {
        self.cosaADetallar.fechaDeCreacion = date
        self.labelFecha.text = self.formatoDeFecha.string(from: date)
    }
}
