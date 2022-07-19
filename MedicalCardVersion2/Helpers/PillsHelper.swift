//
//  PillsHelper.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 15.05.2022.
//

import Foundation

enum PeriodOfTheDay:String{
    case morning = "morning"
    case dinner = "dinner"
    case evening = "evening"
}

enum Frequency:Int64{
    case onceADay = 1
    case twiceADay = 2
    case threeTimeADay = 3
}

enum TypeOfMedicament:String {
    case pill = "pill"
    case injection = "injection"
    case syrup = "syrup"
}

enum SectionOfMonth:String{
    case today
    case yesterday
    case thisWeek
    case thisMonth
    case earlier
}

enum AcceptanceStatus:String{
    case itsDrunk = "itsDrunk"
    case forgotten = "forgotten"
    case expect = "expect"
}

struct TypeCellDescription{
    var type:TypeOfMedicament
    var title:String
    var description:String
}

struct FraquencyCellDescription{
    var fraquency:Frequency
    var title:String
}

enum TypeOfFile:String{
    case image = "image"
    case pdf = "pdf"
}

enum SortByTypes{
    case date
    case alphbet
    case doctor
}


