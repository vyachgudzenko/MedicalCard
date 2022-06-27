//
//  WorkWithDatabase.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 27.06.2022.
//

import Foundation
import CoreData
import UIKit

extension UIViewController{
    
    //MARK: Doctor
    func saveDoctor(firstName:String,lastName:String,clinic:String,phoneNumber:String,profession:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Doctor", in: managedContext)!
        let doctor = NSManagedObject(entity: entity, insertInto: managedContext)
        doctor.setValue(firstName, forKey: "firstName")
        doctor.setValue(lastName, forKey: "lastName")
        doctor.setValue(clinic, forKey: "clinic")
        doctor.setValue(phoneNumber, forKey: "phoneNumber")
        doctor.setValue(profession, forKey: "profession")
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    func hasDiagnosisThisDoctor(doctor:String) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Diagnosis>
        fetchRequest = Diagnosis.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "doctorFullName LIKE %@", doctor)
        do{
            let object = try managedContext.fetch(fetchRequest)
            if object.isEmpty{
                return false
            }
        } catch{
            fatalError()
        }
        return true
    }
    
    func hasAnalysisThisDoctor(doctor:String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Analysis>
        fetchRequest = Analysis.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "doctorFullName LIKE %@", doctor)
        do{
            let object = try managedContext.fetch(fetchRequest)
            if object.isEmpty{
                return false
            }
        } catch{
            fatalError()
        }
        return true
    }
    
    func createNewDoctorController(){
        let newDoctorScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDoctorController") as! NewDoctorController
        newDoctorScreen.doAfterCreate = {
            [self] firstName,lastName,clinic,phoneNumber,profession in
            saveDoctor(firstName: firstName, lastName: lastName, clinic: clinic, phoneNumber: phoneNumber, profession: profession)
        }
        self.navigationController?.pushViewController(newDoctorScreen, animated: true)
    }
    
    func deleteDoctor(doctor:Doctor){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(doctor)
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
}
