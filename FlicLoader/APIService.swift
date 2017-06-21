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
    
    override init()
    {
        components = URLComponents()
        components?.scheme = "https"
        components?.host = "api.flickr.com"
        components?.path = "/services/rest"
        components?.queryItems = [URLQueryItem]()
        components?.queryItems!.append(URLQueryItem(name: "method", value: "flickr.photos.search"))
        components?.queryItems!.append(URLQueryItem(name: "api_key", value: Secret.APIKey))
        
        super.init()
    }
    
    static func sharedInstance() -> APIService
    {
        if self.service == nil {
            self.service = APIService()
        }
        
        return self.service!
    }
}
