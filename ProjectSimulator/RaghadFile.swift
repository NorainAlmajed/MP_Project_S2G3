//
//  File.swift
//  ProjectSimulator
//
//  Created by Raghad Aleskafi on 11/12/2025.
//

import UIKit


struct NgoData{
    let name: String
    let category: String
    let photo: UIImage
    
    }

var arrNgo = [NgoData]()//create empty array  + the name of the struct that i made  down


var ngoDataArray: [NgoData] = [
NgoData(name: "Al kawther Society Social Care", category: "Orphanage", photo: UIImage named: "img_alkwther_logo")!


arrNgo.append(NgoData.init(name: "Amal Foundation", category: "Charity", photo: UIImage(named: "img_amal_logo")!))
arrNgo.append(NgoData.init(name: "Uco Elderly Care", category: "Adult Day Care Center", photo: UIImage(named: "img_uco_logo")!))
arrNgo.append(NgoData.init(name: "Heal Foundation", category: "Rehabilitation & Recovery", photo: UIImage(named: "img_heal_logo")!))
