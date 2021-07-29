//
//  NewWorkingStruct.swift
//  POPNetWorking
//
//  Created by wx on 2021/7/20.
//

import UIKit

typealias SEEDSuccessBlock = (Any) -> Void
typealias SEEDFailedBlock  = (Any) -> Void

/** 业务A 逻辑 */
struct CarSafe: PulicProtocol {
    static func getHost() -> String {
        return RequestUrlList.car.rawValue
    }
    
    static func encryptionData() -> String {
        return "业务A 加密"
    }
    
}


/** 业务B 逻辑 */
struct DriveSafe: PulicProtocol {
    static func getHost() -> String {
        return RequestUrlList.drive.rawValue
    }
    
    static func encryptionData() -> String {
        return "业务B 加密"
    }
}


class NewWorkingOperationQueue {
    
    static let manager = NewWorkingOperationQueue()
    private init () {}
    /** 是否同步 */
    lazy var isSync: Bool = false {
        didSet {
            queueList.maxConcurrentOperationCount = maxConcurrentOperationCount
        }
    }
    /** 线程数 */
    private var maxConcurrentOperationCount: Int {
        isSync ? 1 : ProcessInfo.processInfo.activeProcessorCount // 获取设备核数
    }
    
    /** 队列 */
    fileprivate lazy var queueList: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentOperationCount
        return queue
    }()

    
    /** 取消当前队列中事件 */
    func cancleOperationBindName(_ name: String) {
    
    if queueList.operations.isEmpty {
        return
    }
    // 网络请求标识
    let urlRequestStr = name + "_request"
    for op in queueList.operations where op.name == urlRequestStr || op.name == name  {
        //  判断操作是否已经标记为取消
        if op.isCancelled {
            continue
        }
        // 判断操作是否正在在运行。
        if (!op.isExecuting) {
            op.cancel()
            print("事件已被取消 \(String(describing: op.name))")
        }
        }
    }
    
    
    /** 参数绘制 */
    func addParameterEventBindName(_ name: String, _ block: @escaping () -> Void) -> BlockOperation{
        let op = BlockOperation(block: block)
        op.name = name
        return op;
    }
    
    /** 发起异步请求 */
    func loadRequestWithBindName(_ name: String, _ block: @escaping () -> Void) -> BlockOperation {
        let op = BlockOperation(block: block)
        op.name = name + "_request"
        return op;
    }
    
    /** 添加事件 */
    func addOperation(_ op: Operation) {
        queueList.addOperation(op)
    }
    
    /** 添加事件关联 */
    func addDependency(op1: Operation, op2: Operation) {
        op2.addDependency(op1)
        addOperation(op1)
        addOperation(op2)
    }
    
    /** 队列暂时挂起   默认为 false */
    func suspended(_ su: Bool = false) {
        queueList.isSuspended = su
    }
}

extension NewWorkingOperationQueue {
    /** 测试代码 线程休眠 */
    static func testSleep(_ bindName: String) {
        if bindName == "model2" {
            sleep(2)
        }
    }
}


