//
//  Doctor+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 19.07.2022.
//
//

import Foundation
import CoreData


extension Doctor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Doctor> {
        return NSFetchRequest<Doctor>(entityName: "Doctor")
    }

    @NSManaged public var clinic: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profession: String?
    @NSManaged public var date: Date?
    @NSManaged public var dateCreate: Date?

}

extension Doctor : Identifiable {
    var professionEnum:Profession {
        get{
            return Profession(rawValue: self.profession!)!
        }
        set{
            self.profession = newValue.rawValue
        }
    }
}
