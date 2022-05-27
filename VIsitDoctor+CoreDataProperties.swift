//
//  VIsitDoctor+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//
//

import Foundation
import CoreData


extension VIsitDoctor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VIsitDoctor> {
        return NSFetchRequest<VIsitDoctor>(entityName: "VIsitDoctor")
    }

    @NSManaged public var dateOfVisit: Date?
    @NSManaged public var doctor: NSSet?
    @NSManaged public var disease: NSSet?
    @NSManaged public var medicament: NSSet?

}

// MARK: Generated accessors for doctor
extension VIsitDoctor {

    @objc(addDoctorObject:)
    @NSManaged public func addToDoctor(_ value: Doctor)

    @objc(removeDoctorObject:)
    @NSManaged public func removeFromDoctor(_ value: Doctor)

    @objc(addDoctor:)
    @NSManaged public func addToDoctor(_ values: NSSet)

    @objc(removeDoctor:)
    @NSManaged public func removeFromDoctor(_ values: NSSet)

}

// MARK: Generated accessors for disease
extension VIsitDoctor {

    @objc(addDiseaseObject:)
    @NSManaged public func addToDisease(_ value: Disease)

    @objc(removeDiseaseObject:)
    @NSManaged public func removeFromDisease(_ value: Disease)

    @objc(addDisease:)
    @NSManaged public func addToDisease(_ values: NSSet)

    @objc(removeDisease:)
    @NSManaged public func removeFromDisease(_ values: NSSet)

}

// MARK: Generated accessors for medicament
extension VIsitDoctor {

    @objc(addMedicamentObject:)
    @NSManaged public func addToMedicament(_ value: Medicament)

    @objc(removeMedicamentObject:)
    @NSManaged public func removeFromMedicament(_ value: Medicament)

    @objc(addMedicament:)
    @NSManaged public func addToMedicament(_ values: NSSet)

    @objc(removeMedicament:)
    @NSManaged public func removeFromMedicament(_ values: NSSet)

}

extension VIsitDoctor : Identifiable {

}
