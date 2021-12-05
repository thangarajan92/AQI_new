//
//  AQHomeViewModel.swift
//  AQI
//
//  Created by Thangarajan K on 04/12/21.
//

import UIKit

protocol AQHomeViewModelProtocol: class {
    func updateReceivedData(dataText: String)
}

class AQHomeViewModel: NSObject {
    
    var cityArray: [AQCityModel] = []
    weak var delegate : AQHomeProtocol?
    
    init(parent: AQHomeProtocol?) {
        super.init()
        self.delegate = parent
        AQWebSocketManager.shared.makeRequest(parent: self)
        AQWebSocketManager.shared.startConnection(timerInterval: 60)
    }
    
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

extension AQHomeViewModel: AQHomeViewModelProtocol {
    func updateReceivedData(dataText: String) {
        if let arrayOfCity = convertToDictionary(text: dataText) {
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
}
