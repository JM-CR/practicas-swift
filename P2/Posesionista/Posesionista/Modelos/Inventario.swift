//
//  Inventario.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/9/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import Foundation

/**
 Representa un inventario de cosas.
 */
class Inventario {
    
    var cosas = [Cosa]()
    var nombreDeSeccion: String!
    
    /**
     Crea el inventario con las cosas guardadas en el disco.
     
     - Parameter seccion: Nombre de la sección a recuperar.
     */
    init(seccion: String) {
        do {
            // Obtener datos del disco
            self.nombreDeSeccion = seccion
            let path = self.rutaDelInventarioEnElDisco(seccion: self.nombreDeSeccion)
            let data = try Data(contentsOf: path)
        
            // Restaurar
            let cosasGuardadas = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            self.cosas = cosasGuardadas as! [Cosa]
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    /**
     Obtiene el path de la sección en el sistema de archivos del disco.
     
     - Parameter seccion: Nombre de la sección a recuperar.
     - Returns: URL de la ubicación.
     */
    func rutaDelInventarioEnElDisco(seccion: String) -> URL {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("cosas.\(seccion)")
    }
    
    /**
     Crea una nueva cosa y la agrega al inventario.
     */
    @discardableResult func creaCosa() -> Cosa {
        let nuevaCosa = Cosa()
        self.cosas.append(nuevaCosa)
        return nuevaCosa
    }
    
    /**
     Elimina una cosa del inventario.
     
     - Parameter cosaAEliminar: Cosa a borrar.
     */
    func eliminaCosa(cosaAEliminar: Cosa) {
        if let indiceDeCosa = self.cosas.firstIndex(of: cosaAEliminar) {
            cosas.remove(at: indiceDeCosa)
        }
    }
    
    /**
     Acomoda una cosa dentro del inventario.
     
     - Parameter de: Posición inicial.
     - Parameter hacia: Nueva posición.
     */
    func reordena(de: Int, hacia: Int) {
        // Verificar que no se mueva al mismo lugar.
        guard de != hacia else {
            return
        }
        
        // Realizar operación
        let cosaAMover = cosas[de]
        cosas.remove(at: de)
        cosas.insert(cosaAMover, at: hacia)
    }
    
    /**
     Guarda el inventario en el sistema de archivos del disco.
     
     - Returns: True si la operación se pudo realizar exitosamente.
     */
    @discardableResult func guardaEnDisco() -> Bool {
        var operacionExitosa = false
        
        do {
            // Serializar
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.cosas, requiringSecureCoding: false)
            
            // Guardar en disco
            let path = self.rutaDelInventarioEnElDisco(seccion: self.nombreDeSeccion)
            try data.write(to: path, options: [.atomic])
            operacionExitosa.toggle()
        } catch {
            print("\(error.localizedDescription)")
        }
        
        return operacionExitosa
    }
    
    /**
     Calcula el precio total acumulado.
     */
    func precioAcumulado() -> String {
        var precioTotal = 0
        self.cosas.forEach { precioTotal += $0.valorEnPesos  }
        return "$\(precioTotal)"
    }
    
}
