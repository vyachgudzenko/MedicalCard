//
//  Doctor+CoreDataClass.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 28.05.2022.
//
//

import Foundation
import CoreData


public class Doctor: NSManagedObject {

}

extension Doctor{
    func getFullName() -> String{
        return "\(self.firstName!) \(self.lastName!)"
    }
}
