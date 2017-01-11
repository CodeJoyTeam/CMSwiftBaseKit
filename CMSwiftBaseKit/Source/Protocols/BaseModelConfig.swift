//
//  BaseModelConfig.swift
//  SwiftTemple
//
//  Created by Fang on 2016/10/31.
//  Base on Aerolitec Template
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import Foundation

// MARK: -
// MARK: 基础模块配置
// MARK: -
 protocol BaseModelConfig {
  // MARK: -> Properties
    ///版本号
    var version:String!{ get }
    
    ///审核模式
    var reviewMode:NSNumber!{ get }

    ///是否是开发环境
    var developmentEnvironment:NSNumber!{ get }

  // MARK: -> Public methods
    func update()
    
    func loadWithPlist(plist:String)
}
