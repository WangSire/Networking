//
//  HomeViewController.swift
//  POPNetWorking
//
//  Created by wx on 2021/7/29.
//  测试是否存在 循环引用

import UIKit

class HomeViewController: UIViewController {
    
    deinit {
        print("\(type(of: self)) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.yellow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        asyncCaseParRepeat()
    }
    
    /** 重复 事件 */
     private func asyncCaseParRepeat() {
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

