//
//  ViewController.swift
//  FinalProject
//
//  Created by Justice Bayle on 2019-06-03.
//  Copyright © 2019 Justice Bayle. All rights reserved.
//

import UIKit
import Phidget22Swift

class ViewController: UIViewController {
    
    @IBOutlet weak var dudesBeLike: UILabel!
    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    //port 0 = red led
    //port 1 = green led
    //port 2 = red button
    //port 3 = green button
    let button0 = DigitalInput()
    let button1 = DigitalInput()
    let ledArray = [DigitalOutput(), DigitalOutput()]
    var timerColour = "none"
    var points : Int = 0
    var points2 : Int = 0
    
    func attach_handler(sender: Phidget){
        do{
            
            let hubPort = try sender.getHubPort()
            
            if(hubPort == 0){
                print("LED 0 Attached")
            }
            else if (hubPort == 1){
                print("LED 1 Attached")
            }
            else{
                print("Button Attached")
            }
            
            
        } catch let err as PhidgetError {
            
            print("Phidget Error" + err.description)
            
        } catch {
            //catch other errors here
        }
        
    }
    
    func state_change(sender: DigitalInput, state:Bool){
        do{
            
            if(state == true && timerColour == "none"){
                print("Button Pressed")
              
                updatePointsP1()
                try ledArray[0].setState(true)
            } else if (timerColour == "black") {
                
                timerColour = "Fred"
                
            } else if (state == true && timerColour == "black"){
                restart()
                timerColour = "none"
            }
                
            else{
                print("Button Not Pressed")
                
                try ledArray[0].setState(false)
                
                
            }
            
        } catch let err as PhidgetError {
            print("PhidgetError" + err.description)
        } catch {
            //other errors here
        }
        
    }
    func red_change(sender: DigitalInput, state:Bool){
        do{
            
            if(state == true && timerColour == "none"){
                print("Button Pressed")
                try ledArray[1].setState(true)
                 updatePointsP2()
                
            } else if (state == true && timerColour == "black"){
                restart()
                timerColour = "none"
                
            }
                
            else{
                print("Button Not Pressed")
                try ledArray[1].setState(false)
                
                
                
            }
            
        } catch let err as PhidgetError {
            print("PhidgetError" + err.description)
        } catch {
            //other errors here
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try Net.enableServerDiscovery(serverType: .deviceRemote)
            //address digital input
            try button0.setDeviceSerialNumber(528033)
            try button0.setHubPort(2)
            try button0.setIsHubPortDevice(true)
            
            try button1.setDeviceSerialNumber(528033)
            try button1.setHubPort(3)
            try button1.setIsHubPortDevice(true)
            
            let _ = button0.stateChange.addHandler(state_change)
            let _ = button1.stateChange.addHandler(red_change)
            
            let _ = button0.attach.addHandler(attach_handler)
            let _ = button1.attach.addHandler(attach_handler)
            
            try button0.open()
            try button1.open()
            
            //address, add handler, open digital outputs
            for i in 0..<ledArray.count{
                try ledArray[i].setDeviceSerialNumber(528033)
                try ledArray[i].setHubPort(i)
                try ledArray[i].setIsHubPortDevice(true)
                let _ = ledArray[i].attach.addHandler(attach_handler)
                try ledArray[i].open()
            }
            
            
        } catch let err as PhidgetError {
            print("Phidget Error" + err.description)
        } catch{
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    func updatePointsP1(){
        if timerColour == "none"{
        points += 1
        uiUpdateP1()
        delayedTimer()
            
        } else {
            //do nothing
        }
    }
    
    func updatePointsP2(){
        if timerColour == "none"{
            points2 += 1
            uiUpdateP2()
            delayedTimer()
        } else {
            //do nothing
        }
    }
    
    
     //After 10 seconds, it shut down
    func delayedTimer() {
        if (timerColour == "none") {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {

            self.winnerDinner()
        })
        }
    }
    func uiUpdateP1() {
        DispatchQueue.main.async {
        self.textLabel.text = "\(self.points)"
        }
    }
    func uiUpdateP2() {
        DispatchQueue.main.async {
            self.textLabel2.text = "\(self.points2)"
        }
    }
    
    func winnerDinner(){
        if !(points < points2){
        DispatchQueue.main.async {
            self.dudesBeLike.text = "Player 2 wins! Press the button to start again"
        }
            timerColour = "black"
        
        
        } else if !(points > points2) {
            DispatchQueue.main.async {
                 self.dudesBeLike.text = "Player 1 wins! Press the button to start again"
            }
            timerColour = "black"
        } else if !(points2 == points){
            DispatchQueue.main.async {
                self.dudesBeLike.text = "Tied. Press a button to try again"
            }
            
        } else {
            print("Error")
        }
        
        
    }
    func restart(){
        DispatchQueue.main.async {
            self.timerColour = "none"
            self.dudesBeLike.text = "Go again"
        }
        points = 0
        points2 = 0
    }
}



