//
//  PersonaMoral.swift
//  RFC
//
//  Created by Josue Mosiah Contreras Rocha on 9/23/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import Foundation

protocol PersonaMoral: PersonaGeneral {
    var nombre: String { get set }
    var tablaCinco: Array<String> { get }
}

extension PersonaMoral {
    func validaNombre() -> Bool {
        return true
    }
}
