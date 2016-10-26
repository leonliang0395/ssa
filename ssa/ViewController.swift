//
//  ViewController.swift
//  ssa
//
//  Created by Alexander Prokic on 10/9/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UgiInventoryDelegate {

    // Variables
    @IBOutlet weak var displayTagLabel: UILabel!
    let db = SQLiteDB.sharedInstance
    var scanPaused = false
    var scanStopped = true
    
    // Queue of descriptions to be read aloud
    let descriptionQueue = Queue<String>();
    // Dictionary of RFID tags to the time it was read aloud.
    var finishedDescriptions: [String:NSDate] = [:];
    // Text to speech reader
    let speechSynthesizer = AVSpeechSynthesizer()
    
    // Update UI when a tag is found
    func inventoryTagFound(_ tag: UgiTag!,
                           withDetailedPerReadData detailedPerReadData: [UgiDetailedPerReadData]?) {
        //let rfid = inventory!.tags.first!.epc.toString()
        let rfid = tag.epc.toString()
        
        // declare index ranges for hex RFID string
        let endTypeRange = rfid!.index(rfid!.startIndex, offsetBy: 2)
        let endLocRange = rfid!.index(rfid!.startIndex, offsetBy: 11)
        let endDescRange = rfid!.index(rfid!.startIndex, offsetBy: 19)
        let locRange = endTypeRange..<endLocRange
        let descRange = endLocRange..<endDescRange
        
        // get necessary rfid subcomponents
        let lid = rfid!.substring(with: locRange)
        let did = rfid!.substring(with: descRange)
        
        // query database for description
        let data = db.query(sql: "SELECT description FROM descriptions WHERE lid=? AND did=?", parameters:[lid, did])
        
        // RFID Tag found in DB.
        if (!data.isEmpty){
            // Since we queried one tag at a time, the returned dictionary only has one entry.
            let row = data[0]
            if let description = row["description"]{
                // Change the label, and push it onto queue of descriptions.
                displayTagLabel.text = description as? String
                descriptionQueue.enqueue(value: description as! String);
            }
        }
    }
    
    // Take special actions on subsequent find
    func inventoryTagSubsequentFinds(_ tag: UgiTag!, numFinds num: Int32, withDetailedPerReadData detailedPerReadData: [UgiDetailedPerReadData]!) {
        
    }
    
    // Control for Stop Button
    @IBAction func STOP(_ sender: UIButton) {
        let inventory: UgiInventory? = Ugi.singleton().activeInventory
        if (inventory != nil){
            inventory!.stop {
                self.displayTagLabel.text = "Stopped"
                self.scanStopped = true
                self.scanPaused = false
                let scanButton = self.view.viewWithTag(1) as! UIButton
                scanButton.setTitle("SCAN", for: .normal)
            }
        }
        // TODO: Just testing out speech to text in the stop button for now.
        // Text to Speech works fine (after testing it with a hard coded string)
        // but it does not play with the RFID reader plugged in.
        //
        // This block of text is basically the functionality of dequeueing
        // from the description queue and reading it outloud.
        let nextDescription = descriptionQueue.dequeue()
        let descriptionUtter = AVSpeechUtterance(string: nextDescription!)
        speechSynthesizer.speak(descriptionUtter)
    }

    // Control for Read Button
    @IBAction func readButton(_ sender: UIButton) {
        let inventory: UgiInventory? = Ugi.singleton().activeInventory
        if scanStopped {
            Ugi.singleton().startInventory(
                self,
                with: UgiRfidConfiguration.config(withInventoryType: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE))
            sender.setTitle("SCANNING", for: .normal)
            self.scanStopped = false
        }
        else if scanPaused {
            inventory!.resumeInventory()
            sender.setTitle("SCANNING", for: .normal)
            self.scanPaused = false
        }
        else {
            inventory!.pause()
            sender.setTitle("PAUSED", for: .normal)
            self.scanPaused = true
        }
    }
    
    /**/
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

