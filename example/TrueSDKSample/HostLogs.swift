//
//  HostLogs.swift
//  SwiftTrueSDKHost
//
//  Created by Aleksandar Mihailovski on 27/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

import UIKit
import TrueSDK

class HostLog: NSObject {
    let error: Error
    let timestamp: Date
    
    init(_ error: TCError) {
        self.error = error
        timestamp = Date()
    }
}

class HostLogs: NSObject {
    static let sharedInstance = HostLogs()
    fileprivate override init() {} //This prevents others from using the default '()' initializer for this class.

    fileprivate var logsList = Array<HostLog>()
    
    func logError(_ error: TCError) {
        logsList.append(HostLog(error))
    }
    
    func clearLogs() {
        logsList.removeAll()
    }
    
    func allLogs() -> Array<HostLog> {
        return logsList
    }
}
