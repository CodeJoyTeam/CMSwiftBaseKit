//
//  CMCheckUpdate.swift
//  YFStore
//
//  Created by Fang on 2016/12/2.
//  Copyright © 2016年 yfdyf. All rights reserved.
//
//检查应用市场最新的版本号

import UIKit
import EZSwiftExtensions

class CMCheckUpdate {
    
    static let instance = CMCheckUpdate()
    
    fileprivate var newUpdateTitle = "发现可用的新版本"
    fileprivate var newUpdateCancelButtonTitle = "稍后提醒"
    fileprivate var newUpdateOtherButtonTitles = "立即更新"
    fileprivate let itunes_checkversion_url = "http://itunes.apple.com/lookup?id="
    fileprivate let itunes_home_url = "https://itunes.apple.com/us/app/id"
    fileprivate var updateInfo:[String:String]
    fileprivate var appVersion:String?
    fileprivate var updateTitle:String
    fileprivate var appID:String?
    fileprivate var updateCancelButtonTitle:String
    fileprivate var updateOtherButtonTitles:String
    fileprivate var appHomeUrl:String?
    fileprivate var appCheckUpdateUrl:String?
    ///强制更新,不显示取消按钮,默认是false
    fileprivate var forceUpdate:Bool
    
    private init(){
        updateTitle = newUpdateTitle
        updateCancelButtonTitle = newUpdateCancelButtonTitle
        updateOtherButtonTitles = newUpdateOtherButtonTitles
        updateInfo = [:]
        forceUpdate = false
        if let version = ez.appVersion {
            appVersion = version
        }
    }
    
}

extension CMCheckUpdate{
    class func checkUpdateWith(appID:String,
                         forceUpdate:Bool,
                         title:String? = nil,
                         cancelButtonTitle:String? = nil,
                         otherButtonTitles:String? = nil
        ) {
        CMCheckUpdate.instance.checkUpdateWith(appID: appID, forceUpdate: forceUpdate, title: title, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }
}

extension CMCheckUpdate{
    fileprivate func checkUpdateWith(appID:String,
                                     forceUpdate:Bool,
                                     title:String?,
                                     cancelButtonTitle:String?,
                                     otherButtonTitles:String?
        ) {
        let defaultCheckversionUrl = itunes_checkversion_url + appID
        let defaultHomeUrl = itunes_home_url + appID + "?ls=1&mt=8"
        self.checkUpdate(appID: appID, forceUpdate: forceUpdate, homeUrl: defaultHomeUrl, title: title, checkUrl: defaultCheckversionUrl, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles)
    }

   fileprivate func checkUpdate(appID:String,
                     forceUpdate:Bool,
                     homeUrl:String ,
                     title:String? ,
                     checkUrl:String ,
                     cancelButtonTitle:String?,
                     otherButtonTitles:String?
        ){
        self.appID = appID
        self.forceUpdate = forceUpdate
        self.appHomeUrl = homeUrl
        self.appCheckUpdateUrl = checkUrl
        if let cancelButtonTitle = cancelButtonTitle {
            self.updateCancelButtonTitle = cancelButtonTitle
        }
        if let otherButtonTitles = otherButtonTitles {
            self.updateOtherButtonTitles = otherButtonTitles
        }
        if let title = title {
            self.updateTitle = title
        }
        self.checkAppUpdateResult()
    }

    fileprivate func checkAppUpdateResult() {
        guard let appCheckUpdateUrl = self.appCheckUpdateUrl else { return }
        ez.runThisInBackground {[unowned self] in
            self.checkAppUpdate(serverUrl: appCheckUpdateUrl)
        }
    }
    fileprivate func checkAppUpdate(serverUrl:String) {
        guard let url = URL(string:serverUrl) else { return}
        do {
            let jsonResponseString = try String.init(contentsOf: url, encoding: .utf8)
            guard let jsonData:Data = jsonResponseString.data(using: .utf8) else { return }
            let dic:[String:Any] = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
            if let resultCount = dic["resultCount"] as? NSNumber {
                // 判断resultCount的数量是否大于0
                if resultCount.intValue > 0 {
                    if let arr = dic["results"] as? NSArray,let dict = arr.firstObject as? NSDictionary {
                        self.executeUpdate(config: dict)
                    }
                }
            }
            
        } catch {
            DLog(message: error.localizedDescription)
        }
        
    }
    
   fileprivate func executeUpdate(config:NSDictionary) {
        guard let newVersion = config["version"] as? String else { return }
        guard let releaseNotes = config["releaseNotes"] as? String else { return }
        self.updateInfo["newVersion"] = newVersion
        self.updateInfo["releaseNotes"] = releaseNotes
        UserDefaults.standard.set(newVersion, forKey: "newVersion")
        UserDefaults.standard.synchronize()
        guard let appVersion = self.appVersion else { return }
        DLog(message: "通过appStore获取的版本号是:\(newVersion), 当前版本号:\(appVersion)")
        if newVersion.compare(appVersion) == ComparisonResult.orderedDescending {
            ez.runThisInMainThread {[unowned self] in
                self.appUpdateWithAlert(objectData: config)
            }
        }
    }
    
   fileprivate func appUpdateWithAlert(objectData:NSDictionary)  {
        guard let message = objectData["releaseNotes"] as? String else { return}
        guard let newVersion = objectData["version"] as? String else { return}
        
        let alertView = UIAlertController(title: (self.updateTitle + newVersion), message: message, preferredStyle: .alert)
        
        if self.forceUpdate == false{
            alertView.addAction(UIAlertAction(title:self.updateCancelButtonTitle, style: .cancel) { _ in
            })
        }
        alertView.addAction(UIAlertAction(title: self.updateOtherButtonTitles, style: .default) {[unowned self] _ in
            guard let appHomeUrl = self.appHomeUrl else { return}
            guard let url = URL(string:appHomeUrl) else { return}
            UIApplication.shared.openURL(url)
        })
        ez.topMostVC?.presentVC(alertView)
    }
    
}
