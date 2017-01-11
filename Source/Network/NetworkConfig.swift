//
//  NetworkConfig.swift
//  SwiftTemple
//
//  Created by Fang on 2016/10/31.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

import UIKit
class NetworkConfig:BaseModelConfig{
    
    //单例
    static let sharedInstance: NetworkConfig = {
         let __singleton = NetworkConfig()
        __singleton.loadWithPlist(plist: String(describing: NetworkConfig()))
        return __singleton
    }()
    
    private init(){
        DLog(message: "初始化NetworkConfig")
    }
    
    ///版本号
    var version:String!
    
    ///审核模式
    var reviewMode:NSNumber!
    
    ///是否是开发环境
    var developmentEnvironment:NSNumber!
    
    ///生产环境地址
    var baseUrl:String!
    
    ///测试地址
    var testUrl:String!
    
    ///预发布环境
    var preDistributionUrl:String!

    ///开发环境
    var developmentBaseUrl:String!

    ///活动列表地址
    var activityListUrl:String!

    ///网络请求超时时间
    var requestTiemout:NSNumber?
    
    ///当前网络请求地址
    public var requestBaseUrl: String! {
        var url:String?
        if developmentEnvironment.intValue == 0 {
            url = baseUrl
        }else if developmentEnvironment.intValue == 1{
            url = developmentBaseUrl
        }else if developmentEnvironment.intValue == 2{
            url = testUrl
        }else if developmentEnvironment.intValue == 3{
            url = preDistributionUrl
        }
        return url
    }
    ///请求参数
   public var parameters:Dictionary<String,Any>?

    func loadWithPlist(plist: String) {
        let path:String = Bundle.main.path(forResource: plist.components(separatedBy: ".").last!, ofType: "plist")!
        let config = NSDictionary(contentsOfFile: path)
        self.updateWithConfig(config!)
    }
    
    ///额外添加的参数
    func addParameters(key:String!,value:Any!) {
        if (parameters == nil){
           parameters = Dictionary.init()
        }
        parameters?[key] = value
    }

    private func updateWithConfig(_ config:NSDictionary) {
        version = config.object(forKey: "version") as! String
        reviewMode = config.object(forKey: "reviewMode") as! NSNumber
        developmentEnvironment = config.object(forKey: "developmentEnvironment") as! NSNumber
        baseUrl = config.object(forKey: "baseUrl") as! String
        testUrl = config.object(forKey: "testUrl") as! String
        preDistributionUrl = config.object(forKey: "preDistributionUrl") as! String
        activityListUrl = config.object(forKey: "activityListUrl") as! String
        developmentBaseUrl = config.object(forKey: "developmentBaseUrl") as! String
        requestTiemout = config.object(forKey: "requestTiemout") as? NSNumber

    }
    
    internal func update() {
        
    }
    
}
