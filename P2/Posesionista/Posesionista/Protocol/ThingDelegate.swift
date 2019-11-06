//
//  ThingDelegate.swift
//  Posesionista
//
//  Created by Josue Mosiah Contreras Rocha on 11/6/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import Foundation

protocol ThingDelegate: AnyObject {
    func verificaCambio(seccionPrevia: Int, seccionNueva: Int, cosa: Cosa)
}
