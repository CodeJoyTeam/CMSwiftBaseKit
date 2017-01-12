//
//  URL+Parameters.swift
//  YFStore
//
//  Created by Fang on 2016/11/17.
//  Base on Aerolitec Template
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import Foundation

extension URL {
    //MARK:获取某个具体参数值
    func parameterForKey(_ key: String) -> String? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .filter {
                 $0.name.caseInsensitiveCompare(key) == .orderedSame
            }.first?.value
    }
}
