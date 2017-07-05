//
//  APIService.swift
//  FlicLoader
//
//  Created by Vince Kearney on 21/06/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import Foundation
import UIKit

public protocol APIServiceDelegate {
    func downloadedImages()
    func updateToastProgress(_ progress : Float, imageCount : Int)
    func downloadError(_ reason : String)
}

class APIService: NSObject
{
    // MARK: Properties
    private static var service : APIService?
    open var delegates : MulticastDelegate<APIServiceDelegate>?
    public static var totalImageCount : Int?
    
    public static func sharedInstance() -> APIService {
        if self.service == nil { self.service = APIService() }
        return self.service!
    }
    
    override init() {
        delegates = MulticastDelegate()
        super.init()
    }
    
    // MARK: Public Interface
    
    public func getFlickrPhotos(withText text : String, count : Int)
    {
        if Folders.hasGallery(String(text.hash)) {
            self.delegates?.invokeDelegates{ $0.downloadError("Already dowloaded images with this text") }
            return
        }
        
        let url : URL = self.urlFromComponentsWithText(text, count: String(count))
        print("The URL: \(url)")
        self.runDataTask(withUrl: url)
        { (result) in
            
            guard let photosDictionary = result?["photos"] as? [String : AnyObject], let photosArray = photosDictionary["photo"] as? Array<Dictionary<String, AnyObject>> else {
                self.gotAnError(reason: "Did not find the keys in the dictionary")
                return
            }
            
            let newFolder : FlicFolder = FlicFolder(identifier: String(text.hash), name: text)
            APIService.totalImageCount = photosArray.count
            let percent : Float = (1.00 / Float(APIService.totalImageCount!))
            
            var totalPercent : Float = percent
            for photoDic in photosArray
            {
                guard let imageUrlString = photoDic["url_m"] as? String else { self.gotAnError(reason: "Could not find image url string"); return }
                guard let imageTitle = photoDic["title"] as? String else { self.gotAnError(reason: "Could not find image title"); return }
                guard let imageId = photoDic["id"] as? String else { self.gotAnError(reason: "Could not get image ID"); return}
                
                let imageURL = URL(string: imageUrlString)
                if let imageData = try? Data(contentsOf: imageURL!)
                {
                    let newFlic : Flic = Flic(title: imageTitle, data: imageData, identifier: imageId)
                    newFolder.addFlic(newFlic)
                    DispatchQueue.main.sync {
                        self.delegates?.invokeDelegates { $0.updateToastProgress(totalPercent, imageCount: Int(totalPercent/percent)) }
                    }
                    totalPercent += percent
                    
                    if newFolder.flics().count == APIService.totalImageCount {
                        Folders.addFolder(newFolder)
                        DispatchQueue.main.sync { self.delegates?.invokeDelegates { $0.downloadedImages() } }
                    }
                }
                else {
                    self.gotAnError(reason: "Seems that no image exists at this URL!")
                }
            }
        }
    }
    
    // MARK: Private Helpers
    
    private func urlFromComponentsWithText(_ text : String, count : String) -> URL
    {
        var components : URLComponents = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [URLQueryItem]()
        components.queryItems!.append(URLQueryItem(name: "method", value: "flickr.photos.search"))
        components.queryItems!.append(URLQueryItem(name: "api_key", value: Secret.APIKey))
        components.queryItems!.append(URLQueryItem(name: "text", value: text))
        components.queryItems!.append(URLQueryItem(name: "per_page", value: count))
        components.queryItems!.append(URLQueryItem(name: "extras", value: "url_m"))
        components.queryItems!.append(URLQueryItem(name: "safe_search", value: "1"))
        components.queryItems!.append(URLQueryItem(name: "format", value: "json"))
        components.queryItems!.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        
        return (components.url)!
    }
    
    private func gotAnError(reason : String) {
        print(reason)
        DispatchQueue.main.sync { self.delegates?.invokeDelegates { $0.downloadError(reason) } }
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
            guard let status = parsed["stat"] as? String, status == "ok" else {
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
