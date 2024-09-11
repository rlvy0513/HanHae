//
//  UIFont+Extension.swift
//  HanHae
//
//  Created by 김성민 on 9/11/24.
//

import UIKit

enum FontName: String {
    case eliceDigitalBaeumRegular = "EliceDigitalBaeumOTF"
    case eliceDigitalBaeumBold = "EliceDigitalBaeumOTF-Bd"
}

extension UIFont {
    static func hhFont(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return customFont
    }
    
    static var hhLargeTitle: UIFont {
        hhFont(.eliceDigitalBaeumBold, ofSize: 34)
    }
    
    static var hhTitle: UIFont {
        hhFont(.eliceDigitalBaeumBold, ofSize: 20)
    }
    
    static var hhHeadLine: UIFont {
        hhFont(.eliceDigitalBaeumBold, ofSize: 17)
    }
    
    static var hhBody: UIFont {
        hhFont(.eliceDigitalBaeumRegular, ofSize: 17)
    }
    
    static var hhCaption1: UIFont {
        hhFont(.eliceDigitalBaeumRegular, ofSize: 12)
    }
    
    static var hhCaption2: UIFont {
        hhFont(.eliceDigitalBaeumRegular, ofSize: 10)
    }
}
