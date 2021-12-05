//
//  AQCityModel.swift
//  AQI
//
//  Created by Thangarajan K on 03/12/21.
//

import UIKit

enum AQIStatus: String {
    case Good = "Good"
    case Satisfactory = "Satisfactory"
    case Moderate = "Moderate"
    case Poor = "Poor"
    case VeryPoor = "Very Poor"
    case Severe = "Severe"
}

class AQCityModel {
    
    var city: String?
    var aqi: String?
    var lastUpdated: Date?
    var status: AQIStatus?
    
    init(dic: Dictionary<String, Any>) {
        self.city = dic["city"] as? String
        if let aqiDouble = dic["aqi"] as? Double {
            self.aqi = String(format: "%.2f", aqiDouble)
            self.updateStatus(aqiDouble)
        }
        self.lastUpdated = Date()
    }
    
    func updateStatus(_ aqiValue: Double) {
        if aqiValue < 51 {
            self.status = .Good
        } else if aqiValue > 50 && aqiValue < 100 {
            self.status = .Satisfactory
        } else if aqiValue > 100 && aqiValue < 200 {
            self.status = .Moderate
        } else if aqiValue > 200 && aqiValue < 300 {
            self.status = .Poor
        } else if aqiValue > 300 && aqiValue < 400 {
            self.status = .VeryPoor
        } else {
            self.status = .Severe
        }
    }
}
