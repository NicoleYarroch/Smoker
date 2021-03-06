//
//  Artworks.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import Foundation
import SmartDeviceLink

class Artworks {
    static var randomSolidColor: SDLArtwork {
        return SDLArtwork(image: UIImage.randomSolidColor(), persistent: false, as: .JPG)
    }

    static func randomSolidColor(width: Int = 100, height: Int = 100) -> SDLArtwork {
        return SDLArtwork(image: UIImage.randomSolidColor(width: width, height: height), persistent: false, as: .JPG)
    }
}

extension UIImage {
    static func randomSolidColor() -> UIImage {
        return randomSolidColor(width: 300, height: 300)
    }

    static func randomSolidColor(width: Int = 100, height: Int = 100) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor.random().cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue:  .random(), alpha: 1.0)
    }
}
