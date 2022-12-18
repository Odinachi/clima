//
//  WeatherModel.swift
//  Clima
//
//  Created by Odinachi David on 21/09/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel {
    let id: Int
    let city: String
    let temp: Double
    
    
    var tempString: String{
        return String(format: "%.1f", temp)
    }
    
    var conditionName: String {
        switch temp {
        case 200...223:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
   
}
