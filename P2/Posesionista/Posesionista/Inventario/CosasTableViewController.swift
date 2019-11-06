//
//  CosasTableViewController.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/9/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

class CosasTableViewController: UITableViewController {

    var inventarios: [Inventario]!
    let inventarioDeImagenes = InventarioDeImagenes()
    
    // - MARK: Life Cycle
    
    /**
     Lectura desde el sistema de archivos del disco.
     
     - Parameter aDecoder: Unarchiver.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     Acciones a realizar cuando se instancia el controlador.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Propiedades de NavigationVC
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Propiedades de tabla
        self.tableView.rowHeight = CGFloat(65)
        
        // Imagen de fondo
        let imagenDeFondo = UIImage(named: "Fondo")
        let imageView = UIImageView(image: imagenDeFondo)
        imageView.contentMode = .scaleToFill
        self.tableView.backgroundView = imageView
    }
    
    /**
     Acciones a realizar cuando está por aparecer en pantalla.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.reloadData()
    }
    
    // - MARK: Métodos
    
    /**
     Añade una nueva cosa al inventario.
     
     - Parameter sender: Objeto barButtonItem que invocó al mètodo.
     */
    @IBAction func añadeCosas(_ sender: UIBarButtonItem) {
        // Crear cosa
        let nuevaCosa = Cosa()
        let seccion = Inventario.indicePara(cosa: nuevaCosa)
        self.inventarios[seccion].cosas.append(nuevaCosa)
        let indice = self.inventarios[seccion].cosas.firstIndex(of: nuevaCosa)!
        
        // Insertar en tabla
        let indexPath = IndexPath(row: indice, section: seccion)
        self.tableView.insertRows(at: [indexPath], with: .fade)
        
        // Recargar sección
        let indexSet: IndexSet = [indexPath.section]
        self.tableView.reloadSections(indexSet, with: .automatic)
    }
    
    // MARK: - Table Style
    
    /**
     Define el texto para el botón de borrar al hacer swipe.
     
     - Parameter tableView: Objeto TableView que invocó al método.
     - Parameter indexPath: Ubicación de la celda en la tabla.
     - Returns: Texto del botón.
     */
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Eliminar"
    }
    
    /**
     Formatea el view de encabezado de sección.
     
     - Parameter tableView: Objeto TableView que invocó al método.
     - Parameter section: Sección mostrada dentro de la tabla.
     - Returns: View con el encabezado.
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Obtener celda reutilizable
        let header = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        
        // Preparar la descripción de la sección
        let precioMinimo = self.inventarios[section].nombreDeSeccion!
        var descripcion = ""
        
        // Obtener rango de precios
        if section == self.inventarios.count - 1 {
            descripcion = "De $\(Int(precioMinimo)! + 1) en adelante"
        } else {
            let precioMaximo = self.inventarios[section + 1].nombreDeSeccion!
            let precioBase = precioMinimo != "0" ? "\(Int(precioMinimo)! + 1)" : "0"
            descripcion = "De $\(precioBase) a $\(precioMaximo)"
        }
        
        // Poner descripción
        header.labelDescripcion.text = descripcion
        
        return header.contentView
    }
    
    /**
     Formatea el view de footer de sección.
     
     - Parameter tableView: Objeto TableView que invocó al método.
     - Parameter section: Sección mostrada dentro de la tabla.
     - Returns: View con el footer.
     */
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Obtener celda reutilizable
        let footer = self.tableView.dequeueReusableCell(withIdentifier: "footerCell") as! FooterTableViewCell
        
        // Mostrar totales
        footer.labelTotalDeCosas.text = "\(self.inventarios[section].cosas.count)"
        footer.labelPrecioTotal.text = self.inventarios[section].precioAcumulado()
        
        return footer.contentView
    }

    // MARK: - Data source

    /**
     Indica al tableView el número de secciones en la tabla.
     
     - Parameter tableView: Objeto TableView que solicita un renglón.
     - Returns: Total de secciones.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.inventarios.count
    }

    /**
     Indica al tableView el número de filas por sección en la tabla.
     
     - Parameter tableView: Objeto TableView que solicita un renglón.
     - Parameter section: Identificador de sección actual.
     - Returns: Total de filas por sección.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inventarios[section].cosas.count
    }

    /**
     Realiza una operación sobre cada renglón del tableView.
     
     - Parameter tableView: Objeto tableView que solicita un renglón.
     - Parameter indexPath: Identificador de celda actual.
     - Returns: Celda configurada.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Obtener celda reutilizable
        let cell = tableView.dequeueReusableCell(withIdentifier: "cosaCell", for: indexPath) as! CosaTableViewCell
        
        // Recuperar datos del modelo
        let item = self.inventarios[indexPath.section].cosas[indexPath.row]
        
        // Formatear celda
        cell.labelNombre.text = item.nombre
        cell.labelPrecio.text = "$\(item.valorEnPesos)"
        cell.labelSerie.text = item.numeroDeSerie
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /**
     Realiza una acción cuando una celda es editada.
     
     - Parameter tableView: Objeto tableView que solicita la accíon.
     - Parameter editingStyle: Modo de edición.
     - Parameter indexPath: Indicador de celda accionada.
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Preguntar confirmación
            let alerta = UIAlertController(title: "¿Seguro?", message: "Estás por borrar un elemento", preferredStyle: .alert)
            
            // Acción de borrar
            let ok = UIAlertAction(title: "Continuar", style: .destructive) { accion in
                // Buscar cosa en el modelo
                let cosaABorrar = self.inventarios[indexPath.section].cosas[indexPath.row]
                
                // Realizar acción
                self.inventarios[indexPath.section].eliminaCosa(cosaAEliminar: cosaABorrar)
                self.inventarioDeImagenes.borraImagen(para: cosaABorrar.llaveDeCosa)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                // Recargar sección
                let indexSet: IndexSet = [indexPath.section]
                self.tableView.reloadSections(indexSet, with: .automatic)
            }
            alerta.addAction(ok)
            
            // Acción de cancelar
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alerta.addAction(cancelar)
            
            // Mostrar
            present(alerta, animated: true, completion: nil)
        }
    }

    /**
     Realiza una acción cuando el usuario arrastra una celda.
     
     - Parameter tableView: Objeto tableView que solicita la accíon.
     - Parameter fromIndexPath: Indicador con la posición anterior de la celda.
     - Parameter to: Indicador con la nueva posición de la celda.
     */
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        self.inventarios[fromIndexPath.section].reordena(de: fromIndexPath.row, hacia: to.row)
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /**
     Realiza una acción cuando está por realzarse un segue.
     
     - Parameter segue: Identificador del segue.
     - Parameter sender: Objeto que inició la transición.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "muestraDetalle", let indexPath = self.tableView.indexPathForSelectedRow {
            // Identificar destino
            let detalleVC = segue.destination as! DetalleViewController
            
            // Pasar datos al destino
            detalleVC.cosaADetallar = self.inventarios[indexPath.section].cosas[indexPath.row]
            detalleVC.inventarioDeImagenes = self.inventarioDeImagenes
        }
    }

}
