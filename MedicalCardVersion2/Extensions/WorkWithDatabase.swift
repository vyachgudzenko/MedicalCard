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
    
    func editDoctor(doctor:Doctor){
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDoctorController") as! NewDoctorController
        editScreen.navigationItem.title = doctor.getFullName()
        editScreen.firstName = doctor.firstName!
        editScreen.lastName = doctor.lastName!
        editScreen.clinic = doctor.clinic!
        editScreen.phoneNumber = doctor.phoneNumber!
        editScreen.profession = doctor.professionEnum
        editScreen.doAfterCreate = {
             firstName,lastName,clinic,numberPhone,profession in
            doctor.firstName = firstName
            doctor.lastName = lastName
            doctor.clinic = clinic
            doctor.phoneNumber = numberPhone
            doctor.profession = profession
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        self.navigationController?.pushViewController(editScreen, animated: true)
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
    
    func editDiagnosis(diagnosis:Diagnosis){
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewDiagnosisController") as! NewDiagnosisController
        editScreen.navigationTitle = diagnosis.title!
        editScreen.titleFirst = diagnosis.title!
        editScreen.descriptionFirst = diagnosis.descriptionOfDiagnosis!
        editScreen.dateFirst = diagnosis.date!
        editScreen.doctor = diagnosis.doctor
        editScreen.doctorLabelText = (diagnosis.doctor?.getFullName())!
        editScreen.doAfterCreate = {
            titleOfDiagnosis,descriptionOfDiagnosis,date,doctor in
            diagnosis.title = titleOfDiagnosis
            diagnosis.descriptionOfDiagnosis = descriptionOfDiagnosis
            diagnosis.date = date
            diagnosis.doctor = doctor
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        navigationController?.pushViewController(editScreen, animated: true)
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
    func saveAnalysis(title:String,descriptionofAnalysis:String,result:String,date:Date,doctor:Doctor,diagnosis:Diagnosis?,visitUUID:String?,uuid:UUID){
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
        newAnalysis.setValue(diagnosis?.title, forKey: "diagnosisTitle")
        newAnalysis.setValue(visitUUID, forKey: "visitUUID")
        newAnalysis.setValue(uuid, forKey: "uuid")
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }

    func createNewAnalisys(uuid:UUID?){
        let newAnalisys = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewAnalysisController") as! NewAnalysisController
        newAnalisys.visitUUID = uuid
        newAnalisys.doAfterCreate = { [self]
            titleOfAnalysis,descriptionOfAnalysis,result,date,doctor,diagnosis,visitUUID,uuid in
            saveAnalysis(title: titleOfAnalysis, descriptionofAnalysis: descriptionOfAnalysis, result: result, date: date, doctor: doctor, diagnosis: diagnosis,visitUUID: visitUUID,uuid: uuid!)
        }
        navigationController?.pushViewController(newAnalisys, animated: true)
    }
    
    func editAnalysis(analysis:Analysis){
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewAnalysisController") as! NewAnalysisController
        editScreen.navigationTitle = analysis.title!
        editScreen.uuid = analysis.uuid
        editScreen.titleText = analysis.title!
        editScreen.descriptionText = analysis.descriptionOfAnalysis ?? ""
        editScreen.resultText = analysis.result!
        editScreen.dateAnalysis = analysis.date!
        editScreen.doctor = analysis.doctor
        editScreen.doctorLabelText = analysis.doctorFullName!
        editScreen.diagnosis = analysis.diagnosis
        editScreen.diagnosisLabelText = analysis.diagnosisTitle!
        editScreen.doAfterCreate = {
            titleOfAnalysis,descriptionOfAnalysis,result,date,doctor,diagnosis,visitUUID,uuid in
            analysis.title = titleOfAnalysis
            analysis.descriptionOfAnalysis = descriptionOfAnalysis
            analysis.result = result
            analysis.date = date
            analysis.doctor = doctor
            analysis.diagnosis = diagnosis
            analysis.doctorFullName = doctor.getFullName()
            analysis.diagnosisTitle = diagnosis?.title
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        navigationController?.pushViewController(editScreen, animated: true)
    }
    
    func countOfUploadFiles(uuid:String) -> Int{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UploadFile>
        fetchRequest = UploadFile.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "analysisUUID LIKE %@", uuid)
        do{
            let object = try managedContext.fetch(fetchRequest)
            let count = object.count
            return count
        }
        catch{
            fatalError()
        }
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
    
    //MARK: Medicament
    func saveNewMedicament(title:String,dosage:String,type:String,frequency:String,doctor:Doctor?,visitUUID:String?,isTaken:Bool,isOver:Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Medicament", in: managedContext)!
        let newMedicament = NSManagedObject(entity: entity, insertInto: managedContext)
        newMedicament.setValue(title, forKey: "title")
        newMedicament.setValue(dosage, forKey: "dosage")
        newMedicament.setValue(type, forKey: "type")
        newMedicament.setValue(frequency, forKey: "frequency")
        newMedicament.setValue(doctor, forKey: "doctor")
        newMedicament.setValue(visitUUID, forKey: "visitUUID")
        newMedicament.setValue(isTaken, forKey: "isTaken")
        newMedicament.setValue(isOver, forKey: "isOver")
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    func createNewMedicament(visitUUID:String?){
        let newMedicament = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPillController") as! NewPillController
        newMedicament.visitUUID = visitUUID
        newMedicament.doAfterEdit = {
            [self] title,dosage,type,frequency,doctor,visitUUID,isTaken,isOver in
            saveNewMedicament(title: title, dosage: dosage, type: type, frequency: frequency, doctor: doctor,visitUUID:visitUUID, isTaken: isTaken, isOver: isOver)
            }
        navigationController?.pushViewController(newMedicament, animated: true)
    }
    
    func editMedicament(medicament:Medicament){
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPillController") as! NewPillController
        editScreen.navigationTitle = medicament.title!
        editScreen.medicament = medicament
        editScreen.isNewMedicament = false
        editScreen.medicamentName = medicament.title!
        editScreen.medicamentDosage = medicament.dosage!
        editScreen.medicamentType = medicament.medicamentTypeEnum
        editScreen.medicamentFrequency = medicament.frequencyEnum
        editScreen.isTaken = medicament.isTaken
        editScreen.isOver = medicament.isOver
        editScreen.visitUUID = medicament.visitUUID
        editScreen.doAfterEdit = { [self] title,dosage,type,frequency,doctor,visitUUID,isTaken,isOver in
            
            medicament.setValue(title, forKey: "title")
            medicament.setValue(dosage, forKey: "dosage")
            medicament.setValue(type, forKey: "type")
            medicament.setValue(frequency, forKey: "frequency")
            medicament.setValue(isTaken, forKey: "isTaken")
            medicament.setValue(doctor, forKey: "doctor")
            medicament.setValue(visitUUID, forKey: "visitUUID")
            medicament.setValue(isTaken, forKey: "isTaken")
            medicament.setValue(isOver, forKey: "isOver")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        self.navigationController?.pushViewController(editScreen, animated: true)
    }
    
    func deleteMedicament(medicament:Medicament){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(medicament)
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    //MARK: Visits
    func createNewVisit(){
        let newVisit  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewVisitController") as! NewVisitController
        newVisit.doAfterCreate = {[self] complaint,date,doctor,diagnosis,uuid in
            saveNewVisit(complaint: complaint, date: date, doctor: doctor, diagnosis: diagnosis,uuid: uuid)
        }
        navigationController?.pushViewController(newVisit, animated: true)
    }
    
    func saveNewVisit(complaint:String?,date:Date?,doctor:Doctor?,diagnosis:Diagnosis?,uuid:UUID){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "VisitToDoctor", in: managedContext)!
        let newVisit = NSManagedObject(entity: entity, insertInto: managedContext)
        newVisit.setValue(complaint, forKey: "complaint")
        newVisit.setValue(date, forKey: "date")
        newVisit.setValue(doctor, forKey: "doctor")
        newVisit.setValue(doctor?.getFullName(), forKey: "doctorFullName")
        newVisit.setValue(diagnosis, forKey: "diagnosis")
        newVisit.setValue(diagnosis?.title, forKey: "diagnosisTitle")
        newVisit.setValue(uuid, forKey: "uuid")
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    func editVisit(visit:VisitToDoctor){
        let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewVisitController") as! NewVisitController
        editScreen.navigationItem.title = visit.doctorFullName
        editScreen.complaint = visit.complaint
        editScreen.date = visit.date!
        editScreen.diagnosis = visit.diagnosis
        editScreen.doctor = visit.doctor
        editScreen.uuid = visit.uuid
        editScreen.doAfterCreate = {[self] complaint,date,doctor,diagnosis,uuid in
            visit.complaint = complaint
            visit.date = date
            visit.diagnosis = diagnosis
            visit.doctor = doctor
            visit.uuid = uuid
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save.\(error),\(error.userInfo)")
            }
        }
        navigationController?.pushViewController(editScreen, animated: true)
    }
    
    func countAnalysisHasThisVisit(uuid:String) -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Analysis>
        fetchRequest = Analysis.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "visitUUID LIKE %@", uuid)
        do{
            let object = try managedContext.fetch(fetchRequest)
            let count = object.count
            return count
        }
        catch{
            fatalError()
        }
    }
    
    func countMedicamentHasThisVisit(uuid:String) -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Medicament>
        fetchRequest = Medicament.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "visitUUID LIKE %@", uuid)
        do{
            let object = try managedContext.fetch(fetchRequest)
            let count = object.count
            return count
        }
        catch{
            fatalError()
        }
    }
    
    
    
    //MARK: CourseMedicament
    func saveNewCourse(medicament:Medicament,section:PeriodOfTheDay){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CourseOfMedicament", in: managedContext)!
        let newCourse = NSManagedObject(entity: entity, insertInto: managedContext)
        newCourse.setValue(medicament, forKey: "medicament")
        newCourse.setValue(section.rawValue, forKey: "section")
        newCourse.setValue("expect", forKey: "status")
        newCourse.setValue(medicament.title, forKey: "medicamentName")
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    func changeItsDrunk(course:CourseOfMedicament){
        course.statusEnum = .itsDrunk
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    func changeItsForgotten(course:CourseOfMedicament){
        course.statusEnum = .forgotten
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
    
    func deleteAllCoursesThatHaveThisMedicament(medicament:Medicament){
        var courses:[NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CourseOfMedicament>
        fetchRequest = CourseOfMedicament.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "medicamentName LIKE %@", medicament.title!)
        do{
            courses = try managedContext.fetch(fetchRequest)
        } catch{
            fatalError()
        }
        for course in courses {
            managedContext.delete(course)
        }
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
        
    }
    
    func generateCourseOfDay(medicament:Medicament){
        switch medicament.frequencyEnum{
        case .onceADay:
            saveNewCourse(medicament: medicament, section: .morning)
        case .twiceADay:
            saveNewCourse(medicament: medicament, section: .morning)
            saveNewCourse(medicament: medicament, section: .evening)
        case .threeTimeADay:
            saveNewCourse(medicament: medicament, section: .morning)
            saveNewCourse(medicament: medicament, section: .dinner)
            saveNewCourse(medicament: medicament, section: .evening)
        }
    }
    
    //MARK: UploadFile
    func saveUploadFile(analysisUUID:String,file:Data?,typeOfFile:TypeOfFile,url:String?){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UploadFile", in: managedContext)!
        let uploadFile = NSManagedObject(entity: entity, insertInto: managedContext)
        uploadFile.setValue(analysisUUID, forKey: "analysisUUID")
        uploadFile.setValue(typeOfFile.rawValue, forKey: "typeOfFile")
        uploadFile.setValue(Date(), forKey: "date")
        switch typeOfFile {
        case .image:
            uploadFile.setValue(file, forKey: "file")
        case .pdf:
            uploadFile.setValue(url, forKey: "url")
        }
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save.\(error),\(error.userInfo)")
        }
    }
}

