//
//  RegexHelper.swift
//  YFStore
//
//  Created by Fang on 2016/11/16.
//  Copyright © 2016年 yfdyf. All rights reserved.
//
//正则表达式工具

import Foundation

struct RegexHelper {
    let regex:NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern:pattern,options:.caseInsensitive)
    }
    
    func match(_ input:String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0,input.utf16.count))
        return matches.count > 0
    }
   
}
