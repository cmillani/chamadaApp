//
//  TCPMechanism.swift
//  ChamadaServer
//
//  Created by Carlos Eduardo Millani on 26/11/16.
//  Copyright © 2016 Cadu. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class TCPMechanism: NSObject, GCDAsyncSocketDelegate {
    private override init() {
        super.init()
    }
    static let socketQueue = DispatchQueue(label: "socketQueue")
    static private var listenSocket: GCDAsyncSocket?
    
    static func openSocket(port: Int, delegate: GCDAsyncSocketDelegate) {
        listenSocket = GCDAsyncSocket(delegate: delegate, delegateQueue: socketQueue)
        do {
            try listenSocket?.accept(onPort: UInt16(port))
            listenSocket?.perform({ 
                let result = listenSocket?.enableBackgroundingOnSocket()
                print ("Call to background result -> \(result)")
            })
            print("Socket Open")
        } catch let error {
            print(error)
        }
    }
}
