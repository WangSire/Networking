//
//  NetWorkingClassModel.swift
//  POPNetWorking
//
//  Created by wx on 2021/7/29.
//  类 demo

import UIKit

class NetWorkingClassSubModel: ResultModelProtocol {
    var name: String = ""
    var age: Int = 0
    var sex: String = ""
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.name <-- "names"
    }
}

class NetWorkingClassModel: NetWokingTotalProtocol {
    
    /** 接口返回Model 类型 */
    typealias ResponseType = Pensen
    /** 不同业务之间 数据 加解密 方式 */
    typealias ResponseEncryptionType = CarSafe
    
    /** 接口入参 */
    private(set) var path: String = "/car"
    private(set) var method: RequestMethod = .GET
    var bindName: String = ""
    
    var parameter: [String :Any]
    
    required init(parameter: [String : Any] = [:]) {
        self.parameter = parameter
    }
}
