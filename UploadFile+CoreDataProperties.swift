//
//  UploadFile+CoreDataProperties.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 14.07.2022.
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
    @NSManaged public var typeOfFile: String?
    @NSManaged public var url: String?

}

extension UploadFile : Identifiable {
    var typeOfFileEnum:TypeOfFile{
        get{
            return  TypeOfFile(rawValue: self.typeOfFile!)!
        }
        set{
            self.typeOfFile = newValue.rawValue
        }
    }
}
