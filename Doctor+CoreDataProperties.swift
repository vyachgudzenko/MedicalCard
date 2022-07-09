//
//  Doctor+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 28.05.2022.
//
//

import Foundation
import CoreData


extension Doctor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Doctor> {
        return NSFetchRequest<Doctor>(entityName: "Doctor")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var clinic: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var profession: String?

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
