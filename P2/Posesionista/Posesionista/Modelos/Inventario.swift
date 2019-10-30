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
    
    var todasLasCosas = [Cosa]()
    let rutaDelInventarioEnElDisco: URL = {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("cosas.archivo")
    }()
    
    /**
     Crea el inventario con las cosas guardadas en el disco.
     */
    init() {
        do {
            // Obtener datos del disco
            let data = try Data(contentsOf: self.rutaDelInventarioEnElDisco)
        
            // Restaurar
            let cosasGuardadas = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            self.todasLasCosas = cosasGuardadas as! [Cosa]
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    /**
     Crea una nueva cosa y la agrega al inventario.
     */
    @discardableResult func creaCosa() -> Cosa {
        let nuevaCosa = Cosa()
        self.todasLasCosas.append(nuevaCosa)
        return nuevaCosa
    }
    
    /**
     Elimina una cosa del inventario.
     
     - Parameter cosaAEliminar: Cosa a borrar.
     */
    func eliminaCosa(cosaAEliminar: Cosa) {
        if let indiceDeCosa = self.todasLasCosas.firstIndex(of: cosaAEliminar) {
            todasLasCosas.remove(at: indiceDeCosa)
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
        let cosaAMover = todasLasCosas[de]
        todasLasCosas.remove(at: de)
        todasLasCosas.insert(cosaAMover, at: hacia)
    }
    
    /**
     Guarda el inventario en el sistema de archivos del disco.
     
     - Returns: True si la operación se pudo realizar exitosamente.
     */
    func guardaEnDisco() -> Bool {
        var operacionExitosa = false
        
        do {
            // Serializar
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.todasLasCosas, requiringSecureCoding: false)
            
            // Guardar en disco
            try data.write(to: self.rutaDelInventarioEnElDisco, options: [.atomic])
            operacionExitosa.toggle()
        } catch {
            print("\(error.localizedDescription)")
        }
        
        return operacionExitosa
    }
}
