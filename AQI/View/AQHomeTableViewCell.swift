//
//  AQHomeTableViewCell.swift
//  AQI
//
//  Created by Thangarajan K on 03/12/21.
//

import UIKit

class AQHomeTableViewCell: UITableViewCell {

    static let cellIdentifier = "aqCell"
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var aqiValueLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    let formattor = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        formattor.dateFormat = "hh:mm a"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    /// Uodate cell values
    /// - Parameter model: AQI data as a Model
    func updateCell(_ model: AQCityModel) {
        cityNameLabel.text = model.city
        aqiValueLabel.text = "AQI: " + (model.aqi ?? "")
        statusLabel.text = model.status?.rawValue
        self.setLastUpdatedTime(model)
        self.setColorBasedOnStatus(model)
    }
    
    /// Updating the last time
    /// - Parameter model: AQI model
    func setLastUpdatedTime(_ model: AQCityModel) {
        lastUpdatedLabel.text = self.getTimeDifference(model.lastUpdated!)
    }
    
    /// Updating the color based on AQI Status
    /// - Parameter model: AQI model
    func setColorBasedOnStatus(_ model: AQCityModel) {
        var color = UIColor.black
        
        switch model.status {
        case .Good:
            color = UIColor.systemGreen
            break
        case .Satisfactory:
            color = UIColor.green
            break
        case .Moderate:
            color = UIColor.yellow
            break
            
        case .Poor:
            color = UIColor.orange
            break
            
        case .VeryPoor:
            color = UIColor.red
            break
            
        case .Severe:
            color = UIColor.brown
            break
            
        case .none:
            break
        }
        self.backgroundColor = color
    }
    
    /// Get the time difference between two dates
    /// - Parameter lastUpdated: last updated date
    /// - Returns: return the string
    func getTimeDifference(_ lastUpdated: Date) -> String {
        let difference = Calendar.current.dateComponents([.second], from: lastUpdated, to: Date())
        if (difference.minute ?? 0) < 60 {
            return "A few seconds ago"
        } else if (difference.minute ?? 0) > 60 {
            return "A minute ago"
        } else {
            return formattor.string(from: lastUpdated)
        }
    }
}
