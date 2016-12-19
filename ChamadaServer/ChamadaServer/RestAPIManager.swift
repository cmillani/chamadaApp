//
//  RestApiManager.swift
//  Nino
//
//  Created by Danilo Becke on 05/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestApiManager: NSObject {
    
    
    typealias ServiceResponse = (_ json: JSON, _ error: Error?, _ statusCode: Int?) -> Void
    
    //    private static let baseURL = "api.ninoapp.com.br/"
    //MARK: PROD_URL
    //    private static let baseURL = "https://www.ninoapp.com.br:5000/"
    //MARK: DEV_URL
    private static let baseURL = "https://raspberrypi.local:3000/"
    
    private static let device: String = {
        let webView = UIWebView()
        let string = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        return string!
    }()
    
    /**
     Makes GET request to baseURL/
     
     - parameter group:        optional int to make requests in group
     - parameter path:         path to make the request
     - parameter token:        optional user token
     - parameter onCompletion: Completion block with JSON data and NSError
     */
    static func makeHTTPGetRequest(path: String, token: String?, onCompletion: @escaping ServiceResponse) {
        let url = baseURL + path
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(self.device, forHTTPHeaderField: "User-Agent")
        if let userToken = token {
            request.setValue(userToken, forHTTPHeaderField: "x-access-token")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                onCompletion(JSON.null, error, nil)
                return
            }
            if let jsonData = data {
                let json = JSON(data: jsonData)
                onCompletion(json, error, statusCode)
            } else {
                onCompletion(JSON.null, error, statusCode)
            }
        }
        task.resume()
    }
    
    /**
     Makes POST request to baseURL/
     
     - parameter path:         path to make the request
     - parameter body:         Dictionary with the body
     - parameter onCompletion: Completion block with JSON data and NSError
     */
    static func makeHTTPPostRequest(path: String, body: [String : AnyObject], onCompletion: @escaping ServiceResponse) {
        let url = baseURL + path
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        do {
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = jsonBody
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue(self.device, forHTTPHeaderField: "User-Agent")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    onCompletion(JSON.null, error, nil)
                    return
                }
                guard let jsonData = data else {
                    onCompletion(JSON.null, error, statusCode)
                    return
                }
                let json = JSON(data: jsonData)
                onCompletion(json, nil, statusCode)
            })
            task.resume()
        } catch {
            onCompletion(JSON.null, nil, nil)
        }
    }
    
    
    
}
