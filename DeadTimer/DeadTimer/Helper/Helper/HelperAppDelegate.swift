//
//  AppDelegate.swift
//  Helper
//
//  Created by daniele ligato on 27/02/2020.
//  Copyright © 2020 daniele ligato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class HelperAppDelegate: NSObject, NSApplicationDelegate {

    
  func applicationDidFinishLaunching(_ aNotification: Notification) {
       let runningApps = NSWorkspace.shared.runningApplications
       let isRunning = runningApps.contains {
           $0.bundleIdentifier == "c.DeadTimer"
       }

       if !isRunning {
           var path = Bundle.main.bundlePath as NSString
           for _ in 1...4 {
               path = path.deletingLastPathComponent as NSString
           }
           NSWorkspace.shared.launchApplication(path as String)
       }
   }
    
  
    
    


}

