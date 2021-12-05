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
}

extension AQGraphViewModel: AQHomeViewModelProtocol {
    func updateReceivedData(arrayOfCity: [[String: Any]]) {
        for cityValues in arrayOfCity {
            let model = AQCityModel(dic: cityValues)
            if model.city == selectedCity, let aqi = model.aqi {
                self.delegate?.reloadChart(aqi: aqi)
            }
        }
    }
}
