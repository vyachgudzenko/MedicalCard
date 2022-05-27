//
//  PillsStorage.swift
//  MedicalCard
//
//  Created by Вячеслав Гудзенко on 02.05.2022.
//

import Foundation

protocol StorageProtocol{
    func load() -> [Medicament]
    func save(arrayOfMedicament:[MedicamentProtocol])
}

class PillsStorage:StorageProtocol{
    func load() -> [Medicament] {
        var arrayOfMedicament:[Medicament] = []
        arrayOfMedicament.append(Medicament(idofMedicament: arrayOfMedicament.count, titleOfMedicament: "Analgin", typeOfMedicament: .pill, dosageOfMedicament: 1, frequencyOfMedicament: .onceADay))
        arrayOfMedicament.append(Medicament(idofMedicament: arrayOfMedicament.count, titleOfMedicament: "Vitamin", typeOfMedicament: .syrup, dosageOfMedicament: 1, frequencyOfMedicament: .twiceADay))
        arrayOfMedicament.append(Medicament(idofMedicament: arrayOfMedicament.count, titleOfMedicament: "Water", typeOfMedicament: .injection, dosageOfMedicament: 1, frequencyOfMedicament: .threeTimeADay))
        return arrayOfMedicament
    }
    
    func sortForSectionOfDay(arrayOfMedicament:[Medicament]) -> [PeriodOfTheDay:[Medicament]]{
        var sortedArray:[PeriodOfTheDay:[Medicament]] = [:]
        let sectionOfDay:[PeriodOfTheDay] = [.morning,.dinner,.evening]
        sectionOfDay.forEach { section in
            sortedArray[section] = []
        }
        arrayOfMedicament.forEach { medicament in
            switch medicament.frequency{
            case .onceADay:
                sortedArray[.morning]?.append(medicament)
            case .twiceADay:
                sortedArray[.morning]?.append(medicament)
                sortedArray[.evening]?.append(medicament)
            case .threeTimeADay:
                sortedArray[.morning]?.append(medicament)
                sortedArray[.dinner]?.append(medicament)
                sortedArray[.evening]?.append(medicament)
            }
        }
        return sortedArray
    }
    
    func save(arrayOfMedicament: [MedicamentProtocol]) {
        //пока так
    }
    
}

