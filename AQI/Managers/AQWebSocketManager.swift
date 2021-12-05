//
//  AQWebSocketManager.swift
//  AQI
//
//  Created by Thangarajan K on 03/12/21.
//

import UIKit
import Starscream

class AQWebSocketManager: NSObject {
    
    private weak var delegate: AQHomeViewModelProtocol?
    static let shared = AQWebSocketManager()
    var timer: Timer?
    let requestUrl = "ws://city-ws.herokuapp.com"
    var websocket: WebSocket?
    
    private override init() {
        super.init()
    }
    
    /// Making socket request
    /// - Parameter parent: Delegate object
    func makeRequest(parent: AQHomeViewModelProtocol?) {
        self.delegate = parent
        let url = URL(string: requestUrl)!
        let request = URLRequest(url: url)
        websocket = WebSocket(request: request)
        websocket?.delegate = self
        websocket?.connect()
    }
    
    /// Starting the connection
    /// - Parameter timerInterval: Interval periods in sec's
    func startConnection(timerInterval: TimeInterval) {
        self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { [self] (timer) in
            print(Date())
            websocket?.connect()
        })
    }
    
    /// Stop the socket connection
    func stopConnection() {
        websocket?.disconnect(closeCode: CloseCode.goingAway.rawValue)
    }
    
    /// Stop the timer
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
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

extension AQWebSocketManager: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        self.stopConnection()
        switch event {
        case .connected(let headers):
          print("connected \(headers)")
        case .disconnected(let reason, let closeCode):
          print("disconnected \(reason) \(closeCode)")
        case .text(let text):
          print("received text: \(text)")
            if let arrayOfCity = convertToDictionary(text: text) {
                self.delegate?.updateReceivedData(arrayOfCity: arrayOfCity)
            }
        case .binary(let data):
          print("received data: \(data)")
        case .pong(let pongData):
          print("received pong: \(pongData)")
        case .ping(let pingData):
          print("received ping: \(pingData)")
        case .error(let error):
          print("error \(error)")
        case .viabilityChanged:
          print("viabilityChanged")
        case .reconnectSuggested:
          print("reconnectSuggested")
        case .cancelled:
          print("cancelled")
        }
      }
}
