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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.flicFolders = Folders.list ?? [FlicFolder]()
        self.table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFlicFolder" {
            (segue.destination as? FolderViewController)?.flics = sender as? Array<Flic>
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
        self.performSegue(withIdentifier: "showFlicFolder", sender: (self.flicFolders?[indexPath.row])?.flics())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
