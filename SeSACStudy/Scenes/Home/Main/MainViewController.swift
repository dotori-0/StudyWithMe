//
//  MainViewController.swift
//  SeSACStudy
//
//  Created by SC on 2022/11/25.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showToast(message: "Main")
    }
}
