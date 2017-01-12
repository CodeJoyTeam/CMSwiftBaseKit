//
//  SectionHeaderFooterViewModel.swift
//  YFStore
//
//  Created by Fang on 2016/12/14.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import Foundation
import RxDataSources

///带区头区尾，并且区头区尾的数据是变化的
final class SectionHeaderViewModel<Cell,Header>: ViewModelType {
    let title: String
    let viewModels: [Cell]
    let headerViewModel: Header

    init(title: String, cellViewModels: [Cell], headerViewModel:Header) {
        self.title = title
        self.viewModels = cellViewModels
        self.headerViewModel = headerViewModel

    }
    
    func activated() {
        
    }
}

extension SectionHeaderViewModel: SectionModelType {
    typealias Item = Cell
    
    var items: [Item] {
        return viewModels
    }
    convenience init(original: SectionHeaderViewModel, items: [Item]) {
        self.init(title: original.title, cellViewModels: items, headerViewModel:original.headerViewModel)
    }
}
