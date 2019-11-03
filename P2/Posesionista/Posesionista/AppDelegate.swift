//
//  AppDelegate.swift
//  Posesionista
//
//  Created by Contreras Rocha Josue Mosiah on 10/9/19.
//  Copyright © 2019 Contreras Rocha Josue Mosiah. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var inventarios = [Inventario]()
    
    /**
     Realiza una acción cuando la aplicación termina de instanciarse.
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Buscar CosasTableViewController
        let navController = self.window!.rootViewController as! UINavigationController
        let cosasTVC = navController.topViewController as! CosasTableViewController
        
        // Cargar inventarios del disco
        let secciones = ["0", "100", "200", "300", "400", "500", "600", "700", "800", "900", "1000"]
        for nombre in secciones {
            let inventarioPorSeccion = Inventario(seccion: nombre)
            self.inventarios.append(inventarioPorSeccion)
        }
        
        // Pasar inventarios a CosasTVC
        cosasTVC.inventarios = self.inventarios
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    /**
     Realiza una acción cuando la aplicación entra en background.
     */
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Guardar inventarios en disco
        for seccion in self.inventarios {
            seccion.guardaEnDisco()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

