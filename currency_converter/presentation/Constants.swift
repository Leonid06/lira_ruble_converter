//
//  Constants.swift
//  currency_converter
//
//  Created by Leonid on 14.08.2022.
//

import Foundation
import CoreData 


struct Constants {
    static let RUB = "RUB"
    static let TL = "TRY"
    static let RUBTL = Code(from: RUB, to: TL)
    static let TLRUB = Code(from: TL, to: RUB)
    
    static let refreshTaskIdentifier = "com.iskandarov.leonid.currency-converter.task.refresh"
    
    struct Keys {
        static let pairs = "pairs"
        static let datetime = "datetime"
        
        struct Notifications{
            static let notificationKey = Notification.Name(rawValue: "notificationKey")
        }
    }
}


