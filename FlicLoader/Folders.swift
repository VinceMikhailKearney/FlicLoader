//
//  Folders.swift
//  FlicLoader
//
//  Created by Vince Kearney on 25/06/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import UIKit

class Folders: NSObject
{
    public static var list : Array<FlicFolder>?
    
    public static func addFolder(_ folder : FlicFolder)
    {
        if self.list == nil { self.list = Array<FlicFolder>() }
        
        if !(self.hasGallery(folder.identifier)) {
            self.list?.append(folder)
        }
    }
    
    public static func hasGallery(_ identifier : String) -> Bool {
        guard self.list != nil else { return false }
        return self.list!.contains { $0.identifier == identifier }
    }
    
    public static func getGallery(withId id : String) -> FlicFolder?
    {
        guard self.list != nil else { return nil }
        
        var filtered = Array<FlicFolder>()
        filtered = self.list!.filter { $0.identifier == id }
        if filtered.count == 1 {
            return filtered.first!
        }
        
        return nil
    }
}
