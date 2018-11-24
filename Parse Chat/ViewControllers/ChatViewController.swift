//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Allen Lozano on 11/21/18.
//  Copyright © 2018 Allen Lozano. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    var chatMessages: [PFObject] = []
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        
        chatTableView.delegate = self as UITableViewDelegate
        chatTableView.dataSource = self as UITableViewDataSource
        // Auto size row height based on cell autolayout constraints
        chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.estimatedRowHeight = 50
        retrieveChatMessages()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.retrieveChatMessages), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSend(_ sender: UIButton) {
        
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageTextField.text ?? ""
        chatMessage["user"] = PFUser.current() // sets user name
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let chatMessage = chatMessages[indexPath.row]
        
        cell.chatLabel.text = chatMessage["text"] as? String
        
        // Sets the username
        if let user = chatMessage["user"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "🤖"
        }
        return cell
    }
    @objc func retrieveChatMessages() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("user")
        query.findObjectsInBackground { (messages, error) in
            if let messages = messages {
                self.chatMessages =  messages
                self.chatTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    @IBAction func logoutSegue(_ sender: UIButton) {
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        retrieveChatMessages()
    }
    
}
