//
//  NetWokingProtocl.swift
//  POPNetWorking
//
//  Created by wx on 2021/7/19.
//

import Foundation

let jsonString = "{\"names\":\"siri\",\"age\":18,\"type\":\"大鹏\"}"

let jsonArrString = "[{\"names\":\"siri\",\"age\":18,\"type\":\"大鹏\"},{\"names\":\"evan\",\"age\":20,\"type\":\"大鹏\"}]"

// MARK: 请求参数
protocol RequestInfoProtocal {
    
    /** 路径 */
    var path: String {get}
    
    /** 请求方式 */
    var method: RequestMethod {get}

    /** 入参 */
    var parameter: [String :Any] {set get}
    
    /** 请求唯一标识 */
    var bindName: String {get}
    
    // 结果类型
    associatedtype ResponseType: ResultModelProtocol
    
    // 业务加密
    associatedtype ResponseEncryptionType: PulicProtocol
    
    init(parameter: [String :Any])
}
extension RequestInfoProtocal {
    var host: String {
        return ResponseEncryptionType.getHost()
    }
}


// MARK: Model JSON序列化
protocol ResultModelProtocol: HandyJSON {
    // json序列化
    static func parse(json: String) -> Self?
}
extension ResultModelProtocol {
    // 接口请求完成后,通过该函数自动转model! tip: 该函数只能转 map 类型的! 如果是 Arr 类型, 则需要再model中,自己声明
    static func parse(json: String) -> Self? {
        return Self.deserialize(from: json) 
    }
}



// MARK: 网络请求
protocol NetWorkingRequestProtocol {}
extension NetWorkingRequestProtocol {
    
    // T 这代表类型  info: 则代表实例
    @discardableResult fileprivate func sendRequest<T: RequestInfoProtocal>(info: T,handler: @escaping (Result<T.ResponseType, RequestError>) -> Void) -> Int {
    
        
        guard let url = URL(string: "\(info.host)\(info.path)") else { return 0 }
        
        
        let _ = T.ResponseEncryptionType.encryptionData()
        
        var request = URLRequest(url: url)
        request.httpMethod = info.method.rawValue
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 1 // 超时时间
        
        let task = URLSession(configuration: config).dataTask(with: request) { (data, response, error) in
            
            if let _ = data, let ret = T.ResponseType.parse(json: jsonString) {
                DispatchQueue.main.async {
                    handler(.success(ret))
                }

            }else {
                
                // 测试异步代码 (延迟某个线程 执行事件)
//                NewWorkingOperationQueue.testSleep(info.bindName)
                
                DispatchQueue.main.async {
                    // 数据模拟
                    guard let ret = T.ResponseType.parse(json: jsonString) else {
                        handler(.failure(.baseError))
                        return
                    }
                    handler(.success(ret))
                }
            }
        }
        
        task.resume()
        return task.taskIdentifier
    }
}

// MARK: 发起网络请求 对外使用
protocol NetWokingTotalProtocol: RequestInfoProtocal, NetWorkingRequestProtocol {}
/** 没有异步 绘制参数 */
extension NetWokingTotalProtocol {
    
    /** 同步 接口依赖 */
    func syncSend(handle: @escaping (Result<ResponseType, RequestError>) -> Void) {
        OperationQueue.isSync = true
        OperationQueue.cancleOperationBindName(self.bindName)
        
        let requestOperation = OperationQueue.loadRequestWithBindName(self.bindName, {
            
            OperationQueue.suspended(true)

            sendRequest(info: self, handler: {(result) in
                print("同步 请求回调" + self.bindName)
                handle(result)
                OperationQueue.suspended(false)
            })
        })
        OperationQueue.addOperation(requestOperation)
    }
    
    /** 异步 */
    func asyncSend(handle: @escaping (Result<ResponseType, RequestError>) -> Void) {
        OperationQueue.isSync = false
        
        OperationQueue.cancleOperationBindName(self.bindName)
                
        let requestOperation = OperationQueue.loadRequestWithBindName(self.bindName, {
            
            // 测试代码
            sendRequest(info: self, handler: {(result) in
                
                print("异步 请求回调" + self.bindName)
                handle(result)
            })
        })
        OperationQueue.addOperation(requestOperation)
    }
    
    /** 队列 */
    private var OperationQueue: NewWorkingOperationQueue {
        NewWorkingOperationQueue.manager
    }
    
}


/** 异步 绘制参数 */
extension NetWokingTotalProtocol {
    
    /** 同步 接口依赖 */
    func syncSendWithParameter(_ parameterHandle:@escaping (inout Self) -> Void, completionHandle: @escaping (Result<ResponseType, RequestError>) -> Void) {
        OperationQueue.isSync = true
        OperationQueue.cancleOperationBindName(self.bindName)
        
        // 因为函数参数为 copy! 兼容 Struct
        var updateSelf = self
        
        let parameterOperation = OperationQueue.addParameterEventBindName(self.bindName) {
            parameterHandle(&updateSelf)
        }
        
        let requestOperation = OperationQueue.loadRequestWithBindName(self.bindName, {
            
            OperationQueue.suspended(true)

            sendRequest(info: updateSelf, handler: {(result) in
                print("同步 请求回调" + updateSelf.bindName)
                completionHandle(result)
                OperationQueue.suspended(false)
            })
        })
        
        OperationQueue.addDependency(op1: parameterOperation, op2: requestOperation)
    }
    
    /** 异步 */
    func asyncSendWithParameter(_ parameterHandle:@escaping (inout Self) -> Void, completionHandle: @escaping (Result<ResponseType, RequestError>) -> Void) {
        
        OperationQueue.isSync = false
        
        // 因为函数参数为 copy! 兼容 Struct
        var updateSelf = self
        
        let parameterOperation = OperationQueue.addParameterEventBindName(self.bindName) {
            parameterHandle(&updateSelf)
        }
        
        OperationQueue.cancleOperationBindName(self.bindName)
                
        let requestOperation = OperationQueue.loadRequestWithBindName(self.bindName, {
            
            // 测试代码
            sendRequest(info: updateSelf, handler: {(result) in
                
                print("异步 请求回调" + updateSelf.bindName)
                completionHandle(result)
            })
        })
        //添加关联
        OperationQueue.addDependency(op1: parameterOperation, op2: requestOperation)
    }
}


// MARK: 公共加解密
protocol PulicProtocol {
    /** 加密 */
    static func encryptionData() -> String
    
    /** host */
    static func getHost() -> String
}

