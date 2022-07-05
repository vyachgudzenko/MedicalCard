//
//  UploadFile+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 05.07.2022.
//
//

import Foundation
import CoreData


extension UploadFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UploadFile> {
        return NSFetchRequest<UploadFile>(entityName: "UploadFile")
    }

    @NSManaged public var analysisUUID: String?
    @NSManaged public var date: Date?
    @NSManaged public var file: Data?

}

extension UploadFile : Identifiable {

}
