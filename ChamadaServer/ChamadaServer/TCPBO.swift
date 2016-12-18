//
//  TCPBO.swift
//  ChamadaServer
//
//  Created by Carlos Eduardo Millani on 29/11/16.
//  Copyright © 2016 Cadu. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class TCPBO: NSObject,  GCDAsyncSocketDelegate{
    private let portToUse = 4383
    
    private override init() {
        super.init()
    }
    
    static let shared = TCPBO()
    
    func initServer() {
        TCPMechanism.openSocket(port: portToUse, delegate: self as GCDAsyncSocketDelegate)
    }
    
    private var connectedSockets : [GCDAsyncSocket] = []
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        print("----------NEW SOCKET-------")
        print(newSocket)
        print("----------NEW SOCKET-END---")
        self.connectedSockets.append(newSocket)
        newSocket.perform { 
            let result = newSocket.enableBackgroundingOnSocket()
            print("NewSocket to BG: \(result)")
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("---------READ DATA---------")
        print(data)
        print(tag)
        print("---------READ DATA-END-----")
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("---------DISCONNECTED------")
        print(err ?? "Unknown Error")
        print("---------DISCONNECTED-END--")
    }
}
