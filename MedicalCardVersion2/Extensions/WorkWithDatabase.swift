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
    
    //MARK: Diagnosis
    func saveDiagnosis(title:String,description:String,date:Date,doctor:Doctor){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Diagnosis", in: managedContext)!
        let newDiagnosis = NSManagedObject(entity: entity, insertInto: managedContext)
        newDiagnosis.setValue(title, forKey: "title")
        newDiagnosis.setValue(description, forKey: "descriptionOfDiagnosis")
        newDiagnosis.setValue(date, forKey: "date")
        newDiagnosis.setValue(doctor.getFullName(), forKey: "doctorFullName")
        newDiagnosis.setValue(doctor, forKey: "doctor")
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    func createNewDiagnosisController(){
        let newDiagnosis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDiagnosisController") as! NewDiagnosisController
        newDiagnosis.doAfterCreate = {
            [self] titleOfDiagnosis,descriptionOfDiagnosis,date,doctor in
            saveDiagnosis(title: titleOfDiagnosis, description: descriptionOfDiagnosis, date: date, doctor: doctor)
            
        }
        navigationController?.pushViewController(newDiagnosis, animated: true)
    }
    
    func deleteDiagnosis(diagnosis:Diagnosis, index:Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(diagnosis)
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    func hasAnalysisThisDiagnosis(diagnosisTitle:String) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Analysis>
        fetchRequest = Analysis.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "diagnosisTitle LIKE %@", diagnosisTitle)
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
    
    //MARK: Analizes
    func saveAnalysis(title:String,descriptionofAnalysis:String,result:String,date:Date,doctor:Doctor,diagnosis:Diagnosis){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Analysis", in: managedContext)!
        let newAnalysis = NSManagedObject(entity: entity, insertInto: managedContext)
        newAnalysis.setValue(title, forKey: "title")
        newAnalysis.setValue(descriptionofAnalysis, forKey: "descriptionOfAnalysis")
        newAnalysis.setValue(result, forKey: "result")
        newAnalysis.setValue(date, forKey: "date")
        newAnalysis.setValue(doctor, forKey: "doctor")
        newAnalysis.setValue(doctor.getFullName(), forKey: "doctorFullName")
        newAnalysis.setValue(diagnosis, forKey: "diagnosis")
        newAnalysis.setValue(diagnosis.title, forKey: "diagnosisTitle")
    }

    func createNewAnalisys(){
        let newAnalisys = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewAnalysisController") as! NewAnalysisController
        newAnalisys.doAfterCreate = { [self]
            titleOfAnalysis,descriptionOfAnalysis,result,date,doctor,diagnosis in
            saveAnalysis(title: titleOfAnalysis, descriptionofAnalysis: descriptionOfAnalysis, result: result, date: date, doctor: doctor, diagnosis: diagnosis)
        }
        navigationController?.pushViewController(newAnalisys, animated: true)
    }
    
    func deleteAnalysis(analysis:Analysis){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(analysis)
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
}