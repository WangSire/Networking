//
//  ViewController.swift
//  POPNetWorking
//
//  Created by wx on 2021/7/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }
}



// MARK: 非异步绘制参数
func syncCase() {
    var model = NetWorkingModel()
//    model.bindName = "model1"
    model.syncSend { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
    
//    model.bindName = "model2"
    model.syncSend { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
    
//    model.bindName = "model3"
    model.syncSend { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
}


func asyncCase() {
    var model = NetWorkingModel()
    model.bindName = "model1"
    model.asyncSend { (result) in
        switch result {
            case .success(let res):
            print(res)
            case .failure(let err):
            print("失败 \(err)")
        }
    }
    
    model.bindName = "model2"
    model.asyncSend { (result) in
        switch result {
            case .success(let res):
            print(res)
            case .failure(let err):
            print("失败 \(err)")
        }
    }
    
    model.bindName = "model3"
    model.asyncSend { (result) in
        switch result {
            case .success(let res):
            print(res)
            case .failure(let err):
            print("失败 \(err)")
        }
    }
    
}

// MARK: 异步绘制参数
func syncCasePar() {
    print("已经点击了")
    var model = NetWorkingModel()
    model.bindName = "par - model1"
    model.parameter = ["1":"2"]
    
    model.syncSendWithParameter { localModel in
        localModel.parameter = ["4":"5"]
        sleep(2)
    } completionHandle: { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
    
    var model2 = NetWorkingModel()
    model2.bindName = "par - model2"
    model2.syncSendWithParameter { localModel in
        localModel.parameter = ["q":"w"]
        sleep(10)
    } completionHandle: { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
    
    var model3 = NetWorkingModel()
    model3.bindName = "par - model3"
    model3.syncSendWithParameter { localModel in
        localModel.parameter = ["a":"z"]
    } completionHandle: { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
}

func asyncCasePar() {
    print("已经点击了")
    var model = NetWorkingModel()
    model.bindName = "par - model1"
    model.parameter = ["1":"2"]
    
    model.asyncSendWithParameter { localModel in
        localModel.parameter = ["4":"5"]
        sleep(2)
    } completionHandle: { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
    
    var model2 = NetWorkingModel()
    model2.bindName = "par - model2"
    model2.asyncSendWithParameter { localModel in
        localModel.parameter = ["q":"w"]
        sleep(10)
    } completionHandle: { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
    
    var model3 = NetWorkingModel()
    model3.bindName = "par - model3"
    model3.asyncSendWithParameter { localModel in
        localModel.parameter = ["a":"z"]
    } completionHandle: { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
}

/** 重复 事件 */
func asyncCaseParRepeat() {
    print("已经点击了")
    // struct  类型
//    var model = NetWorkingModel()
    
    // class  类型
    let model = NetWorkingClassModel()
    model.bindName = "Repeat - model1"
    model.asyncSendWithParameter { localModel in
        localModel.parameter = ["4":"5"]
        sleep(2)
    } completionHandle: { (result) in
        if case .success(let res) = result {
            print(res)
        }
    }
}

