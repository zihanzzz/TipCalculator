//
//  TipConstants.swift
//  TipCalculator
//
//  Created by James Zhou on 9/21/16.
//  Copyright © 2016 James Zhou. All rights reserved.
//

import UIKit

class TipConstants: NSObject {
    
    static let greenColor = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1)
    
    static let blueColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
    
    static let titleString = "Tip Calculator"
    
    static let textFontName = "AmericanTypewriter-Bold"
    
    static let titleTextSize = CGFloat(20.0)
    
    static let titleFont = UIFont.init(name: TipConstants.textFontName, size: TipConstants.titleTextSize)
    
    static let titleTextDict: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: TipConstants.titleFont!]
    
    static let settingsString = "Settings"
    
    static let navigationTextSize = CGFloat(16.0)
    
    static let navigationTextFont = UIFont.init(name: TipConstants.textFontName, size: TipConstants.navigationTextSize)
    
    static let nagivationTextDict: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor.yellow, NSFontAttributeName: TipConstants.navigationTextFont!]

    static func getCurrencyString(string: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        let nsnumber = NSNumber(value: Double(string) ?? 0)
        return formatter.string(from: nsnumber)!
    }
}
