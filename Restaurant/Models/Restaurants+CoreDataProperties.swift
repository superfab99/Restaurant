//
//  Restaurants+CoreDataProperties.swift
//  Restaurant
//
//  Created by rps on 17/06/22.
//
//

import Foundation
import CoreData


extension Restaurants {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurants> {
        return NSFetchRequest<Restaurants>(entityName: "Restaurants")
    }

    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var price: String
    @NSManaged public var isbooked: Bool
    @NSManaged public var isfavourite: Bool
    @NSManaged public var address: String
    @NSManaged public var date: Date?

}

extension Restaurants : Identifiable {

}
