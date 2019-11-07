//
//  InventarioDeThumbnails.swift
//  Posesionista
//
//  Created by Josue Mosiah Contreras Rocha on 11/7/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

/**
 Almacena y controla los thumbnails de cada cosa.
 */
class InventarioDeThumbnails {
    
    let cache = NSCache<NSString, UIImage>()
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    /**
     Genera el thumbnail de una imagen dada por el usuario y la guarda en disco y caché.
     
     - Parameter imagen: Imagen a redimensionar.
     - Parameter llave: Identificador del thumbnail.
     */
    func setThumbnail(_ imagen: UIImage, para llave: String) {
        // Crear thumbnail
        let thumbnail = self.resize(imagenOrigen: imagen, para: CGSize(width: 45, height: 45))
        
        // Agregar en caché
        self.cache.setObject(thumbnail, forKey: "\(llave).thumb" as NSString)
        
        // Agregar en disco
        let url = urlDeThumbnailEnDisco(para: llave)
        if let data = thumbnail.jpegData(compressionQuality: 0.5) {
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    /**
     Escala el tamaño de la imagen para crear el thumbnail.
     
     - Parameter imagenOrigen: Imagen a modificar.
     - Parameter para: Tamaño destino.
     - Returns: Thumbnail.
     */
    func resize(imagenOrigen: UIImage, para tamaño: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: tamaño)
        
        return renderer.image { (context) in
            imagenOrigen.draw(in: CGRect(origin: .zero, size: tamaño))
        }
    }
    
    
    /**
     Borra un thumbnail del disco y caché.
     
     - Parameter llave: Identificador de thumbnail.
     */
    func borraThumbnail(para llave: String) {
        // Borrar del caché
        self.cache.removeObject(forKey: "\(llave).thumb" as NSString)
        
        // Borrar del disco
        try? FileManager.default.removeItem(at: urlDeThumbnailEnDisco(para: llave))
    }
    
    /**
     Devuelve un thumbnail del caché o disco.
     
     - Parameter llave: Identificador de la imagen.
     */
    func getThumbnail(para llave: String) -> UIImage? {
        // Buscar en caché
        if let thumbnailExistente = self.cache.object(forKey: "\(llave).thumb" as NSString) {
            return thumbnailExistente
        }
        
        // Buscar en disco
        let url = urlDeThumbnailEnDisco(para: llave)
        guard let thumbnailEnDisco = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        // Guardar en caché para rápido acceso
        self.cache.setObject(thumbnailEnDisco, forKey: "\(llave).thumb" as NSString)
        return thumbnailEnDisco
    }
    
    /**
     Devuelve la URL de un thumbnail en el sistema de archivos del disco.
     
     - Parameter llave: Identificador del thumbnail.
     */
    func urlDeThumbnailEnDisco(para llave: String) -> URL {
        return self.documentDirectory.appendingPathComponent("\(llave).thumb")
    }
    
}
