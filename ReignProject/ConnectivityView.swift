//
//  ConnectivityView.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/20/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation
import UIKit

class MBConnectivityView: UIView {
    var label: UILabel!
    var viewHeightConstraint: NSLayoutConstraint!
    var yValue: CGFloat!
    
    convenience init(yVal: CGFloat = 0.0){
        let frame = CGRectMake(0.0, yVal, Constants.screenSize.width, 0.0)
        self.init(frame: frame)
        
        yValue = yVal
        
        label = UILabel(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        self.clipsToBounds = true
        label.text = "No Internet Connection"
        label.textColor = UIColor.whiteColor()
        self.addSubview(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.autoAlignAxisToSuperviewAxis(.Horizontal)
        label.autoAlignAxisToSuperviewAxis(.Vertical)
        
        self.autoPinEdgeToSuperviewEdge(.Top, withInset: yValue)
        self.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        self.autoSetDimension(.Width, toSize: Constants.screenSize.width)
        
        guard viewHeightConstraint == nil else {return}
        self.viewHeightConstraint = self.autoSetDimension(.Height, toSize: 0.0)
    }
    
    func isReadyToDisplay() -> Bool {
        guard viewHeightConstraint != nil else {return false}
        return true
    }
    
    func animateIn(delay: Double = 0.3, closure: () -> Void){
        print("animating connectivityView")
        if self.viewHeightConstraint != nil {
            self.viewHeightConstraint.constant = 44.0
            UIView.animateWithDuration(1, delay: delay, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                self.layoutIfNeeded()
                }, completion: { (success) -> Void in
                    self.viewHeightConstraint.constant = 0.0
                    UIView.animateWithDuration(1, delay: 1.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                        self.layoutIfNeeded()
                        }, completion: { (success) -> Void in
                            closure()
                    })
            })
        }
    }
}