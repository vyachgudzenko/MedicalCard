//
//  VisitToDoctor+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.06.2022.
//
//

import Foundation
import CoreData


extension VisitToDoctor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisitToDoctor> {
        return NSFetchRequest<VisitToDoctor>(entityName: "VisitToDoctor")
    }

    @NSManaged public var date: Date?
    @NSManaged public var doctorFullName: String?
    @NSManaged public var complaint: String?
    @NSManaged public var doctor: Doctor?
    @NSManaged public var medicament: NSSet?
    @NSManaged public var analysis: NSSet?

}

// MARK: Generated accessors for medicament
extension VisitToDoctor {

    @objc(addMedicamentObject:)
    @NSManaged public func addToMedicament(_ value: Medicament)

    @objc(removeMedicamentObject:)
    @NSManaged public func removeFromMedicament(_ value: Medicament)

    @objc(addMedicament:)
    @NSManaged public func addToMedicament(_ values: NSSet)

    @objc(removeMedicament:)
    @NSManaged public func removeFromMedicament(_ values: NSSet)

}

// MARK: Generated accessors for analysis
extension VisitToDoctor {

    @objc(addAnalysisObject:)
    @NSManaged public func addToAnalysis(_ value: Analysis)

    @objc(removeAnalysisObject:)
    @NSManaged public func removeFromAnalysis(_ value: Analysis)

    @objc(addAnalysis:)
    @NSManaged public func addToAnalysis(_ values: NSSet)

    @objc(removeAnalysis:)
    @NSManaged public func removeFromAnalysis(_ values: NSSet)

}

extension VisitToDoctor : Identifiable {

}
