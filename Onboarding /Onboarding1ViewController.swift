//
//  Onboarding1ViewController.swift
//  FudFid
//
//  Created by Kate Roberts on 29/07/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//
import UIKit

class Onboarding1ViewController: UIViewController {
    
//    lazy var happy: UIImageView = {
//        
//        let contentView = UIImageView()
//        contentView.image = UIImage(named: "little dude1.png")
//        
//        return contentView
//    }()
//    
//    lazy var block1: UIImageView = {
//        
//        let contentView = UIImageView()
//        contentView.image = UIImage(named: "1.png")
//        
//        return contentView
//    }()
//    
//    lazy var block2: UIImageView = {
//        
//        let contentView = UIImageView()
//        contentView.image = UIImage(named: "1 2.png")
//        
//        return contentView
//    }()
//    
//    lazy var block3: UIImageView = {
//        
//        let contentView = UIImageView()
//        contentView.image = UIImage(named: "11.png")
//        
//        return contentView
//    }()
//    
//    lazy var moveOnButton: myButton = {
//        
//        let button = myButton()
//        button.setTitle("I'll give it a go!'", for: .normal)
//
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        
//        let margins = view.layoutMarginsGuide
//        
//        view.backgroundColor = UIColor(red: 224, green: 250, blue: 233, alpha: 1)
//        //view.head
//        
//        view.addSubview(block1)
//        block1.translatesAutoresizingMaskIntoConstraints = false
//        block1.alpha = 0
//        NSLayoutConstraint.activate(
//            [
//                block1.widthAnchor.constraint(equalTo: margins.widthAnchor),
//                block1.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
//                block1.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 78/545)
//            ]
//        )
//        
//        view.addSubview(happy)
//        happy.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate(
//            [
//                happy.topAnchor.constraint(greaterThanOrEqualTo: margins.topAnchor),
//                happy.trailingAnchor.constraint(equalTo: block1.trailingAnchor),
//                happy.heightAnchor.constraint(equalToConstant: 150),
//                happy.widthAnchor.constraint(equalToConstant: 150),
//            ]
//        )
//        
//        view.addSubview(block2)
//        block2.translatesAutoresizingMaskIntoConstraints = false
//        block2.alpha = 0
//        NSLayoutConstraint.activate(
//            [
//                block2.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
//                block2.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 163/545),
//                block2.widthAnchor.constraint(equalTo: margins.widthAnchor),
//            ]
//        )
//        
//        view.addSubview(block3)
//        block3.translatesAutoresizingMaskIntoConstraints = false
//        block3.alpha = 0
//        NSLayoutConstraint.activate(
//            [
//                block3.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
//                block3.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 375/545),
//                block3.widthAnchor.constraint(equalTo: margins.widthAnchor)
//            ]
//        )
//        
//        self.view.addSubview(moveOnButton)
//        moveOnButton.translatesAutoresizingMaskIntoConstraints = false
//        moveOnButton.addTarget(self, action: #selector(goOn), for: .touchUpInside)
//        moveOnButton.alpha = 0
//        NSLayoutConstraint.activate(
//            [
//                moveOnButton.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
//                moveOnButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.9),
//                moveOnButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
//                moveOnButton.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 1/6 )
//            ]
//        )
//        
//        var ratio: CGFloat = (375 + 163 + 78 + (self.view.frame.width/6) )
//        ratio = ratio/545
//        let contentSize = self.view.frame.width*ratio
//        let spacer = ( self.view.frame.height - contentSize )/5
//        
//        NSLayoutConstraint.activate(
//            [
//                block1.topAnchor.constraint(lessThanOrEqualTo: margins.topAnchor, constant:spacer),
//                block2.topAnchor.constraint(lessThanOrEqualTo: block1.bottomAnchor, constant:spacer),
//                block3.topAnchor.constraint(lessThanOrEqualTo: block2.bottomAnchor, constant:spacer),
//                moveOnButton.topAnchor.constraint(lessThanOrEqualTo: block3.bottomAnchor, constant:spacer),
//                moveOnButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -40)
//            ]
//        )
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)){
//            let animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut) {
//                self.block1.alpha = 1
//            }
//            animator.startAnimation()
//        }
//        
//        /// fade it in & out with RH picture
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
//            let animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut) {
//                self.block2.alpha = 1
//            }
//            animator.startAnimation()
//        }
//        
//        /// fade it in & out with RH picture
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)){
//            let animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut) {
//                self.block3.alpha = 1
//            }
//            animator.startAnimation()
//        }
//        
//        /// fade it in & out with RH picture
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)){
//            let animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut) {
//                self.moveOnButton.alpha = 1
//            }
//            animator.startAnimation()
//        }
//    }
//    
//    
//    @objc func goOn(sender: UIButton!) {
//        performSegue(withIdentifier: "o1-o2", sender: self)
//    }
}
