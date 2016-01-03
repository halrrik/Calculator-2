//
//  GraphStatusController.swift
//  Calculator
//
//  Created by Hanzhou Shi on 1/3/16.
//  Copyright © 2016 USF. All rights reserved.
//

import UIKit

class GraphStatusViewController: UIViewController {

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text
        }
    }
    
    var text = "" {
        didSet {
            textView?.text = text
        }
    }
}
