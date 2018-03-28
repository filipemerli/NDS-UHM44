//
//  ConnectViewController.swift
//  UHM44
//
//  Created by Filipe Merli on 27/03/18.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit
import Foundation

class ConnectViewController: UIViewController, StreamsClientDelegate {
    
    let streamsClient = StreamsClient()
    var constante = Constants.shared

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        streamsClient.delegate = self
    }
    
    @IBOutlet weak var ipTextField: UITextField!
    
    @IBAction func goPress(_ sender: UIButton) {
        let ipAddress = ipTextField.text
        if ipAddress != "" {
            constante.ipAdress = ipAddress!
            streamsClient.setupNetworkCommunication()
        }
    }
    
    func receivedMessage(message: String) {
        if message.contains("Conectou") {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Switching")
            self.present(vc!, animated: true, completion: nil)
        } else {
            print("ERROR")
        }
    }


}

//Levantar a tela para o teclado quando ele aparecer
