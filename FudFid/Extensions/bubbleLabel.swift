//
//  bubbleLabel.swift
//  FudFid
//
//  Created by Kate Roberts on 25/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit

class bubbleLabel: UILabel {

       required init(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)!
        
           self.setup()
       }


       override init(frame: CGRect){
           super.init(frame: frame)
           self.setup()
       }

       override func awakeFromNib() {
           super.awakeFromNib()
           self.setup()
       }

       func setup(){
           self.text = self.text
           self.textColor = self.textColor
           self.font = self.font
           self.layer.display()
       }

        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            super.drawText(in: rect.inset(by: insets))
        }
    }

    class onboardingLabel: UILabel {

       required init(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)!
           self.setup()
       }


       override init(frame: CGRect){
           super.init(frame: frame)
           self.setup()
       }

       override func awakeFromNib() {
           super.awakeFromNib()
           self.setup()
       }

       func setup(){
            
            self.textColor = UIColor(red: 95/255, green: 215/255, blue: 176/255, alpha: 1)
            self.font = self.font
            self.layer.display()
            self.lineBreakMode = .byWordWrapping
            self.numberOfLines = 3
        self.text = self.text
       }

        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            super.drawText(in: rect.inset(by: insets))
        }
    }
