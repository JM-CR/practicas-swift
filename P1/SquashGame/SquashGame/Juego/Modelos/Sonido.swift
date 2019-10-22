//
//  Sonido.swift
//  SquashGame
//
//  Created by Josue Mosiah Contreras Rocha on 10/10/19.
//  Copyright © 2019 Josue Mosiah Contreras Rocha. All rights reserved.
//

import AVFoundation

class Sonido {
    
    var audioPlayer = AVAudioPlayer()
    
    /**
     Reproduce un archivo de audio tipo wav.
     
     - Parameter archivoSinExtension: Nombre del archivo de audio sin extensión.
     */
    func reproduce(archivoSinExtension: String){
        let sonido = Bundle.main.path(forResource: archivoSinExtension, ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sonido!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch {
            print(error)
        }
    }
      
}
