//
//  ViewController.swift
//  Memol
//
//  Created by OCHIISHI Koichiro on 2015/03/15.
//  Copyright (c) 2015年 OCHIISHI Koichiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var markdownTextView: MarkdownTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.tintColor = UIColor(rgb: "#EFB944")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

