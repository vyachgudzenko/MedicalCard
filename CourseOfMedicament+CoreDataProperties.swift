//
//  CourseOfMedicament+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 04.07.2022.
//
//

import Foundation
import CoreData


extension CourseOfMedicament {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CourseOfMedicament> {
        return NSFetchRequest<CourseOfMedicament>(entityName: "CourseOfMedicament")
    }

    @NSManaged public var section: String?
    @NSManaged public var medicamentName: String?
    @NSManaged public var status: String?
    @NSManaged public var medicament: Medicament?

}

extension CourseOfMedicament : Identifiable {
    var statusEnum:AcceptanceStatus {
        get{
            return AcceptanceStatus(rawValue: self.status!)!
        }
        set{
            self.status = newValue.rawValue
        }
    }
    
    var sectionEnum:PeriodOfTheDay {
        get{
            return PeriodOfTheDay(rawValue: self.section!)!
        }
        set{
            self.section = newValue.rawValue
        }
    }
}
