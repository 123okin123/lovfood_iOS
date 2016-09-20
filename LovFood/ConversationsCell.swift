//
//  ConversationsCell.swift
//  LovFood
//
//  Created by Nikolai Kratz on 19.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit

class ConversationsCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileimageView: UIImageView! {didSet {
        profileimageView.layer.cornerRadius = 37.5
        }}
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadIndicatorView: UIView! {didSet {
        unreadIndicatorView.layer.cornerRadius = 9
        }}
    
    var conversation: Conversation? {didSet{
        messageLabel.text = conversation!.lastMessage
        if let lastMessagedate = conversation!.lastMessagedate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.mm.yy hh:mm a"
            dateLabel.text = dateFormatter.string(from: lastMessagedate)
            print(lastMessagedate)
            print(dateFormatter.string(from: lastMessagedate))
            
        }
        nameLabel.text = conversation!.allOtherUsers![0]?.userName
        }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
