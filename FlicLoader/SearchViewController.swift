//
//  ViewController.swift
//  FlicLoader
//
//  Created by Vince Kearney on 21/06/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController
{
    // MARK: Properties
    @IBOutlet weak var downloadButton : UIButton!
    @IBOutlet weak var slider : UISlider!
    @IBOutlet weak var sliderCountLabel : UILabel!
    @IBOutlet weak var textField : UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.sliderCountLabel.text = String(Int(self.slider.value))
        self.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        self.downloadButton.layer.cornerRadius = 10
    }
    
    // MARK: Helpers
    func sliderValueChanged() {
        self.sliderCountLabel.text = String(Int(self.slider.value))
    }
}

