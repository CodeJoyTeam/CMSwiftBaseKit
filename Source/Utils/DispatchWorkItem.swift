//
//  DispatchWorkItem.swift
//  YFStore
//
//  Created by Fang on 2016/11/24.
//  Copyright © 2016年 yfdyf. All rights reserved.
//

/* 使用范例
 let task = delay(2){
 Dlog(message:"2秒后输出")
 }
 
 //取消
 cancel(task)
 
 */


import Foundation

typealias Mission = (_ cancel:Bool) -> Void

func delay(_ time:TimeInterval,task:@escaping()->()) -> Mission? {
    
    func dispatch_later(block:@escaping()->()){
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline:t,execute:block)
    }
    
    var closure:(()->Void)? = task
    var result:Mission?
    
    let delayedClosure:Mission = {
        cancel in
        if let internalClosure = closure {
            if cancel == false {
                DispatchQueue.main.async(execute:internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result{
            delayedClosure(false)
        }
    }
    
    return result
}

func cancel(_ task:Mission?){
    task?(true)
}


