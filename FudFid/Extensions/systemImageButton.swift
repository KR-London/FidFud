//
//  systemImageButton.swift
//  FudFid
//
//  Created by Kate Roberts on 25/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit

class systemImageButton: UIButton {

       // var myValue: Int

        required init(value: Int = 0) {
            // set myValue before super.init is called
          //  self.myValue = value

            super.init(frame: .zero)
            
            tintColor = .black
            imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
            contentMode = .scaleAspectFit
            // set other operations after super.init, if required
            layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0)
           // black
            layer.borderWidth = 5.0
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
