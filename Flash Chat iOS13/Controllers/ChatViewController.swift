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
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource=self
        title=K.appName
        navigationItem.hidesBackButton=true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessage()
    }
    func loadMessage()
    {
        
        db.collection(K.FStore.collectionName).order(by:K.FStore.dateField).addSnapshotListener { querySnapshot, error in
            self.message=[]
            if let error=error
            {
                print("An error occurred while retriving data:\(error)")
            }
            else
            {
                if let snapshotDocuments=querySnapshot?.documents
                {
                    for doc in snapshotDocuments
                    {
                        let data=doc.data()
                        if let messageSender=data[K.FStore.senderField] as? String, let messageBody=data[K.FStore.bodyField] as? String
                        {
                            let newMessage=Message(sender: messageSender, body: messageBody)
                            self.message.append(newMessage)
                            
                            DispatchQueue.main.async
                            {
                                self.tableView.reloadData()
                                let indexPath=IndexPath(row: self.message.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton)
    {
        if let messageBody=messageTextfield.text,let messageSender=Auth.auth().currentUser?.email
        {
            // Sends data to database
            
            db.collection(K.FStore.collectionName).addDocument(data:[K.FStore.senderField:messageSender,
                                                                     
                                                                     K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970]){(error) in
                if let e=error
                {
                    print("An error occurred while sending data!\(e)")
                }
                else
                {
                    print("Data sent successfully!")
                    DispatchQueue.main.async
                    {
                        self.messageTextfield.text=""
                    }
                    
                }
            }
        }
    }
    //MARK: - Logging out user
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
        let message=message[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        cell.label.text=message.body
        
        // This is a message from current user
        if message.sender == Auth.auth().currentUser?.email
        {
            cell.leftImageView.isHidden=true
            cell.rightImageView.isHidden=false
            cell.messageBubble.backgroundColor=UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor=UIColor(named: K.BrandColors.purple)
        }
        else
        {
            cell.leftImageView.isHidden=false
            cell.rightImageView.isHidden=true
            cell.messageBubble.backgroundColor=UIColor(named: K.BrandColors.purple)
            cell.label.textColor=UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
}
