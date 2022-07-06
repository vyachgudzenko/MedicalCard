//
//  Analysis+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 05.07.2022.
//
//

import Foundation
import CoreData


extension Analysis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Analysis> {
        return NSFetchRequest<Analysis>(entityName: "Analysis")
    }

    @NSManaged public var date: Date?
    @NSManaged public var descriptionOfAnalysis: String?
    @NSManaged public var diagnosisTitle: String?
    @NSManaged public var doctorFullName: String?
    @NSManaged public var file: Data?
    @NSManaged public var result: String?
    @NSManaged public var title: String?
    @NSManaged public var visitUUID: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var diagnosis: Diagnosis?
    @NSManaged public var doctor: Doctor?

}

extension Analysis : Identifiable {

}
