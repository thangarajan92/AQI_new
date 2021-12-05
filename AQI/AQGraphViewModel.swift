//
//  AQGraphViewModel.swift
//  AQI
//
//  Created by Thangarajan K on 05/12/21.
//

import UIKit

class AQGraphViewModel: NSObject {
    
    weak var delegate : AQGraphProtocol?
    var selectedCity: String?
    
    init(parent: AQGraphProtocol?, city: String) {
        super.init()
        self.delegate = parent
        self.selectedCity = city
        AQWebSocketManager.shared.makeRequest(parent: self)
        AQWebSocketManager.shared.startConnection(timerInterval: 30)
    }
    
    /// Convert the text into dictionary
    /// - Parameter text: response text
    /// - Returns: return the array of dictionary
    func convertToDictionary(text: String) -> [[String: Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension AQGraphViewModel: AQHomeViewModelProtocol {
    func updateReceivedData(dataText: String) {
        if let arrayOfCity = convertToDictionary(text: dataText) {
            for cityValues in arrayOfCity {
                let model = AQCityModel(dic: cityValues)
                if model.city == selectedCity, let aqi = model.aqi {
                    self.delegate?.reloadChart(aqi: aqi)
                }
            }
        }
    }
}
