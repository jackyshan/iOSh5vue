//
//  LichengViewController.swift
//  iosh5vue
//
//  Created by jackyshan on 2019/1/9.
//  Copyright © 2019年 Jacky Labs. All rights reserved.
//

import UIKit

class LichengViewController: JWebViewController {
    
    override func initUI() {
        super.initUI()
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "点击", style: .plain, target: self, action: #selector(tap))
    }

    override func initListner() {
        addJsFunc("openvc") { [weak self] (_) in
            let vc = LichengViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func initData() {
        loadH5("licheng")
    }
    
    @objc func tap(){
        let msgs = [Person().toDictionary(), Person().toDictionary()]
        addJsObj("msgs", msgs.toJSONString()!)
    }

    class Person: JBaseModel {
        var name: String = "aaa"
    }

}
