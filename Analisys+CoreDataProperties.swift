//
//  Analisys+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.05.2022.
//
//

import Foundation
import CoreData


extension Analisys {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Analisys> {
        return NSFetchRequest<Analisys>(entityName: "Analisys")
    }

    @NSManaged public var title: String?
    @NSManaged public var resultOfAnalisys: String?
    @NSManaged public var date: Date?
    @NSManaged public var image: Data?
    @NSManaged public var disease: NSSet?
    @NSManaged public var doctor: NSSet?

}

// MARK: Generated accessors for disease
extension Analisys {

    @objc(addDiseaseObject:)
    @NSManaged public func addToDisease(_ value: Disease)

    @objc(removeDiseaseObject:)
    @NSManaged public func removeFromDisease(_ value: Disease)

    @objc(addDisease:)
    @NSManaged public func addToDisease(_ values: NSSet)

    @objc(removeDisease:)
    @NSManaged public func removeFromDisease(_ values: NSSet)

}

// MARK: Generated accessors for doctor
extension Analisys {

    @objc(addDoctorObject:)
    @NSManaged public func addToDoctor(_ value: Doctor)

    @objc(removeDoctorObject:)
    @NSManaged public func removeFromDoctor(_ value: Doctor)

    @objc(addDoctor:)
    @NSManaged public func addToDoctor(_ values: NSSet)

    @objc(removeDoctor:)
    @NSManaged public func removeFromDoctor(_ values: NSSet)

}

extension Analisys : Identifiable {

}
