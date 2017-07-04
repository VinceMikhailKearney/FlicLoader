//
//  DownloadsViewController.swift
//  FlicLoader
//
//  Created by Vince Kearney on 21/06/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import UIKit

class DownloadsViewController: UIViewController
{
    // MARK: Properties
    @IBOutlet weak var imageView : UIImageView!
    private var flicFolder : Array<Flic>?
    private var imagePosition : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imageView.contentMode = .scaleAspectFit
        self.flicFolder = (Folders.list?[0])?.flics()
        if self.flicFolder != nil {
            self.updateImage(position: imagePosition)
        }
    }
    
    func updateImage(position : Int) {
        self.imageView.image = UIImage(data: ((self.flicFolder?[position])?.flicData)!)
    }
    
    @IBAction func previous(_ sender : UIButton) {
        self.imagePosition -= 1
        if self.imagePosition == -1 { self.imagePosition = (self.flicFolder?.count)! - 1 }
        self.updateImage(position: imagePosition)
    }
    
    @IBAction func next(_ sender : UIButton) {
        self.imagePosition += 1
        if self.imagePosition == self.flicFolder?.count { self.imagePosition = 0 }
        self.updateImage(position: imagePosition)
    }
}
