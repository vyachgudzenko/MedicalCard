//
//  Medicament+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 15.05.2022.
//
//

import Foundation
import CoreData


extension Medicament {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicament> {
        return NSFetchRequest<Medicament>(entityName: "Medicament")
    }

    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var dosage: String?
    @NSManaged public var frequency: String?

}

extension Medicament : Identifiable {

}
