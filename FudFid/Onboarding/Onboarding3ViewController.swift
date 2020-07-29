//
//  Onboarding3ViewController.swift
//  HappierFoods
//
//  Created by Kate Roberts on 13/07/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import UIKit

class Onboarding3ViewController: UINavigationController {
    
    lazy var happy: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "little dude6.png")
        return contentView
    }()
    
    lazy var block1: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "10.png")
        return contentView
    }()
    
    lazy var shakeMe: UIButton = {
        let contentView = UIButton()
        contentView.setImage(UIImage(named: "text 3 2.png"), for: .normal)
        return contentView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
        let margins = view.layoutMarginsGuide
               view.backgroundColor = UIColor(red: 224, green: 250, blue: 233, alpha: 1)
        view.addSubview(block1)
        block1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                block1.widthAnchor.constraint(equalTo: margins.widthAnchor),
                block1.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                block1.heightAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 522/545),
                block1.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -100)
            ]
        )
        
        view.addSubview(happy)
        happy.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                happy.centerYAnchor.constraint(equalTo: block1.bottomAnchor),
                happy.trailingAnchor.constraint(equalTo: block1.trailingAnchor),
                happy.heightAnchor.constraint(equalToConstant: 150),
                happy.widthAnchor.constraint(equalToConstant: 150),
            ]
        )
        
        view.addSubview(shakeMe)
        shakeMe.translatesAutoresizingMaskIntoConstraints = false
        shakeMe.alpha = 0
        NSLayoutConstraint.activate(
            [
                shakeMe.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.8),
                shakeMe.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
                shakeMe.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -50),
                shakeMe.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.2),
            ]
        )
        
    
        /// fade it in & out with RH picture
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            self.startAnimate(text: self.shakeMe)
            let animator = UIViewPropertyAnimator(duration: 6, curve: .easeOut) {
                self.shakeMe.alpha = 1
            }
            animator.startAnimation()
       
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)){
            self.performSegue(withIdentifier: "o3-o4", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopAnimate(text: shakeMe)
    }
    
    
    func startAnimate(text: UIButton) {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = text.layer
        layer.add(shakeAnimation, forKey:"animate")
        
    }
    
    func stopAnimate(text: UIButton) {
        let layer: CALayer = text.layer
        layer.removeAnimation(forKey: "animate")
    }

    

}


    func startAnimate(text: UIButton) {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = text.layer
        layer.add(shakeAnimation, forKey:"animate")
        
    }
    
    func stopAnimate(text: UIButton) {
        let layer: CALayer = text.layer
        layer.removeAnimation(forKey: "animate")
    }

