//
//  DatePickerDelegate.swift
//  Posesionista
//
//  Created by Josue Mosiah Contreras Rocha on 11/4/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import Foundation

protocol DatePickerDelegate: DetalleViewController {
    func readyToDisplay(_ date: Date)
}
