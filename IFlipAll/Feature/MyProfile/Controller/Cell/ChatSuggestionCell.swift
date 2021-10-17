//
//  ChatSuggestionCell.swift
//  IFlipAll
//
//  Created by devangs.bhatt on 20/06/21.
//  Copyright © 2021 StarkTechnolabs. All rights reserved.
//

import UIKit

class ChatSuggestionCell: UICollectionViewCell {
    @IBOutlet weak var lblSuggestedMessage: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 5.0
    }

    
    func prepareCell(suggestedMessage: String) {
        lblSuggestedMessage.text = suggestedMessage
    }
}
