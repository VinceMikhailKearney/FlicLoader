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
    @IBOutlet weak var table : UITableView!
    fileprivate var flicFolders : Array<FlicFolder>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        self.flicFolders = Folders.list!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFlicFolder" {
            // Need to set up a new view controller and link to here.
        }
    }
}

extension DownloadsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.flicFolders?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = (self.flicFolders?[indexPath.row])?.name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("The table cell name: \((self.flicFolders?[indexPath.row])?.name ?? "No name")")
    }
}

/** 
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
 */
