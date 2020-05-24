//
//  UIViewController+Extension.swift
//  StreamLabsAssignment
//
//  Created by Jude on 16/02/2019.
//  Copyright © 2019 streamlabs. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import ImageIO


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}

extension UIImage {

public class func gifImageWithData(data: NSData) -> UIImage? {
    guard let source = CGImageSourceCreateWithData(data, nil) else {
        print("image doesn't exist")
        return nil
    }

    return UIImage.animatedImageWithSource(source: source)
}

public class func gifImageWithURL(gifUrl:String) -> UIImage? {
    guard let bundleURL = NSURL(string: gifUrl)
        else {
            print("image named \"\(gifUrl)\" doesn't exist")
            return nil
    }
    guard let imageData = NSData(contentsOf: bundleURL as URL) else {
        print("image named \"\(gifUrl)\" into NSData")
        return nil
    }

    return gifImageWithData(data: imageData)
}

public class func gifImageWithName(name: String) -> UIImage? {
    guard let bundleURL = Bundle.main
        .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
    }

//    public class func gifImageWithName(name: String) -> UIImage? {
//    guard let bundleURL =  Bundle.main.path(forResource: "200", ofType:".gif") else {
//            print("SwiftGif: This image named \"\(name)\" does not exist")
//            return nil
//    }
//
    guard let imageData = NSData(contentsOf: bundleURL) else {
        print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
        return nil
    }

    return gifImageWithData(data: imageData)
}

class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
    var delay = 0.1

    let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
    let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)

    var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)

    if delayObject.doubleValue == 0 {
        delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
    }

    delay = delayObject as! Double

    if delay < 0.1 {
        delay = 0.1
    }

    return delay
}

class func gcdForPair(a: Int?, _ b: Int?) -> Int {
    var a = a
    var b = b
    if b == nil || a == nil {
        if b != nil {
            return b!
        } else if a != nil {
            return a!
        } else {
            return 0
        }
    }

    if a! < b! {
        let c = a!
        a = b!
        b = c
    }

    var rest: Int
    while true {
        rest = a! % b!

        if rest == 0 {
            return b!
        } else {
            a = b!
            b = rest
        }
    }
}

class func gcdForArray(array: Array<Int>) -> Int {
    if array.isEmpty {
        return 1
    }

    var gcd = array[0]

    for val in array {
        gcd = UIImage.gcdForPair(a: val, gcd)
    }

    return gcd
}

class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
    let count = CGImageSourceGetCount(source)
    var images = [CGImage]()
    var delays = [Int]()

    for i in 0..<count {
        if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
            images.append(image)
        }

        let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
        delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
    }

    let duration: Int = {
        var sum = 0

        for val: Int in delays {
            sum += val
        }

        return sum
    }()

    let gcd = gcdForArray(array: delays)
    var frames = [UIImage]()

    var frame: UIImage
    var frameCount: Int
    for i in 0..<count {
        frame = UIImage(cgImage: images[Int(i)])
        frameCount = Int(delays[Int(i)] / gcd)

        for _ in 0..<frameCount {
            frames.append(frame)
        }
    }

    let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)

    return animation
}
}


// MARK: - Hiding Back Button

extension UINavigationItem {

    /// A Boolean value that determines whether the back button is hidden.
    ///
    /// When set to `true`, the back button is hidden when this navigation item
    /// is the top item. This is true regardless of the value in the
    /// `leftItemsSupplementBackButton` property. When set to `false`, the back button
    /// is shown if it is still present. (It can be replaced by values in either
    /// the `leftBarButtonItem` or `leftBarButtonItems` properties.) The default value is `false`.
    @IBInspectable var hideBackButton: Bool {
        get { hidesBackButton }
        set { hidesBackButton = newValue }
    }
}


extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


class myButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setColorScheme()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setColorScheme()
       
      //  fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.shadowColor = UIColor.black.cgColor
               self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
               self.layer.shadowRadius = 8
               self.layer.shadowOpacity = 0.5
               self.layer.masksToBounds = false
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 600))
       // self.titleLabel?.font = self.titleLabel?.font(.c)
    }

    private func setColorScheme() {

        self.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 600))
        //UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        self.tintColor = UIColor(red: 3/255, green: 18/255, blue: 8/255, alpha: 1)
        self.setTitleColor( UIColor.white, for: .normal)
        //self.setTitleColor( (UIColor(red: 3/255, green: 18/255, blue: 8/255, alpha: 1)), for: .normal)
    }

//   override func awakeFromNib() {
//      layer.cornerRadius = 4
//      backgroundColor = UIColor(red: 0.75, green: 0.20, blue: 0.19, alpha: 1.0)
//    }

}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}


class myLabel: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    func commonInit(){
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.textColor = UIColor.gray
        self.font = self.font.withSize(24)
        self.textAlignment = NSTextAlignment.center
        self.lineBreakMode = .byWordWrapping
    }
    


}


class postButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setColorScheme()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setColorScheme()
        
       
      //  fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = 20
        //layer.borderWidth = 1
        self.layer.shadowColor = UIColor.black.cgColor
               self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
               self.layer.shadowRadius = 8
               self.layer.shadowOpacity = 0.5
               self.layer.masksToBounds = true
       // self.titleLabel.
      titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        //UIFont.systemFont(ofSize: 5)
    }

    private func setColorScheme() {

        self.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.6705882353, blue: 0.03529411765, alpha: 1).withAlphaComponent(0.2)

      // self.titleLabel!.font = UIFont.systemFont(ofSize: 5, weight: UIFont.Weight(rawValue: 600))
       // self.titleLabel?.adjustsFontSizeToFitWidth = true
      //  self.titleLabel?.font = self.titleLabel?.font.withSize(80)
       // self.titleLabel.font = self.titleLabel?.font.wi
        //UIFont(name: "TwCenMT-CondensedExtraBold", size: 24 )
        self.tintColor = UIColor(red: 3/255, green: 18/255, blue: 8/255, alpha: 1)
        self.setTitleColor( (UIColor(red: 3/255, green: 18/255, blue: 8/255, alpha: 1)), for: .normal)
    }

//   override func awakeFromNib() {
//      layer.cornerRadius = 4
//      backgroundColor = UIColor(red: 0.75, green: 0.20, blue: 0.19, alpha: 1.0)
//    }

}

class postLabel: UILabel {

    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat

    required init() {
        self.topInset = 15
        self.bottomInset = 50
        self.leftInset = 25
        self.rightInset = 25
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}


// MARK: Boilerplate
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}

