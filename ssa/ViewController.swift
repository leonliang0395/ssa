//
//  ViewController.swift
//  ssa
//
//  Created by Alexander Prokic on 10/9/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UgiInventoryDelegate {

    //MARK:Properties
    @IBOutlet weak var displayTagLabel: UILabel!
    //var tagToDetailString: [UgiTag : NSMutableString] = [:]
    
    func updateUI(){
        let inventory: UgiInventory? = Ugi.singleton().activeInventory
        if (inventory?.tags.count != 0) {
            //let firstTag = Ugi.singleton().activeInventory.tags[0].epc.toString()
            displayTagLabel.text = "Found \(inventory!.tags.count) Tag(s) Nearby"
        }
        else {
            displayTagLabel.text = "No Tags Nearby"
        }
    }
    
    var buttonIsPressed = false
    
    @IBAction func readButton(_ sender: UIButton) {
        if buttonIsPressed {
            Ugi.singleton().activeInventory.stop {
                //self.updateUI()
                self.displayTagLabel.text = "STOP"
            }
            buttonIsPressed = false
            
        } else{
            Ugi.singleton().startInventory(
                self,
                with: UgiRfidConfiguration.config(withInventoryType: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE))
            self.updateUI()
            
            buttonIsPressed = true
        }
    }
    
    
    //MARK:Actions
    @IBAction func readStartButton(_ sender: UIButton) {
        Ugi.singleton().startInventory(
            self,
            with: UgiRfidConfiguration.config(withInventoryType: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE))
        self.updateUI()
    }
    
    @IBAction func readStopButton(_ sender: UIButton) {
        Ugi.singleton().activeInventory.stop {
            //self.updateUI()
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

