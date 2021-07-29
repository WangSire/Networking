//
//  NetWokingENUM.swift
//  POPNetWorking
//
//  Created by wx on 2021/7/20.
//

import Foundation

/** 请求方式 */
enum RequestMethod: String {
    case GET
    case POST
}

/** 错误 标识 */
enum RequestError: Error {
    case baseError
    case codeError
}

/** 域名 */
enum RequestUrlList: String {
    case car = "https://www.baidu.com"
    case drive = "https://juejin.cn"
}

