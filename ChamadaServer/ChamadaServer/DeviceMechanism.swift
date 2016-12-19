//
//  DeviceMechanism.swift
//  ChamadaServer
//
//  Created by Carlos Eduardo Millani on 18/12/16.
//  Copyright © 2016 Cadu. All rights reserved.
//

import UIKit

class DeviceMechanism: NSObject {
    static func registerDevice(name: String, token: String, completionHandler: (_ device: () throws -> Void) -> Void) throws {
        let body: [String: AnyObject] = ["name": name as AnyObject, "device": token as AnyObject]
        RestApiManager.makeHTTPPostRequest(path: "devices", body: body, onCompletion: { (json, error, statusCode) in
            guard let statusCode = statusCode else {
//                completionHandler(accessToken: nil, error: error?.code)
                return
            }
            //error
            if statusCode != 200 {
//                let error = json["error"].int
//                completionHandler(accessToken: nil, error: error)
            }
                //success
            else {
//                let token = json["data"]["token"].string
//                completionHandler(accessToken: token, error: nil)
            }

        })
    }
}
