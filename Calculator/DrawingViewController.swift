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
    
    let brain = CalculatorBrain()
    
    var symbols: AnyObject? {
        didSet {
            brain.program = symbols ?? [AnyObject]()
            updateUI()
        }
    }
    
    private func updateUI() {
        title = brain.description
        drawingView?.setNeedsDisplay()
    }
    
    private func getPointForX(x: CGFloat) -> CGPoint? {
        brain.variableValues["M"] = Double(x)
        if let y = brain.evaluate() {
            return CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
        else { return nil }
    }
    
    func allPointsInXRange(sender: DrawingView, from: CGFloat, to: CGFloat) -> [CGPoint]? {
        guard symbols != nil else { return nil }
        
        print("from: \(from), to: \(to)")
        var result = [CGPoint]()
        // dealing with left part
        for var x = min(from, 0); x <= min(to, 0); x += 1.0 {
            if let point = getPointForX(x) { result.append(point) }
        }
        // dealing with right part
        for var x = max(from, 0); x <= max(to, 0); x += 1.0 {
            if let point = getPointForX(x) { result.append(point) }
        }
        return result
    }
}
