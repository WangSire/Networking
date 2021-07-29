//
//  NetWorkingModel.swift
//  POPNetWorking
//
//  Created by wx on 2021/7/19.
//  结构体 demo

import UIKit


// MARK: UI业务层 - Model

struct Pensen  {
    var name: String = ""
    var age: Int = 0
    var sex: String = ""
}

extension Pensen: ResultModelProtocol {

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.name <-- "names"
    }
}


struct PensenList {
    var list: [Pensen?] = []
}

extension PensenList: ResultModelProtocol {
    static func parse(json: String) -> Self? {
        var p = Self.init()
        guard let jsonList = [Pensen].deserialize(from: json) else { return nil }
        p.list = jsonList.compactMap { $0 }
        return p
    }
}


// MARK: 网络请求 - Model

struct NetWorkingModel: NetWokingTotalProtocol {
    
    /** 接口返回Model 类型 */
    typealias ResponseType = Pensen
    /** 不同业务之间 数据 加解密 方式 */
    typealias ResponseEncryptionType = CarSafe
    
    /** 接口入参 */
    private(set) var path: String = "/car"
    private(set) var method: RequestMethod = .GET
    var bindName: String = ""
    
    var parameter: [String :Any]
    
    init(parameter: [String : Any] = [:]) {
        self.parameter = parameter
    }
}
