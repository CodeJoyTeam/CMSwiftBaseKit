//
//  GlobalTools.swift
//  SwiftTemple
//
//  Created by Fang on 2016/10/21.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit
import Foundation
import EZSwiftExtensions
import RxSwift
import RxSwift
import RxCocoa

let iphone5W:CGFloat = 320.0
let iphone6W:CGFloat = 375.0
let iphone6plusW:CGFloat = 414.0

class Dependence {
    static let instance = Dependence() // Singleton
    
    let URLSession = Foundation.URLSession.shared
    let backgroundWorkScheduler: ImmediateSchedulerType
    let mainScheduler: SerialDispatchQueueScheduler
    let wireframe: Wireframe
    let reachabilityService: ReachabilityService
    let activityIndicator = ActivityIndicator()
    var officeBox : [String:Variable<Any>] = [String:Variable<Any>]() // PostOfficeBox

    private init() {
        wireframe = DefaultWireframe()
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
        
        mainScheduler = MainScheduler.instance
        reachabilityService = try! DefaultReachabilityService() // try! is only for simplicity sake
    }
    
    //MARK:像素转换
    func pxTopt(_ px:CGFloat) -> CGFloat {
        var standardPt = CGFloat(px/2.0)
        if UIDevice.isIPhone5() || UIDevice.isIPhone4() {
            standardPt = (iphone5W/iphone6W)*standardPt
        }else if  UIDevice.isIPhone6Plus(){
            standardPt = (iphone6plusW/iphone6W)*standardPt
        }
        return standardPt
    }
    
    //MARK:传递数据
    func post(_ name: String, value: Any) {
        if officeBox.keys.contains(name) {
            officeBox[name]!.value = value
        } else {
            officeBox[name] = Variable(value: value)
        }
    }
    
    //MARK:接收数据
    func receive(_ name: String) -> Variable<Any>? {
        return officeBox[name]
    }


}
