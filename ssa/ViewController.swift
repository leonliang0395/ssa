//
//  ViewController.swift
//  ssa
//
//  Created by Alexander Prokic on 10/9/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UgiInventoryDelegate {

    //Variables
    @IBOutlet weak var displayTagLabel: UILabel!
    let db = SQLiteDB.sharedInstance
    var buttonIsPressed = false
    
    // Update UI when a tag is found
    func inventoryTagFound(_ tag: UgiTag!,
                           withDetailedPerReadData detailedPerReadData: [UgiDetailedPerReadData]?) {
        //let inventory: UgiInventory? = Ugi.singleton().activeInventory
        //let rfid = inventory!.tags.first!.epc.toString()
        let rfid = tag.epc.toString()
        let data = db.query(sql: "SELECT description FROM tags WHERE rfid=?", parameters:[rfid])
        if (!data.isEmpty){
            let row = data[0]
            if let description = row["description"]{
                displayTagLabel.text = description as? String
            }
        }
    }
    
    //Control for Large Read Button
    @IBAction func readButton(_ sender: UIButton) {
        if buttonIsPressed {
            Ugi.singleton().activeInventory.stop {
                self.displayTagLabel.text = "STOP"
            }
            sender.setTitle("STOPPED", for: .normal)
            buttonIsPressed = false
            
        } else{
            Ugi.singleton().startInventory(
                self,
                with: UgiRfidConfiguration.config(withInventoryType: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE))
            sender.setTitle("SCANNING", for: .normal)
            buttonIsPressed = true
        }
    }
    
    
    // Control for Start Button
    @IBAction func readStartButton(_ sender: UIButton) {
        Ugi.singleton().startInventory(
            self,
            with: UgiRfidConfiguration.config(withInventoryType: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE))
        let inventory: UgiInventory? = Ugi.singleton().activeInventory
        if (inventory?.tags.count != 0){
        }
    }
    
    // Control for Stop Button
    @IBAction func readStopButton(_ sender: UIButton) {
        if (Ugi.singleton().activeInventory != nil && Ugi.singleton().activeInventory.isScanning){
            Ugi.singleton().activeInventory.stop {
                self.displayTagLabel.text = "Stopped"
            }
        }
    }
    
    
    /**/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

