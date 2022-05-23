//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var message: [Message] =
    [
        Message(sender: "1@2.com", body:"Hey!"),
        Message(sender: "a@b.com", body: "Hello"),
        Message(sender: "1@2.com", body: "What's up")
        
    ]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource=self
        title=K.appName
        navigationItem.hidesBackButton=true
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton)
    {
        
    }
    
    @IBAction func LogoutPressed(_ sender: UIBarButtonItem)
    {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
}

extension ChatViewController: UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return message.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        cell.textLabel?.text=message[indexPath.row].body
        return cell
        
    }
    
    
}
