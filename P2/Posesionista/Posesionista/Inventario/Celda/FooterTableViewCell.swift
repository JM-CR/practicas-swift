//
//  FooterTableViewCell.swift
//  Posesionista
//
//  Created by Josue Mosiah Contreras Rocha on 11/3/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTotalDeCosas: UILabel!
    @IBOutlet weak var labelPrecioTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
