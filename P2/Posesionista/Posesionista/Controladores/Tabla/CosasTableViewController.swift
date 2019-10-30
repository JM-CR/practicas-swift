//
//  CosasTableViewController.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/9/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

class CosasTableViewController: UITableViewController {

    var miInventario: Inventario!
    let inventarioDeImagenes = InventarioDeImagenes()
    
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
        
        // Activar botón Editar
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Ancho de fila
        self.tableView.rowHeight = CGFloat(65)
    }
    
    /**
     Acciones a realizar cuando está por aparecer en pantalla.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Data source

    /**
     Indica al tableView el número de secciones en la tabla.
     
     - Parameter tableView: Objeto TableView que solicita un renglón.
     - Returns: Total de secciones.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /**
     Indica al tableView el número de filas por sección en la tabla.
     
     - Parameter tableView: Objeto TableView que solicita un renglón.
     - Parameter section: Identificador de sección actual.
     - Returns: Total de filas por sección.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.miInventario.todasLasCosas.count
    }

    /**
     Realiza una operación sobre cada renglón del tableView.
     
     - Parameter tableView: Objeto tableView que solicita un renglón.
     - Parameter indexPath: Identificador de celda actual.
     - Returns: Celda configurada.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Enlazar con el TableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cosaCell", for: indexPath) as! CosaTableViewCell
        
        // Obtener datos del modelo
        let item = self.miInventario.todasLasCosas[indexPath.row]
        
        // Configurar
        cell.labelNombre.text = item.nombre
        cell.labelPrecio.text = "$\(item.valorEnPesos)"
        cell.labelSerie.text = item.numeroDeSerie
        
        return cell
    }

    /**
     Añade una nueva cosa al inventario.
     
     - Parameter sender: Objeto barButtonItem que invocó al mètodo.
     */
    @IBAction func añadeCosas(_ sender: UIBarButtonItem) {
        // Crear cosa
        let nuevaCosa = self.miInventario.creaCosa()
        
        // Insertar en tabla
        let indiceDeNuevaCosa = self.miInventario.todasLasCosas.firstIndex(of: nuevaCosa)!
        let indexPath = IndexPath(row: indiceDeNuevaCosa, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
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
            // Buscar cosa a borrar en el modelo
            let cosaABorrar = self.miInventario.todasLasCosas[indexPath.row]
            
            // Borrar
            self.miInventario.eliminaCosa(cosaAEliminar: cosaABorrar)
            self.inventarioDeImagenes.borraImagen(para: cosaABorrar.llaveDeCosa)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /**
     Realiza una acción cuando el usuario arrastra una celda.
     
     - Parameter tableView: Objeto tableView que solicita la accíon.
     - Parameter fromIndexPath: Indicador con la posición anterior de la celda.
     - Parameter to: Indicador con la nueva posición de la celda.
     */
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        self.miInventario.reordena(de: fromIndexPath.row, hacia: to.row)
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
        if segue.identifier == "muestraDetalle", let filaSeleccionada = self.tableView.indexPathForSelectedRow {
            // Identificar destino
            let detalleVC = segue.destination as! DetalleViewController
            
            // Pasar datos al destino
            detalleVC.cosaADetallar = miInventario.todasLasCosas[filaSeleccionada.row]
            detalleVC.inventarioDeImagenes = self.inventarioDeImagenes
        }
    }

}
