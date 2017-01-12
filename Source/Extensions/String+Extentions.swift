//
//  NSString+TelNumber.swift
//  YFStore
//
//  Created by I Mac on 16/11/25.
//  Base on Aerolitec Template
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import Foundation
import EZSwiftExtensions

extension String{
    func isMobileNumber() -> Bool{
        if self =~ "^1\\d{10}$" {
            return true
        }
        return false
    }
    
    func addStrikthrough() -> NSAttributedString{
        let length : Int = self.length
        let attri = NSMutableAttributedString.init(string: self)
        attri.addAttribute(NSStrikethroughStyleAttributeName, value:  NSNumber(value: 1), range: NSMakeRange(0, length))
        attri.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.lightGray, range: NSMakeRange(0, length))
        return attri
    }
    func getAutoComputeHeight(attributes:[String : Any] , withWidth:CGFloat ,withHeight:CGFloat) -> CGFloat {
        var height : CGFloat = 0
        let string = NSAttributedString(string: self, attributes: attributes)
        let descSize = string.boundingRect(with: CGSize(width: withWidth, height: withHeight), options: [.usesLineFragmentOrigin , .usesFontLeading], context: nil).size
        height = descSize.height
        return height
    }
}
