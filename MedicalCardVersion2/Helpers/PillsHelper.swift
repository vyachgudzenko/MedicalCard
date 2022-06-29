//
//  PillsHelper.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 15.05.2022.
//

import Foundation

enum PeriodOfTheDay:String{
    case morning
    case dinner
    case evening
}

enum Frequency:String{
    case onceADay = "Один раз в день"
    case twiceADay = "Дважды в день"
    case threeTimeADay = "Трижды в день"
}

enum TypeOfMedicament:String {
    case pill
    case injection
    case syrup
}
