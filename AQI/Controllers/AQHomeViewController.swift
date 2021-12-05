//
//  AQHomeViewController.swift
//  AQI
//
//  Created by Thangarajan K on 03/12/21.
//

import UIKit

protocol AQHomeProtocol: class {
    func reloadTableView() -> (Void)
}

class AQHomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var homeViewModel: AQHomeViewModel?
    let graphIndentifier = "AQGraphViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "City AQI Data's"
        self.initViewModel()
    }
    
    /// Initinating the view model
    func initViewModel() {
        self.homeViewModel = AQHomeViewModel(parent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.homeViewModel?.reInitiateManager()
    }
}

extension AQHomeViewController: AQHomeProtocol{
    func reloadTableView() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
}

extension AQHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel?.cityArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AQHomeTableViewCell.cellIdentifier, for: indexPath) as? AQHomeTableViewCell
        cell?.updateCell((homeViewModel?.cityArray[indexPath.row])!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: graphIndentifier) as? AQGraphViewController
        if let model = homeViewModel?.cityArray[indexPath.row], let aqi = Double(model.aqi!) {
            controller?.aqiData.append(aqi)
            controller?.cityName = model.city!
        }
        AQWebSocketManager.shared.stopTimer()
        self.navigationController?.show(controller!, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
