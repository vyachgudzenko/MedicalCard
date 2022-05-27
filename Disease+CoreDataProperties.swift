//
//  Disease+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//
//

import Foundation
import CoreData


extension Disease {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Disease> {
        return NSFetchRequest<Disease>(entityName: "Disease")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptionOfDisease: String?
    @NSManaged public var dateOfDiagnosis: Date?
    @NSManaged public var doctor: NSSet?

}

// MARK: Generated accessors for doctor
extension Disease {

    @objc(addDoctorObject:)
    @NSManaged public func addToDoctor(_ value: Doctor)

    @objc(removeDoctorObject:)
    @NSManaged public func removeFromDoctor(_ value: Doctor)

    @objc(addDoctor:)
    @NSManaged public func addToDoctor(_ values: NSSet)

    @objc(removeDoctor:)
    @NSManaged public func removeFromDoctor(_ values: NSSet)

}

extension Disease : Identifiable {

}
