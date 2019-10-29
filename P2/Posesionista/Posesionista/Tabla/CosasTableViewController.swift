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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Botones para la navegación
        self.navigationItem.leftBarButtonItem = editButtonItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = CGFloat(65)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.miInventario.todasLasCosas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cosaCell", for: indexPath) as! CosaTableViewCell
        
        // Configure the cell...
        let item = miInventario.todasLasCosas[indexPath.row]
//        cell.textLabel?.text = item.nombre
//        cell.detailTextLabel?.text = "$\(item.valorEnPesos)"
        cell.labelNombre.text = item.nombre
        cell.labelPrecio.text = "$\(item.valorEnPesos)"
        cell.labelSerie.text = item.numeroDeSerie
        
        return cell
    }

    /**
     Permite añadir una nueva fila.
     */
    @IBAction func añadeCosas(_ sender: UIBarButtonItem) {
        let nuevaCosa = miInventario.creaCosa()
        let indiceDeNuevaCosa = miInventario.todasLasCosas.firstIndex(of: nuevaCosa)!
//        let ultimaFila = tableView.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: indiceDeNuevaCosa, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let cosaABorrar = miInventario.todasLasCosas[indexPath.row]
            self.miInventario.eliminaCosa(cosaAEliminar: cosaABorrar)
            self.inventarioDeImagenes.borraImagen(paraLaLlave: cosaABorrar.llaveDeCosa)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        miInventario.reordena(de: fromIndexPath.row, hacia: to.row)
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "muestraDetalle" {
            if let filaSeleccionada = self.tableView.indexPathForSelectedRow {
                let detalleVC = segue.destination as! DetalleViewController
                detalleVC.cosaADetallar = miInventario.todasLasCosas[filaSeleccionada.row]
                detalleVC.inventarioDeImagenes = self.inventarioDeImagenes
            }
        }
    }

}
