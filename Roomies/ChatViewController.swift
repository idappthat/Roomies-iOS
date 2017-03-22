//
//  ChatViewController.swift
//  Roomies
//
//  Created by Cameron Moreau on 10/28/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    
    var ref: FIRDatabaseReference!
    let localGroup = (UIApplication.shared.delegate as! AppDelegate).localGroup!
    
    var messages = [JSQMessage]()
    
    let factory = JSQMessagesBubbleImageFactory()
    
    var outBubble: JSQMessagesBubbleImage!
    var inBubble: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BaseViewControllerUtil.setup(viewController: self)
        
        self.ref = FIRDatabase.database().reference()
        //self.ref.queryLimited(toLast: <#T##UInt#>)
        
        //self.edgesForExtendedLayout = []
        self.senderId = "self"
        self.senderDisplayName = "test"
        
        self.outBubble = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        self.inBubble = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return self.outBubble
        } else {
            return self.inBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        print(text)
        
        let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text)
        messages.append(message!)
        
        sendMessage(text: text, sender: self.senderId)
        
        self.finishSendingMessage(animated: true)
    }
    
    // MARK: - Utils
    func sendMessage(text: String, sender: String) {
        ref.child("groups/\(localGroup.id)/messages").childByAutoId().setValue([
            "text": text,
            "sender": sender
            ])
        print("SENDING WITH GROUP \(localGroup.id)")
    }
}
