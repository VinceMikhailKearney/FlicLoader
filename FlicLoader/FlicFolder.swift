//
//  FlicFolder.swift
//  FlicLoader
//
//  Created by Vince Kearney on 25/06/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import UIKit

class FlicFolder: NSObject
{
    // MARK: Properties
    public var name : String
    public var identifier : String
    public var imageCount : Int
    public var flicList : Array<Flic>
    
    override init()
    {
        self.name = ""
        self.identifier = ""
        self.imageCount = 0
        self.flicList = Array<Flic>()
        
        super.init()
    }
    
    convenience init(identifier : String)
    {
        self.init()
        self.identifier = identifier
    }
    
    public func flics() -> Array<Flic> {
        return self.flicList
    }
    
    public func addFlic(_ flic : Flic) {
        if !(self.flicList.contains { $0.flicIdentifier == flic.flicIdentifier })
            { self.flicList.append(flic) }
    }
}
