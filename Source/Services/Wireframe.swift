//
//  Wireframe.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 4/3/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
#endif

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
import EZSwiftExtensions
import Toast_Swift

enum RetryResult {
    case retry
    case cancel
}

protocol Wireframe {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ title:String, message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
    func toastFor<Action : CustomStringConvertible>(message:String,position: ToastPosition,tapAction:Action) -> Observable<Action>
}


class DefaultWireframe: Wireframe {
    static let sharedInstance = DefaultWireframe()

    func open(url: URL) {
        #if os(iOS)
            UIApplication.shared.openURL(url)
        #elseif os(macOS)
            NSWorkspace.shared().open(url)
        #endif
    }

    #if os(iOS)
    private static func rootViewController() -> UIViewController {
        return ez.topMostVC!
    }
    #endif

    static func presentAlert(_ message: String) {
        #if os(iOS)
            let alertView = UIAlertController(title: "温馨提示", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            })
            rootViewController().present(alertView, animated: true, completion: nil)
        #endif
    }

    func promptFor<Action : CustomStringConvertible>(_ title:String, message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        #if os(iOS)
        return Observable.create { observer in
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                observer.on(.next(cancelAction))
            })

            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                    observer.on(.next(action))
                })
            }

            DefaultWireframe.rootViewController().present(alertView, animated: true, completion: nil)

            return Disposables.create {
                alertView.dismiss(animated:false, completion: nil)
            }
        }
        #elseif os(macOS)
            return Observable.error(NSError(domain: "Unimplemented", code: -1, userInfo: nil))
        #endif
    }
    
    func toastFor<TapAction : CustomStringConvertible>(
        message:String,
        position: ToastPosition,
        tapAction:TapAction) -> Observable<TapAction>{
        return Observable.create{ observer in
            DefaultWireframe.rootViewController().view.makeToast(message, duration: 2.0, position:position, title: nil, image: nil, style:nil) { (didTap: Bool) -> Void in
                observer.on(.next(tapAction))
            }
            return Disposables.create()
        }
    }
}


extension RetryResult : CustomStringConvertible {
    var description: String {
        switch self {
        case .retry:
            return "Retry"
        case .cancel:
            return "Cancel"
        }
    }
}
