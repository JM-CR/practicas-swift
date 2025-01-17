//
//  Cosa.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/9/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import Foundation

/**
 Representa una cosa del inventario.
 */
class Cosa: NSObject, NSCoding {
    
    var nombre: String
    var valorEnPesos: Int
    var numeroDeSerie: String?
    var fechaDeCreacion: Date
    let llaveDeCosa: String
    
    /**
     Serializa el objeto y lo almacena en el sistema de archivos del disco.
     
     - Parameter aCoder: Archiver.
     */
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.nombre, forKey: "nombre")
        aCoder.encode(self.valorEnPesos, forKey: "valorEnPesos")
        aCoder.encode(self.numeroDeSerie, forKey: "numeroDeSerie")
        aCoder.encode(self.fechaDeCreacion, forKey: "fechaDeCreacion")
        aCoder.encode(self.llaveDeCosa, forKey: "llaveDeCosa")
    }
    
    /**
     Deserializa una Cosa del sistema de archivos del disco.
     
     - Parameter aDecoder: Unarchiver.
     */
    required init?(coder aDecoder: NSCoder) {
        self.nombre = aDecoder.decodeObject(forKey: "nombre") as! String
        self.valorEnPesos = aDecoder.decodeInteger(forKey: "valorEnPesos")
        self.numeroDeSerie = aDecoder.decodeObject(forKey: "numeroDeSerie") as! String?
        self.fechaDeCreacion = aDecoder.decodeObject(forKey: "fechaDeCreacion") as! Date
        self.llaveDeCosa = aDecoder.decodeObject(forKey: "llaveDeCosa") as! String
        super.init()
    }
    
    /**
     Crea una cosa.
     
     - Parameter nombre: Nombre de la cosa.
     - Parameter valor: Precio.
     - Parameter serie: Número de serie.
     - Parameter alta: Fecha de creación.
     */
    init(nombre: String, valor: Int, serie: String?, alta: Date) {
        self.nombre = nombre
        self.valorEnPesos = valor
        self.numeroDeSerie = serie
        self.fechaDeCreacion = alta
        self.llaveDeCosa = UUID().uuidString
        super.init()
    }
    
    /**
     Crea un objeto Cosa con valores iniciales aleatorios.
     */
    override convenience init() {
        let sustantivos = ["Aguacate", "Termo", "Audífonos"]
        let adjetivos = ["Verde", "Viejo", "Caro"]
        let nombreAleatorio = "\(sustantivos.randomElement()!) \(adjetivos.randomElement()!)"
        let valorAleatorio = Int.random(in: 0...1200)
        let serieAleatorio = UUID().uuidString.components(separatedBy: "-").first!
        self.init(nombre: nombreAleatorio, valor: valorAleatorio, serie: serieAleatorio, alta: Date())
    }
    
}
