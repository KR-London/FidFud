//
//  Onboarding5ViewController.swift
//  HappierFoods
//
//  Created by Kate Roberts on 13/07/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class Onboarding5ViewController: UINavigationController {

    lazy var block1: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "areYouReady1.jpg")
        return contentView
    }()
    
    
    lazy var b1: myButton = {
        let button = myButton()
        //button.backgroundColor = UIColor().HexToColor(hexString: "#C17767", alpha: 1.0)
       // button.tintColor = UIColor().HexToColor(hexString: "#210203", alpha: 1.0)
        button.setTitle("Cheese", for: .normal)
        //button.titleLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        return button
    }()
    
    lazy var b2: myButton = {
        let button = myButton()
        //button.backgroundColor = UIColor().HexToColor(hexString: "#C17767", alpha: 1.0)
      //  button.tintColor = UIColor().HexToColor(hexString: "#210203", alpha: 1.0)
        button.setTitle("Brown Bread", for: .normal)
       // button.titleLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        return button
    }()
    
    
    
    lazy var block2: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "areYouReady2.jpg")
        return contentView
    }()
    
    
    override func viewDidLoad() {
         view.backgroundColor = UIColor(red: 224, green: 250, blue: 233, alpha: 1)
         self.navigationBar.isHidden = true
        let margins = view.layoutMarginsGuide
        view.addSubview(block1)
        block1.translatesAutoresizingMaskIntoConstraints = false
        block1.alpha = 0
        NSLayoutConstraint.activate(
            [
                //block1.topAnchor.constraint(equalTo: self.view.topAnchor),
                block1.widthAnchor.constraint(equalTo: margins.widthAnchor),
                block1.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                block1.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25)
            ]
        )
        
        self.view.addSubview(b1)
        b1.translatesAutoresizingMaskIntoConstraints = false
        b1.addTarget(self, action: #selector(trying), for: .touchUpInside)
        b1.alpha = 0
        NSLayoutConstraint.activate(
            [
                b1.topAnchor.constraint(equalTo: block1.bottomAnchor, constant: 20),
                b1.widthAnchor.constraint(equalTo: b1.heightAnchor),
                b1.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
                b1.leadingAnchor.constraint(equalTo: margins.leadingAnchor , constant: 20),
                b1.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.2)
            ]
        )
        
        self.view.addSubview(b2)
        b2.translatesAutoresizingMaskIntoConstraints = false
        b2.addTarget(self, action: #selector(noTry), for: .touchUpInside)
        b2.alpha = 0
        NSLayoutConstraint.activate(
            [
                b2.topAnchor.constraint(equalTo: block1.bottomAnchor, constant: 20),
                b2.widthAnchor.constraint(equalTo: b2.heightAnchor),
                b2.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
                b2.leadingAnchor.constraint(equalTo: margins.leadingAnchor , constant: 20),
                b2.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.2)
            ]
        )
        

        
        view.addSubview(block2)
        block2.translatesAutoresizingMaskIntoConstraints = false
        block2.alpha = 0
        NSLayoutConstraint.activate(
            [
                block2.topAnchor.constraint(equalTo: b1.bottomAnchor, constant: 20),
                block2.widthAnchor.constraint(equalTo: margins.widthAnchor),
                block2.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                block2.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25)
            ]
        )
        


}
    
    @objc func trying(sender: UIButton!) {
        performSegue(withIdentifier: "try", sender: self)
    }
    
    
    @objc func noTry(sender: UIButton!) {
        performSegue(withIdentifier: "noTry", sender: self)
    }
}
