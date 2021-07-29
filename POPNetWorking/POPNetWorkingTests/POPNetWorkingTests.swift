//
//  POPNetWorkingTests.swift
//  POPNetWorkingTests
//
//  Created by wx on 2021/7/19.
//

import XCTest
@testable import POPNetWorking

class POPNetWorkingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSync() -> Void {
        var model = NetWorkingModel()
        model.parameter = ["1":"2"]
        model.asyncSend { (result) in
            switch result {
                case .success(let res):
                print(res)
                case .failure(let err):
                print("失败 \(err)")
            }
        }
    }
    
    func testAsync() -> Void {
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
