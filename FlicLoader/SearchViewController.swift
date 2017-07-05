//
//  ViewController.swift
//  FlicLoader
//
//  Created by Vince Kearney on 21/06/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import UIKit

extension String {
    public func stripWhitespace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

class SearchViewController: UIViewController, APIServiceDelegate
{
    // MARK: Properties
    @IBOutlet weak var downloadButton : UIButton!
    @IBOutlet weak var slider : UISlider!
    @IBOutlet weak var sliderCountLabel : UILabel!
    @IBOutlet weak var textField : UITextField!
    private var progressHud : MBProgressHUD?
    
    // MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.sliderCountLabel.text = String(Int(self.slider.value))
        self.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        self.downloadButton.layer.cornerRadius = 10
        self.textField!.text = "Titanfall, BT"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIService.sharedInstance().delegates?.addDelegate(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        APIService.sharedInstance().delegates?.removeDelegate(self)
    }
    
    // MARK: Helpers
    
    func sliderValueChanged() {
        self.sliderCountLabel.text = String(Int(self.slider.value))
    }
    
    func displayDownloadingImagesToast() {
        self.progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.progressHud?.mode = .annularDeterminate
        self.progressHud?.label.text = "Downloading Images"
        self.progressHud?.detailsLabel.text = "0/\(Int(self.slider.value))"
    }
    
    func showToast(_ text : String)
    {
        let hud : MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.label.numberOfLines = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {  MBProgressHUD.hide(for: self.view, animated: true) }
    }
    
    // MARK: Actions
    
    @IBAction func downloadImages()
    {
        guard (self.textField.text?.characters.count)! > 0 else { self.showToast("No ID Entered"); return }
        
        self.textField.resignFirstResponder()
        self.view.isUserInteractionEnabled = false
        self.displayDownloadingImagesToast()
        APIService.sharedInstance().getFlickrPhotos(withText: self.textField.text!.stripWhitespace(), count: Int(self.slider.value))
    }
    
    // MARK: APIServiceDelegate Methods
    
    func downloadedImages() {
        self.view.isUserInteractionEnabled = true
        MBProgressHUD.hide(for: self.view, animated: true)
        self.showToast("Images have been downloaded")
    }
    
    func downloadError(_ reason: String) {
        self.view.isUserInteractionEnabled = true
        MBProgressHUD.hide(for: self.view, animated: true)
        self.showToast(reason)
    }
    
    func updateToastProgress(_ progress: Float, imageCount: Int) {
        progressHud?.progress = progress
        progressHud?.detailsLabel.text = "\(imageCount)/\(APIService.totalImageCount ?? 0)"
    }
}

