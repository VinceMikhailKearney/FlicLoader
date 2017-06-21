//
//  APIService.swift
//  FlicLoader
//
//  Created by Vince Kearney on 21/06/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject
{
    // MARK: Properties
    var components : URLComponents?
    static var service : APIService?
    
    static func sharedInstance() -> APIService
    {
        if self.service == nil {
            self.service = APIService()
        }
        
        return self.service!
    }
    
    private func urlFromComponentsWithText(_ text : String, count : String) -> URL
    {
        components = URLComponents()
        components?.scheme = "https"
        components?.host = "api.flickr.com"
        components?.path = "/services/rest"
        components?.queryItems = [URLQueryItem]()
        components?.queryItems!.append(URLQueryItem(name: "method", value: "flickr.photos.search"))
        components?.queryItems!.append(URLQueryItem(name: "api_key", value: Secret.APIKey))
        components?.queryItems!.append(URLQueryItem(name: "text", value: text))
        components?.queryItems!.append(URLQueryItem(name: "per_page", value: count))
        components?.queryItems!.append(URLQueryItem(name: "safe_search", value: "1"))
        components?.queryItems!.append(URLQueryItem(name: "format", value: "json"))
        components?.queryItems!.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        
        return (components?.url)!
    }
    
    public func getFlickrPhotosWithTextUrl(_ text : String)
    {
        self.runDataTask(withUrl: self.urlFromComponentsWithText(text, count: "20"))
        { (result) in
            print("This is the result that we have back -> \(result!)")
        }
    }
    
    private func gotAnError(reason : String) {
        print(reason)
    }
    
    private func runDataTask(withUrl url : URL, completion: @escaping (_ result : Dictionary<String, AnyObject>?) -> Void)
    {
        let request : URLRequest = URLRequest(url: url)
        /// Task
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            
            var failure = "Got an error in response"
            
            guard error == nil else { self.gotAnError(reason: failure); return }
            
            failure = "We received a status code other than 2xx!"
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.gotAnError(reason: failure)
                return
            }
            
            failure = "Did not get data"
            guard let newData = data else { self.gotAnError(reason: failure); return }
            
            let parsed : [String : AnyObject]!
            do {
                parsed = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String : AnyObject]
            } catch {
                failure = "Could not parse the data as JSON: \(newData)"
                self.gotAnError(reason: failure)
                return
            }
            
            failure = "Flickr response states a failure"
            guard let status = parsed["stat"] as? String, status == "ok" else
            {
                if let message = parsed["message"] as? String { failure = message }
                self.gotAnError(reason: failure)
                return
            }
            
            completion(parsed)
        }
        
        task.resume()
        /// Task
    }
}
