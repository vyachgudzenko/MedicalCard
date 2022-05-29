//
//  Analysis+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 30.05.2022.
//
//

import Foundation
import CoreData


extension Analysis {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Analysis> {
        return NSFetchRequest<Analysis>(entityName: "Analysis")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptionOfAnalysis: String?
    @NSManaged public var result: String?
    @NSManaged public var doctorFullName: String?
    @NSManaged public var diagnosisTitle: String?
    @NSManaged public var date: Date?
    @NSManaged public var file: Data?
    @NSManaged public var doctor: Doctor?
    @NSManaged public var diagnosis: Diagnosis?

}

extension Analysis : Identifiable {

}
