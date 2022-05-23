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
    
    // Initialising database
    let db=Firestore.firestore()
    
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
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    @IBAction func sendPressed(_ sender: UIButton)
    {
        if let messageBody=messageTextfield.text,let messageSender=Auth.auth().currentUser?.email
        {
            // Sends data to database
            db.collection(K.FStore.collectionName).addDocument(data:[K.FStore.senderField:messageSender,
                                                                     
                                                                     K.FStore.bodyField: messageBody]){(error) in
                if let e=error
                {
                    print("An error occurred while sending data!\(e)")
                }
                else
                {
                    print("Data sent successfully!")
                }
            }
        }
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

//MARK: - Extending ChatViewController to adapt UITableViewDataSource protocol
extension ChatViewController: UITableViewDataSource
{
    // Method used for creating rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return message.count
    }
    
    // Method used for population data into created rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell=tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        cell.label.text=message[indexPath.row].body
        return cell
    }
    
}
