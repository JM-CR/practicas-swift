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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
