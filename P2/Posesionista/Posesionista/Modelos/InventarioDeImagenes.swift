//
//  InventarioDeImagenes.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/23/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

/**
 Almacena y controla las imágenes de cada cosa.
 */
class InventarioDeImagenes {
    
    let cache = NSCache<NSString, UIImage>()
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    /**
     Toma una imagen dada por el usuario y la guarda en disco y caché.
     
     - Parameter imagen: Imagen a usar.
     - Parameter llave: Identificador de la imagen.
     */
    func setImagen(_ imagen: UIImage, para llave: String) {
        // Agregar en caché
        self.cache.setObject(imagen, forKey: llave as NSString)
        
        // Agregar en disco
        let url = urlDeImagenEnDisco(para: llave)
        if let data = imagen.jpegData(compressionQuality: 0.5) {
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    /**
     Borra una imagen del disco y caché.
     
     - Parameter llave: Identificador de la imagen.
     */
    func borraImagen(para llave: String) {
        // Borrar del caché
        self.cache.removeObject(forKey: llave as NSString)
        
        // Borrar del disco
        try? FileManager.default.removeItem(at: urlDeImagenEnDisco(para: llave))
    }
    
    /**
     Devuelve una imagen del caché o disco.
     
     - Parameter llave: Identificador de la imagen.
     */
    func getImagen(para llave: String) -> UIImage? {
        // Buscar en caché
        if let imagenExistente = self.cache.object(forKey: llave as NSString) {
            return imagenExistente
        }
        
        // Buscar en disco
        let url = urlDeImagenEnDisco(para: llave)
        guard let imagenEnDisco = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        // Guardar en caché para rápido acceso
        self.cache.setObject(imagenEnDisco, forKey: llave as NSString)
        return imagenEnDisco
    }
    
    /**
     Devuelve la URL de una imagen en el sistema de archivos del disco.
     
     - Parameter llave: Identificador de la imagen.
     */
    func urlDeImagenEnDisco(para llave: String) -> URL {
        return self.documentDirectory.appendingPathComponent(llave)
    }
}
