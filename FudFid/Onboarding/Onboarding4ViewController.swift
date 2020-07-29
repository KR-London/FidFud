//
//  Onboarding4ViewController.swift
//  HappierFoods
//
//  Created by Kate Roberts on 13/07/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class Onboarding4ViewController: UINavigationController {
    
    lazy var happy: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "little dude3.png")
        return contentView
    }()

    lazy var block1: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "5.png")
        return contentView
    }()
    
    
    lazy var b1: myButton = {
        let button = myButton()
       // button.backgroundColor = UIColor(red: 95/255, green: 215/255, blue: 176/255, alpha: 1)
          //  R95 G215 B176  )
       // button.tintColor = UIColor().HexToColor(hexString: "#210203", alpha: 1.0)
        button.setTitle("Try Food", for: .normal)
       // button.titleLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        return button
    }()
    
    lazy var b2: myButton = {
        let button = myButton()
         // button.backgroundColor = UIColor(red: 95/255, green: 215/255, blue: 176/255, alpha: 1)
       // button.tintColor = UIColor().HexToColor(hexString: "#210203", alpha: 1.0)
        button.setTitle("Not Eating Now", for: .normal)
       // button.titleLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        return button
    }()
    
    
    
    lazy var block2: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "6.png")
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
                block1.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 163/545)
            ]
        )
        
        view.addSubview(happy)
        happy.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                happy.topAnchor.constraint(equalTo: block1.bottomAnchor),
                happy.trailingAnchor.constraint(equalTo: block1.trailingAnchor),
                happy.heightAnchor.constraint(equalToConstant: 150),
                happy.widthAnchor.constraint(equalToConstant: 150),
            ]
        )
        
        self.view.addSubview(b1)
        b1.translatesAutoresizingMaskIntoConstraints = false
        b1.addTarget(self, action: #selector(trying), for: .touchUpInside)
        b1.alpha = 0
        NSLayoutConstraint.activate(
            [
                b1.topAnchor.constraint(equalTo: block1.bottomAnchor, constant: 100),
                b1.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.45),
                b1.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
                b1.leadingAnchor.constraint(equalTo: margins.leadingAnchor , constant: 5),
                b1.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.2)
            ]
        )
        
        self.view.addSubview(b2)
        b2.translatesAutoresizingMaskIntoConstraints = false
        b2.addTarget(self, action: #selector(noTry), for: .touchUpInside)
        b2.alpha = 0
        NSLayoutConstraint.activate(
            [
                b2.topAnchor.constraint(equalTo: block1.bottomAnchor, constant: 100),
                b2.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.45),
                b2.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
                b2.trailingAnchor.constraint(equalTo: margins.trailingAnchor , constant: -5),
                b2.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.2)
            ]
        )
        
        
        
        view.addSubview(block2)
        block2.translatesAutoresizingMaskIntoConstraints = false
        block2.alpha = 0
        NSLayoutConstraint.activate(
            [
                block2.topAnchor.constraint(equalTo: b1.bottomAnchor, constant: 100),
                block2.widthAnchor.constraint(equalTo: margins.widthAnchor),
                block2.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                block2.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 163/545)
            ]
        )
        
        /// fade it in & out with RH picture
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)){
            let animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut) {
                self.block1.alpha = 1
            }
            animator.startAnimation()
        }
        
        /// fade it in & out with RH picture
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            let animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut) {
                self.block2.alpha = 1
            }
            animator.startAnimation()
        }
        
        
        /// fade it in & out with RH picture
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
            let animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut) {
                self.b1.alpha = 1
                self.b2.alpha = 1
            }
            animator.startAnimation()
        }
        
        
    }
    
    @objc func trying(sender: UIButton!) {
        performSegue(withIdentifier: "try", sender: self)
    }
    
    
    @objc func noTry(sender: UIButton!) {
        performSegue(withIdentifier: "noTry", sender: self)
    }
    
}
