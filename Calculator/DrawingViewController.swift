//
//  DrawingViewController.swift
//  Calculator
//
//  Created by Hanzhou Shi on 12/31/15.
//  Copyright © 2015 USF. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, DataSource {
    
    @IBOutlet weak var drawingView: DrawingView! {
        didSet {
            drawingView.source = self
        }
    }
    
    var op: (Double -> Double)?
    
    func allPointsInXRange(sender: DrawingView, from: CGFloat, to: CGFloat) -> [CGPoint]? {
        guard op != nil else { return nil }
        
        print("from: \(from), to: \(to)")
        var result = [CGPoint]()
        // dealing with left part
        for var x = min(from, 0); x <= min(to, 0); x += 1.0 {
            let y = op!(Double(x))
            result.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
        }
        // dealing with right part
        for var x = max(from, 0); x <= max(to, 0); x += 1.0 {
            let y = op!(Double(x))
            result.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
        }
        
        return result
    }
}
