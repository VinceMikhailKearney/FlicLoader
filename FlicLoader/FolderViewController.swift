//
//  FolderViewController.swift
//  FlicLoader
//
//  Created by Vince Kearney on 05/07/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import UIKit

class FolderViewController: UIViewController
{
    // MARK: Properties
    @IBOutlet weak var imageView : UIImageView!
    public var flics : Array<Flic>?
    private var imagePosition : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.imageView.contentMode = .scaleAspectFit
        self.updateImage(position: imagePosition)
    }
    
    func updateImage(position : Int) {
        self.imageView.image = UIImage(data: ((self.flics?[position])?.flicData)!)
    }
    
    @IBAction func previous(_ sender : UIButton) {
        self.imagePosition -= 1
        if self.imagePosition == -1 { self.imagePosition = (self.flics?.count)! - 1 }
        self.updateImage(position: imagePosition)
    }
    
    @IBAction func next(_ sender : UIButton) {
        self.imagePosition += 1
        if self.imagePosition == self.flics?.count { self.imagePosition = 0 }
        self.updateImage(position: imagePosition)
    }
}
