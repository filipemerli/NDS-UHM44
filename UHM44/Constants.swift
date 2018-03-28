//
//  Constants.swift
//  UHM44
//
//  Created by Filipe Merli on 27/03/18.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation

class Constants {
    var ipAdress: String = "192.168.5.83"
    
    
    class var shared: Constants {
        struct Static {
            static let instance: Constants = Constants()
        }
        return Static.instance
    }
    
    
}
