//
//  Inventario.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/9/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import Foundation

class Inventario {
    
    var todasLasCosas = [Cosa]()
    let rutaDelInventarioEnElDisco: URL = {
       return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("cosas.archivo")
    }()
    
    /**
     Inicializa el inventario desde el que está guardado en disco.
     */
    init() {
        do {
            // Obtener datos del disco
            let data = try Data(contentsOf: self.rutaDelInventarioEnElDisco)
        
            // Restaurar
            do {
                let cosasGuardadas = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
                self.todasLasCosas = cosasGuardadas as! [Cosa]
            } catch {
                print("Error al des-serializar el inventario \(error.localizedDescription)")
            }
        } catch {
            print("Error al leer del disco")
        }

//        for _ in 0..<5 {
//            creaCosa()
//        }
    }
    
    @discardableResult func creaCosa() -> Cosa {
        let nuevaCosa = Cosa()
        self.todasLasCosas.append(nuevaCosa)
        return nuevaCosa
    }
    
    /**
     Elimina un elemento del arreglo de cosas.
     
     - Parameter cosaAEliminar: Elemento a borrar.
     */
    func eliminaCosa(cosaAEliminar: Cosa) {
        if let indiceDeCosa = self.todasLasCosas.firstIndex(of: cosaAEliminar) {
            todasLasCosas.remove(at: indiceDeCosa)
        }
    }
    
    /**
     Mueve un elemento de un index hacia otro.
     
     - Parameter de: Primer elemento.
     - Parameter hacia: Segundo elemento.
     */
    func reordena(de: Int, hacia: Int) {
        guard de != hacia else {
            return
        }
        let cosaAMover = todasLasCosas[de]
        todasLasCosas.remove(at: de)
        todasLasCosas.insert(cosaAMover, at: hacia)
    }
    
    /**
     Guarda el inventario de Cosas en disco.
     
     - Returns: True si la operación se pudo realizar exitosamente.
     */
    func guardaEnDisco() -> Bool {
        print("El inventario se guardará en \(self.rutaDelInventarioEnElDisco.path)")
        do {
            // Serializar
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.todasLasCosas, requiringSecureCoding: false)
            
            // Guardar en disco
            do {
               try data.write(to: self.rutaDelInventarioEnElDisco, options: [.atomic])
                return true
            } catch {
                print("Error al guardar a disco \(error.localizedDescription)")
            }
        } catch {
            print("Error al serializar el inventario: \(error.localizedDescription)")
        }
        
        return false
    }
}
