//
//  UIDevice+DeviceType.swift
//  SwiftTemple
//
//  Created by Fang on 2016/10/21.
//  Base on Aerolitec Template
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit

// MARK: -
// MARK: DeviceType Extends UIDevice
// MARK: -
extension UIDevice {
  // MARK: -> Class methods
    // 判断 是否 iphone4
    public class func isIPhone4() -> Bool {
        return UIScreen.main.currentMode?.size == CGSize(width:640, height:960)
    }
    // 判断 是否 iphone5
    public class func isIPhone5() -> Bool {
        return UIScreen.main.currentMode?.size == CGSize(width:640, height:1136)
    }
    // 判断 是否 iphone6
    public class func isIPhone6() -> Bool {
        return UIScreen.main.currentMode?.size == CGSize(width:750, height:1334)
    }
    // 判断 是否 iphone6 plus
    public class func isIPhone6Plus() -> Bool {
        return UIScreen.main.currentMode?.size == CGSize(width:1242, height:2208)
    }
    // 判断 是否 iphone6 plus bigMode
    public class func isIPhone6PlusBigMode() -> Bool {
        return UIScreen.main.currentMode?.size == CGSize(width:1125, height:2001)
    }

}
