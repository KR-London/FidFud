//
//  Onboarding2ViewController.swift
//  HappierFoods
//
//  Created by Kate Roberts on 13/07/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//
import UIKit

class Onboarding2ViewController: UINavigationController {
    
    lazy var happy: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "little dude2.png")
        return contentView
    }()
    
    
    lazy var block1: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "9.png")
        return contentView
    }()
    
    lazy var block2: myButton = {
        let button = myButton()
        // button.backgroundColor = UIColor(red: 186/255, green: 242/255, blue: 206/255, alpha: 1)
        // button.tintColor = UIColor().HexToColor(hexString: "#210203", alpha: 1.0)
        button.setTitle("Laughing!", for: .normal)
        // button.titleLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        
        return button
    }()
    
    lazy var block3: myButton = {
        let button = myButton()
        // button.backgroundColor = UIColor(red: 186/255, green: 242/255, blue: 206/255, alpha: 1)
        // button.tintColor = UIColor().HexToColor(hexString: "#210203", alpha: 1.0)
        button.setTitle("Creating!", for: .normal)
        // button.titleLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        
        return button
    }()
    
    lazy var moveOnButton: myButton = {
        let button = myButton()
        // button.backgroundColor = UIColor(red: 186/255, green: 242/255, blue: 206/255, alpha: 1)
        // button.tintColor = UIColor().HexToColor(hexString: "#210203", alpha: 1.0)
        button.setTitle("Winning!", for: .normal)
        // button.titleLabel!.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        
        return button
    }()
    
    override func viewDidLoad() {
        self.navigationBar.isHidden = true
        let margins = view.layoutMarginsGuide
        view.backgroundColor = UIColor(red: 224, green: 250, blue: 233, alpha: 1)
        
        
        view.addSubview(block1)
        block1.translatesAutoresizingMaskIntoConstraints = false
        block1.alpha = 0
        NSLayoutConstraint.activate(
            [
                block1.widthAnchor.constraint(equalTo: margins.widthAnchor),
                block1.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                block1.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 290/545)
            ]
        )
        
        
        
        
        view.addSubview(block2)
        block2.translatesAutoresizingMaskIntoConstraints = false
        block2.alpha = 0
        NSLayoutConstraint.activate(
            [
                block2.widthAnchor.constraint(equalTo: margins.widthAnchor),
                block2.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                block2.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/6 )
            ]
        )
        
        
        
        view.addSubview(block3)
        block3.translatesAutoresizingMaskIntoConstraints = false
        block3.alpha = 0
        NSLayoutConstraint.activate(
            [
                block3.widthAnchor.constraint(equalTo: margins.widthAnchor),
                block3.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                block3.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/6 )
            ]
        )
        
        view.addSubview(happy)
        // view.sendSubviewToBack(happy)
        happy.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                happy.centerYAnchor.constraint(equalTo: block2.bottomAnchor, constant: 0),
                happy.trailingAnchor.constraint(equalTo: block1.trailingAnchor, constant: 40),
                happy.heightAnchor.constraint(equalToConstant: 120),
                happy.widthAnchor.constraint(equalToConstant: 120),
            ]
        )
        
        
        self.view.addSubview(moveOnButton)
        moveOnButton.translatesAutoresizingMaskIntoConstraints = false
        moveOnButton.addTarget(self, action: #selector(winning), for: .touchUpInside)
        moveOnButton.alpha = 0
        NSLayoutConstraint.activate(
            [
                // moveOnButton.topAnchor.constraint(equalTo: block3.bottomAnchor),
                moveOnButton.widthAnchor.constraint(equalTo: margins.widthAnchor),
                moveOnButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                moveOnButton.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/6 )
            ]
        )
        
        
        
        // block3.bringSubviewToFront(view)
        let ratio: CGFloat = (290*2 + 227 + (self.view.frame.width/6))/545
        let contentSize = self.view.frame.width*ratio
        let spacer = ( self.view.frame.height - contentSize )/5
        print("spacer 2 = ", spacer)
        
        NSLayoutConstraint.activate(
            [
                block1.topAnchor.constraint(lessThanOrEqualTo: margins.topAnchor, constant:spacer),
                block2.topAnchor.constraint(lessThanOrEqualTo: block1.bottomAnchor, constant:spacer),
                block3.topAnchor.constraint(lessThanOrEqualTo: block2.bottomAnchor, constant: spacer),
                moveOnButton.topAnchor.constraint(lessThanOrEqualTo: block3.bottomAnchor, constant:spacer),
                //   moveOnButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -40)
            ]
        )
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
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
                self.block3.alpha = 1
            }
            animator.startAnimation()
        }
        
        /// fade it in & out with RH picture
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)){
            let animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut) {
                self.moveOnButton.alpha = 1
            }
            animator.startAnimation()
        }
    }
    
    
    @objc func winning(sender: UIButton!) {
        performSegue(withIdentifier: "winning", sender: self)
    }
    
}
