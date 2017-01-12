//
//  SectionViewModel.swift
//  YFStore
//
//  Created by Fang on 2016/12/7.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import Foundation
import RxDataSources

final class SectionViewModel<T>: ViewModelType {
    let title: String
    let viewModels: [T]
    
    init(title: String, viewModels: [T]) {
        self.title = title
        self.viewModels = viewModels
    }
    func activated() {
        
    }
}

extension SectionViewModel: SectionModelType {
    typealias Item = T
    
    var items: [Item] {
        return viewModels
    }
    convenience init(original: SectionViewModel, items: [Item]) {
        self.init(title: original.title, viewModels: items)
    }
}
