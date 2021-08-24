//
//  StyleGuide.swift
//  Shortly
//
//  Created by Fabio Silvestri on 20/08/21.
//

import SwiftUI
import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xff) / 255
        let g = CGFloat((hex >> 08) & 0xff) / 255
        let b = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

public enum StyleGuide {
    
    public enum FontColors {
        
        public enum Primary {
            static let cyan = Color(UIColor(hex: 0x2ACFCF))
            static let violet = Color(UIColor(hex: 0x3B3054))
        }
        
        public enum Secondary {
            static let red = Color(UIColor(hex: 0xF46262))
        }
        
        public enum Neutral {
            static let lightGray = Color(UIColor(hex: 0xBFBFBF))
            static let gray = Color(UIColor(hex: 0x9E9AA7))
            static let grayish = Color(UIColor(hex: 0x35323E))
            static let veryDark = Color(UIColor(hex: 0x232127))
        }
        
    }
    
    public enum BackgroundColors {
        public static let white  = Color(UIColor(hex: 0xFFFFFF))
        public static let offWhite = Color(UIColor(hex: 0xF0F1F6))
    }
    
    public enum ButtonColors {
        static let primary                   = UIColor(red: 144/255, green: 195/255, blue: 248/255, alpha: 1)
        static let secondary                 = UIColor(red: 1/255, green: 25/255, blue: 51/255, alpha: 1)

        static let highlighted               = UIColor(red: 213/255, green: 226/255, blue: 239/255, alpha: 1)
        static let disabled                  = UIColor(red: 50/255, green: 83/255, blue: 121/255, alpha: 1)
    }
    
}
