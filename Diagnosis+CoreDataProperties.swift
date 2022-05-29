//
//  Diagnosis+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 29.05.2022.
//
//

import Foundation
import CoreData


extension Diagnosis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diagnosis> {
        return NSFetchRequest<Diagnosis>(entityName: "Diagnosis")
    }

    @NSManaged public var date: Date?
    @NSManaged public var descriptionOfDiagnosis: String?
    @NSManaged public var title: String?
    @NSManaged public var doctorFullName: String?
    @NSManaged public var doctor: Doctor?

}

extension Diagnosis : Identifiable {

}
