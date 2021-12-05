//
//  AQGraphViewController.swift
//  AQI
//
//  Created by Thangarajan K on 04/12/21.
//

import UIKit
import SwiftChart

protocol AQGraphProtocol: class {
    func reloadChart(aqi: String)
}

class AQGraphViewController: UIViewController {
    
    @IBOutlet weak var chart: Chart!
    var graphViewModel: AQGraphViewModel?

    var ylabels: [Double] = [0, 50, 100, 200, 300, 400, 500]
    var aqiData: [Double] = []
    var labelsAsString: Array<String> = ["30"]
    var cityName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = cityName + " AQI Data"
        self.createStockChart()
        self.initViewModel()
    }
    
    deinit {
        AQWebSocketManager.shared.stopTimer()
        graphViewModel = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AQWebSocketManager.shared.stopTimer()
        graphViewModel = nil
    }
    
    /// Initiate the view model
    func initViewModel() {
        self.graphViewModel = AQGraphViewModel(parent: self, city: cityName)
    }
    
    /// Create the Stock chart
    func createStockChart() {
        let series = ChartSeries(aqiData)
        series.area = true
        // Configure chart layout
        chart.lineWidth = 0.5
        chart.labelFont = UIFont.systemFont(ofSize: 12)
        
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return self.labelsAsString[labelIndex]
        }
        chart.yLabels = ylabels
        chart.xLabelsTextAlignment = .center
        chart.yLabelsOnRightSide = false
        chart.removeAllSeries()
        chart.add(series)
    }
}

extension AQGraphViewController: AQGraphProtocol{
    
    func reloadChart(aqi: String) {
        if let nAqi = Double(aqi) {
            aqiData.append(nAqi)
        }
        if let lastX_axis = Int(labelsAsString.last ?? "0") {
            let yAxis = lastX_axis + 30
            labelsAsString.append("\(yAxis)")
        }
        
        DispatchQueue.main.async {
            self.createStockChart()
        }
    }
}
