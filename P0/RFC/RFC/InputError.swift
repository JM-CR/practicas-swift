//
//  InputError.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/26/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

enum InputError: Error {
    case InvalidNumberInRange(descripcion: String)
    case InvalidCharacter(descripcion: String)
}
