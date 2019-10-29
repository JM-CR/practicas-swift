//
//  InventarioDeImagenes.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/23/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

class InventarioDeImagenes {
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImagen(_ imagen: UIImage, paraLaLlave llave: String) {
        self.cache.setObject(imagen, forKey: llave as NSString)
        let url = urlDeImagenEnDisco(para: llave)
        if let data = imagen.jpegData(compressionQuality: 0.5) {
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    func borraImagen(paraLaLlave llave: String) {
        self.cache.removeObject(forKey: llave as NSString)
        try? FileManager.default.removeItem(at: urlDeImagenEnDisco(para: llave))
    }
    
    func getImagen(paraLaLlave llave: String) -> UIImage? {
        if let imagenExistente = self.cache.object(forKey: llave as NSString) {
            return imagenExistente
        }
        
        let url = urlDeImagenEnDisco(para: llave)
        guard let imagenEnDisco = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        cache.setObject(imagenEnDisco, forKey: llave as NSString)
        
        return imagenEnDisco
    }
    
    func urlDeImagenEnDisco(para llave: String) -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(llave)
    }
}
