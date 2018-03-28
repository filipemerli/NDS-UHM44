//
//  ViewController.swift
//  UHM44
//
//  Created by Filipe Merli on 26/03/18.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StreamsClientDelegate {
    
    let streamsClient = StreamsClient()
    
    @IBOutlet var out01Buttons: [UIButton]!
    @IBOutlet var out02Buttons: [UIButton]!
    @IBOutlet var out03Buttons: [UIButton]!
    @IBOutlet var out04Buttons: [UIButton]!
    
    
    
    var outPut01: Character? = "o"
    var outPut02: Character? = "o"
    var outPut03: Character? = "o"
    var outPut04: Character? = "o"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        streamsClient.setupNetworkCommunication()
        streamsClient.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        streamsClient.sendMessage(message: "STA\r\n")
    }
    
    @IBAction func out01CollectionPress(_ sender: UIButton) {
        let tag = sender.tag
        print("Tag = \(tag)")
        if sender.titleLabel?.text != "\u{2714}" {
            if tag == 5 {
                streamsClient.sendMessage(message: "SWT: A0\r\n")
            }else {
                streamsClient.sendMessage(message: "SWT: A\(tag)\r\n")
            }
        }
    }
    
    @IBAction func out02CollectionPress(_ sender: UIButton) {
        let tag = sender.tag
        print("Tag = \(tag)")
        if sender.titleLabel?.text != "\u{2714}" {
            if tag == 5 {
                streamsClient.sendMessage(message: "SWT: B0\r\n")
            }else {
                streamsClient.sendMessage(message: "SWT: B\(tag)\r\n")
            }
        }
    }
    
    @IBAction func out03CollectionPress(_ sender: UIButton) {
        let tag = sender.tag
        print("Tag = \(tag)")
        if sender.titleLabel?.text != "\u{2714}" {
            if tag == 5 {
                streamsClient.sendMessage(message: "SWT: C0\r\n")
            }else {
                streamsClient.sendMessage(message: "SWT: C\(tag)\r\n")
            }
        }
    }
    
    @IBAction func out04CollectionPress(_ sender: UIButton) {
        let tag = sender.tag
        print("Tag = \(tag)")
        if sender.titleLabel?.text != "\u{2714}" {
            if tag == 5 {
                streamsClient.sendMessage(message: "SWT: D0\r\n")
            }else {
                streamsClient.sendMessage(message: "SWT: D\(tag)\r\n")
            }
        }
    }

    
    func receivedMessage(message: String) {
        //GDC
        
        //DispatchQueue.main.async {
            if message.contains("SW") {
                let indexInicial = message.index(of: "S")
                outPut01 = message[message.index(indexInicial!, offsetBy: 6)]
                outPut02 = message[message.index(indexInicial!, offsetBy: 9)]
                outPut03 = message[message.index(indexInicial!, offsetBy: 12)]
                outPut04 = message[message.index(indexInicial!, offsetBy: 15)] // isso pode dar ruim!!!!
                DispatchQueue.main.async {
                    self.resetButtons()
                    self.updateFeedbackTable()
                }
                
                }
        //}
    }
    
    func updateFeedbackTable() {
        guard let out01Int = Int(String(outPut01!)) else{
            return
        }
        guard let out02Int = Int(String(outPut02!)) else{
            return
        }
        guard let out03Int = Int(String(outPut03!)) else{
            return
        }
        guard let out04Int = Int(String(outPut04!)) else{
            return
        }
        var arrayDeFeedback = [out01Int, out02Int, out03Int, out04Int]
        var count = 0
        for numero in arrayDeFeedback {
            if numero == 0 {
                arrayDeFeedback.remove(at: count)
                arrayDeFeedback.insert(4, at: count)
            }else{
                arrayDeFeedback.remove(at: count)
                arrayDeFeedback.insert((numero-1), at: count)
            }
            count += 1
        }
        out01Buttons[arrayDeFeedback[0]].setTitle("\u{2714}", for: .normal)
        out02Buttons[arrayDeFeedback[1]].setTitle("\u{2714}", for: .normal)
        out03Buttons[arrayDeFeedback[2]].setTitle("\u{2714}", for: .normal)
        out04Buttons[arrayDeFeedback[3]].setTitle("\u{2714}", for: .normal)
    }
    
    func resetButtons() {
        for button in out01Buttons {
            button.setTitle("o", for: .normal)
        }
        for button in out02Buttons {
            button.setTitle("o", for: .normal)
        }
        for button in out03Buttons {
            button.setTitle("o", for: .normal)
        }
        for button in out04Buttons {
            button.setTitle("o", for: .normal)
        }
    }
    
}


