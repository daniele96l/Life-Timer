//
//  AppDelegate.swift
//  DeadTimer
//
//  Created by daniele ligato on 25/02/2020.
//  Copyright © 2020 daniele ligato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate { //MAIN 
    

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
   
    var perc: String = "Set the values"
    
    func setPerc(s: String){ //questa viene chiamata del ViewController
        perc = s
        
        if(perc == "0.0"){
            perc = "Set the values"
            refreshapplication()
        } else{
            perc = perc + "%"
            refreshapplication()
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {// Insert code here to initialize your application
            statusItem.button?.title = "Set the values"
            statusItem.button?.target = self
            statusItem.button?.action = #selector(showSetting)
            let storyboard = NSStoryboard(name: "Main", bundle: nil) //QUI VADO A FARE IN MODO DI POTER CHIAMARE IL MIO VIEW CONTROLLER
            let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController
            vc?.automaticRefresh()
         }
    
    func refreshapplication(){
            statusItem.button?.title = perc 
            statusItem.button?.target = self
            statusItem.button?.action = #selector(showSetting)
    }

        @objc public func showSetting() {
            let storyboard = NSStoryboard(name: "Main", bundle: nil) //QUI VADO A FARE IN MODO DI POTER CHIAMARE IL MIO VIEW CONTROLLER
            let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController
            vc?.automaticRefresh()
            
            let popoverView = NSPopover()
            popoverView.contentViewController = vc
            popoverView.behavior = .transient
            popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
            
    }
    
    

}




