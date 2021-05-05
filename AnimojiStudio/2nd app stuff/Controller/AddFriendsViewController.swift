//
//  AddFriendsViewController.swift
//  AnimojiStudio
//
//  Created by Snehal Mulchandani on 5/5/21.
//  Copyright © 2021 Guilherme Rambo. All rights reserved.
//
import Foundation
import UIKit
import Contacts

class AddFriendsViewController: UITableViewController, addFriendsTableView {
    func refreshList() {
        self.tableView.reloadData()
    }
    
    var FriendsServiceDelegate: FirestoreAddFriendsDelegate!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        FriendsServiceDelegate = FirebaseFriendsService() //weak...
        FriendsServiceDelegate.VC = self
        FriendsServiceDelegate.askForContactAccess()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar(animated: animated)
        self.navigationItem.title = "Tap to add Friends"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = "Sonder"
        self.hideNavigationBar(animated: animated)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendsServiceDelegate.FirebaseUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = FriendsServiceDelegate.FirebaseUsers[indexPath.row].name
        cell.detailTextLabel?.text = FriendsServiceDelegate.FirebaseUsers[indexPath.row].telephone
        cell.imageView?.image = try! UIImage(data: NSData(contentsOf: URL(string: FriendsServiceDelegate.FirebaseUsers[indexPath.row].bitmojiURL)!) as Data)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FriendsServiceDelegate.addFriend(position: indexPath.row)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol addFriendsTableView{
    func refreshList()
}
