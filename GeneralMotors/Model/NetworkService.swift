//
//  NetworkService.swift
//  GeneralMotors
//
//  Created by Royce Reynolds on 10/5/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

class NetworkService: NSObject{
    
     func getDataMethod(parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ data: AnyObject?, _ error: Error?) -> Void){
        
        
        let session = URLSession.shared
        
        let url = self.buildURLwithComponents(parameters)
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            //Check for any error
            guard error == nil else{
                completionHandlerForGET(nil, error)
                return
            }
            
            //Check for successful http response code
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= statusCode else{
                completionHandlerForGET(nil, error)
                return
            }
            
            //Unwrap data
            guard let data = data else{
                completionHandlerForGET(nil, error)
                return
            }
            
            //Convert data to JSON format
            self.convertDataToJSON(data) { (result, error) in
                if let error = error{
                    completionHandlerForGET(nil, error)
                }else{
                    guard let result = result else{return}
                    completionHandlerForGET(result, nil)
                }
            }
            
        }
        task.resume()
    }
    
    private func buildURLwithComponents(_ parameters: [String:AnyObject]) -> URL{
        
        //URL to pull iTunes data
        var component = URLComponents()
        component.scheme = "https"
        component.host = "itunes.apple.com"
        component.path = "/search"
        component.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters{
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            component.queryItems?.append(queryItem)
        }
        
        return component.url!
    }
    
    private func convertDataToJSON(_ data: Data, completionHandlerForData: (_ json: AnyObject?, _ error: Error?) -> Void){
        
        var parsedData: AnyObject! = nil
        //convert to JSON
        do{
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
        }catch{
            completionHandlerForData(nil, error)
        }
        completionHandlerForData(parsedData, nil)
    }
    
    //Singleton for network calls
    class func sharedInstance() -> NetworkService{
        struct Singleton{
            static var sharedInstance = NetworkService()
        }
        
        return Singleton.sharedInstance
    }
    
}
