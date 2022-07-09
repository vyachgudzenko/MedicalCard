//
//  DoctorsHelper.swift
//  MedicalCardVersion2
//
//  Created by Вячеслав Гудзенко on 15.05.2022.
//

import Foundation

enum Profession:String{
    case therapist = "therapist"
    case neuropathologist = "neuropathologist"
    case traumatologist = "traumatologist"
}

struct ProfesionsDescription{
    var profession:Profession
    var title:String
    var description:String
}

