//
//  NetworkMonitor.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2021/6/13.
//  Copyright © 2021 陳翰霖. All rights reserved.
//

import Foundation
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor : NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print("DEBUG: The internet is connected \(self?.isConnected)")
        }
    }
    public func stopMoniotoring() {
        monitor.cancel()
    }
}
