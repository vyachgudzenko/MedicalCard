//
//  Medicament+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 19.07.2022.
//
//

import Foundation
import CoreData


extension Medicament {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicament> {
        return NSFetchRequest<Medicament>(entityName: "Medicament")
    }

    @NSManaged public var amountDay: Int64
    @NSManaged public var amountLeftInCourse: Int64
    @NSManaged public var dosage: String?
    @NSManaged public var frequency: Int64
    @NSManaged public var isOver: Bool
    @NSManaged public var isTaken: Bool
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var visitUUID: String?
    @NSManaged public var doctor: Doctor?

}

extension Medicament : Identifiable {
    var frequencyEnum: Frequency {
        get{
            return Frequency(rawValue: self.frequency)!
        }
        set{
            self.frequency = newValue.rawValue
        }
    }
    
    var medicamentTypeEnum:TypeOfMedicament {
        get{
            return TypeOfMedicament(rawValue: self.type!)!
        }
        set{
            self.type = newValue.rawValue
        }
    }
}
