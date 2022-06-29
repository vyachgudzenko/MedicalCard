//
//  Medicament+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 30.06.2022.
//
//

import Foundation
import CoreData


extension Medicament {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicament> {
        return NSFetchRequest<Medicament>(entityName: "Medicament")
    }

    @NSManaged public var dosage: String?
    @NSManaged public var frequency: String?
    @NSManaged public var isOver: Bool
    @NSManaged public var isTaken: Bool
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var visitUUID: String?
    @NSManaged public var amountDay: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var doctor: Doctor?

}

extension Medicament : Identifiable {

}
