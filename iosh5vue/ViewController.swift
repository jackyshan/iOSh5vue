//
//  ViewController.swift
//  iosh5demo
//
//  Created by jackyshan on 2019/1/4.
//  Copyright © 2019年 Jacky Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func tap() {
        let vc = LichengViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

