//
//  CosaTableViewCell.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/16/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

class CosaTableViewCell: UITableViewCell {

    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelSerie: UILabel!
    @IBOutlet weak var labelPrecio: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    /**
     Realiza una acción cuando aparece en el storyboard.
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /**
     Establece el estado de la celda cuando es seleccionada.
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
