//
//  AQHomeViewModel.swift
//  AQI
//
//  Created by Thangarajan K on 04/12/21.
//

import UIKit

protocol AQHomeViewModelProtocol: class {
    func updateReceivedData(arrayOfCity: [[String: Any]])
}

class AQHomeViewModel: NSObject {
    
    var cityArray: [AQCityModel] = []
    weak var delegate : AQHomeProtocol?
    
    init(parent: AQHomeProtocol?) {
        super.init()
        self.delegate = parent
        self.reInitiateManager()
    }
    
    /// Reinitiate the socket 
    func reInitiateManager() {
        AQWebSocketManager.shared.makeRequest(parent: self)
        AQWebSocketManager.shared.startConnection(timerInterval: 60)
    }
}

extension AQHomeViewModel: AQHomeViewModelProtocol {
    func updateReceivedData(arrayOfCity: [[String: Any]]) {
        for cityValues in arrayOfCity {
            let model = AQCityModel(dic: cityValues)
            if let index = self.cityArray.firstIndex(where: { (cModel) -> Bool in
                cModel.city == model.city}) {
                self.cityArray[index] = model
            } else {
                self.cityArray.append(model)
            }
        }
        self.delegate?.reloadTableView()
    }
}
