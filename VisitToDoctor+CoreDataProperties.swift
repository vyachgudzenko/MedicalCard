//
//  VisitToDoctor+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 28.06.2022.
//
//

import Foundation
import CoreData


extension VisitToDoctor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisitToDoctor> {
        return NSFetchRequest<VisitToDoctor>(entityName: "VisitToDoctor")
    }

    @NSManaged public var complaint: String?
    @NSManaged public var date: Date?
    @NSManaged public var doctorFullName: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var diagnosisTitle: String?
    @NSManaged public var doctor: Doctor?
    @NSManaged public var diagnosis: Diagnosis?

}

extension VisitToDoctor : Identifiable {

}
