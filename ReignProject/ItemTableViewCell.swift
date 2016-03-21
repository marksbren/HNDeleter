//
//  ItemTableViewCell.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/18/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation
import UIKit

class ItemTableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Constants.screenSize.width, height: Constants.defaultLineHeight))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.font = Constants.titleFont
        self.addSubview(titleLabel)
        
        subtitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Constants.screenSize.width, height: Constants.defaultLineHeight))
        subtitleLabel.font = Constants.subtitleFont
        subtitleLabel.textColor = UIColor.grayColor()
        self.addSubview(subtitleLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: Constants.kPaddingSmall)
        titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: Constants.kPaddingSmall)
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: Constants.kPaddingSmaller)
        
        
        subtitleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: Constants.kPaddingSmall)
        subtitleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: Constants.kPaddingSmall)
        subtitleLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: Constants.kPaddingSmaller)
        subtitleLabel.autoSetDimension(.Height, toSize: Constants.subtitleLabelHeight)
        subtitleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: Constants.kPaddingSmaller)
        
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layoutIfNeeded()
    }
}
