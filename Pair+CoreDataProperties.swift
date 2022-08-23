//
//  Pair+CoreDataProperties.swift
//  currency_converter
//
//  Created by Leonid on 22.08.2022.
//
//

import Foundation
import CoreData


extension Pair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pair> {
        return NSFetchRequest<Pair>(entityName: "Pair")
    }

    @NSManaged public var code: String?
    @NSManaged public var rate: Double

}

extension Pair : Identifiable {

}
