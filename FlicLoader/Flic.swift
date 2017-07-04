//
//  Flic.swift
//  FlicLoader
//
//  Created by Vince Kearney on 25/06/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import UIKit

class Flic: NSObject
{
    // MARK: Properties
    public var flicTitle : String?
    public var flicData : Data?
    public var flicIdentifier : String?
    
    override init() {
        super.init()
    }
    
    convenience init(title : String, data : Data, identifier : String)
    {
        self.init()
        
        self.flicTitle = title
        self.flicData = data
        self.flicIdentifier = identifier
    }
}
