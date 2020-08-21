//
//  systemImageButton.swift
//  FudFid
//
//  Created by Kate Roberts on 25/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit

class SystemImageButton: UIButton {

       // var myValue: Int

        required init(value: Int = 0) {
            // set myValue before super.init is called
          //  self.myValue = value

            super.init(frame: .zero)
            
            tintColor = .black
            
          
            if #available(iOS 13.0, *) {
                imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(weight: .black).applying(UIImage.SymbolConfiguration(scale: .large))
            } else {
                //FIXME: iOS12 button format
            }
            
            
            contentMode = .scaleAspectFill
            // set other operations after super.init, if required
            
            if #available(iOS 13.0, *) {
                layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
            } else {
                 //FIXME: iOS12 button format
               // layer.borderColor = UIColor.cl
            }
            
            layer.cornerRadius = 5.0
           // black
            layer.borderWidth = 1.0
            
            if #available(iOS 13.0, *) {
                layer.shadowColor = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)
            } else {
                 //FIXME: iOS12 button format
                // Fallback on earlier versions
            }
          
           // backgroundColor = .lightGray
            titleLabel?.adjustsFontSizeToFitWidth = true
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
