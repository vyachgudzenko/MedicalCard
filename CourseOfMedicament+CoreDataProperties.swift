//
//  CourseOfMedicament+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 03.07.2022.
//
//

import Foundation
import CoreData


extension CourseOfMedicament {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CourseOfMedicament> {
        return NSFetchRequest<CourseOfMedicament>(entityName: "CourseOfMedicament")
    }

    @NSManaged public var itsDrunk: Bool
    @NSManaged public var section: String?
    @NSManaged public var medicamentName: String?
    @NSManaged public var medicament: Medicament?

}

extension CourseOfMedicament : Identifiable {

}
