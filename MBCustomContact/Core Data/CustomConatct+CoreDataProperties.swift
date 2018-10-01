//
//  CustomConatct+CoreDataProperties.swift
//  
//
//  Created by Mac on 9/27/18.
//
//

import Foundation
import CoreData


extension CustomConatct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomConatct> {
        return NSFetchRequest<CustomConatct>(entityName: "CustomConatct")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var jID: String?
    @NSManaged public var contentID: String?
    @NSManaged public var mobileNo: String?
    @NSManaged public var email: String?
    @NSManaged public var countryID: String?

}
