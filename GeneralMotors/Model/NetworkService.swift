//
//  NetworkService.swift
//  GeneralMotors
//
//  Created by Royce Reynolds on 10/5/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

class NetworkService: NSObject{
    
    func getDataMethod(song: String, completionHandlerForGET: @escaping (_ data: Data?, _ error: Error?) -> Void){
        
        
        let session = URLSession.shared
        
        let url = URL(string: "https://itunes.apple.com/search?term=\(song)")
        
        let request = URLRequest(url: url!)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                completionHandlerForGET(nil, error)
                return
            }
            
            //Check for return code
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , 200...299 ~= statusCode else{
                completionHandlerForGET(nil, error)
                return
            }
            
            guard let data = data else{
                completionHandlerForGET(nil, error)
                return
            }
            
            self.convertDataToJSON(data) { (result, error) in
                if let error = error{
                    completionHandlerForGET(nil, error)
                }else{
                    guard let result = result else{return}
                    
                }
                
                
            }
            
            
        }
        task.resume()
    }
    
    private func convertDataToJSON(_ data: Data, completionHandlerForData: (_ json: AnyObject?, _ error: Error?) -> Void){
        
        var parsedData: AnyObject! = nil
        
        do{
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
        }catch{
            completionHandlerForData(nil, error)
        }
        completionHandlerForData(parsedData, nil)
    }
    
    class func sharedInstance() -> NetworkService{
        struct Singleton{
            static var sharedInstance = NetworkService()
        }
        
        return Singleton.sharedInstance
    }
    
}
