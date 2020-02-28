//
//  ViewController.swift
//  DeadTimer
//
//  Created by daniele ligato on 25/02/2020.
//  Copyright © 2020 daniele ligato. All rights reserved.
//

import Cocoa
import SwiftUI
import Foundation
import AppKit
import ServiceManagement

class ViewController: NSViewController, NSTextFieldDelegate{ //GESTISCE LA GRAFICA
    @IBOutlet weak var input: NSTextFieldCell!
    @IBOutlet weak var input2: NSTextField!
    @IBOutlet weak var output: NSTextField!
    @IBOutlet weak var LoginItemButton: NSButton!
   
    var birthdate = 0.0
    var deathyear = 0.0 //valori di default
    var timer = Timer()
    var counter = 0
    let helperBundleName = "c.Helper"
    var allMyStoredData = UserDefaults.standard  ///-----------PERSISTENT DATA-------------
    var checkButtonState = UserDefaults.standard
    
    @IBAction func LoginItemPressed(_ sender: NSButton) {
    
        checkButtonState.set(sender.state, forKey: "buttonState") /// --------------ASSEGNO IL VALORE PERSISTENTE ------------------
        SMLoginItemSetEnabled(helperBundleName as CFString, checkButtonState.bool(forKey: "buttonState"))
       // print(checkButtonState.bool(forKey: "buttonState"))
 
       
        switch sender.state {
        case .on:
            print("on")
        case .off:
            print("off")
        default: break
        }
    }

    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
        }
        LoginItemButton.state = foundHelper ? .on : .off
    }
    
    
    func appDel(s: String){ /// ------------------------------------CONNESSIONE CON APP DELEGATE------------------------
        let ap = NSApplication.shared.delegate as! AppDelegate
        ap.setPerc(s: s) //qui passo il valore che voglio inserire all'APPDELEGATE
        }
    
    
    @IBAction func copyToPasteboard(_ sender: Any) { ///-------------------CLICK BOTTONE-----------------------------------
        birthdate = Double(getBirthDate())
        deathyear = Double(getDeathDate())
        print(getBirthDate(), getDeathDate())
        let perc = calculate(birdthdate: birthdate, deathdate: deathyear)
        let roundPerc = round(perc: perc)
        if(roundPerc != 0.0 ){
            print(roundPerc)
            automaticRefresh() ///------------------------------- FACCIO PARTIRE IL REFRESH AUTOMATICO -----------------------
            allMyStoredData.set(roundPerc, forKey: "TheScore")
        }else{}
    }
    
    func automaticRefresh(){
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(){
        //print("Aggiorno")
        print((String((UserDefaults.standard.string(forKey: "TheScore")) ?? "nice" )) + " Persistent value")
        appDel(s: (String((UserDefaults.standard.string(forKey: "TheScore")) ?? "nice" )))

        
      }
    
    func gotYear(d : Double) { //questo metodo dovrebbe prendere il valore che gli passa il bottone e metterlo nella variabile
        birthdate = d
        }
            
    func getYear() -> Double{
        let date = Date()
        let calendar = Calendar.current
        let thisYear = Double(calendar.component(.year, from: date))
        let thisMonth = calendar.component(.month, from: date)
        let thisDay = calendar.component(.day, from: date)
        let normalizedMonth = Double(thisMonth) * (1/12)
        let normalizedDay = Double(thisDay) * (1/365)
        let yearType = Double(thisYear + normalizedMonth + normalizedDay)
        return (yearType)
        }
    
            
    func calculate(birdthdate: Double, deathdate: Double) -> Double{
        let totalLife = deathyear - birthdate
        let myAge = getYear() - birthdate
        if( (birthdate==0) || (deathyear == 0)){
            return 0.0
        }
        return (myAge/(totalLife))*100
        }
          
    func round(perc : Double)-> Double{
        let not = perc
        let rounded = Double(Darwin.round(not*1000)/1000)
        return rounded
        }
    
    @IBAction func ExitButton(_ sender: Any) {
           exit(0);
      }
      
    
    func getBirthDate()-> Double{ ///BIRTHDAY
        if(Int(input.stringValue) != nil){
        }else{
            output.stringValue = "Write only numbers"
            return 0.0
        }
        if(((Int(input.stringValue))! > 1900) && (Int(input.stringValue)! < Int(getYear())) ){
            print(input.stringValue, getYear())
            output.stringValue = String("Birthdate:" + input.stringValue + "- You will live:" + input2.stringValue)
            return Double(input.stringValue)!
            
        }
        else{
            output.stringValue = "Birthdate must be between 1900 and today"
            return 0.0
        }
        
    }
    
    func getDeathDate()->Double{ ///DEADDATE
        if(Int(input2.stringValue) != nil){
        }else{
            output.stringValue = "Write only numbers"
            return 0.0
        }
        if((Int(input2.stringValue))! < (Int(getYear()) - Int(getBirthDate())) && (Int(input.stringValue)! < Int(getYear())) && (Int(input2.stringValue)! < 120) && (Int(input.stringValue)! > 1900)){
            //Anni di vita < Data odierna - data di nascita, controllando che la data di nascita sia coerente
            output.stringValue = "You are still alive, I hope"
            return 0.0
        }
        if((Int(input2.stringValue))! > 120 && (Int(input.stringValue)! > 1900)){
            output.stringValue = "Dont be so optimistic"
            return 0.0
        }
        else{
            output.stringValue = String("Birthdate:" + input.stringValue + "- You will live:" + input2.stringValue)
            return (Double(input2.stringValue)!+Double(getBirthDate()))
        }
    }
    
    
    
  
    
}
