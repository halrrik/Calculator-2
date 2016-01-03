//
//  DrawingViewController.swift
//  Calculator
//
//  Created by Hanzhou Shi on 12/31/15.
//  Copyright © 2015 USF. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, DataSource, UIPopoverPresentationControllerDelegate {
    
    private struct Constants {
        static let StatusSegueIdentifier = "Show Graph Status"
    }
    
    @IBOutlet weak var drawingView: DrawingView! {
        didSet {
            drawingView.source = self
            
            // setup recognizers
            drawingView.addGestureRecognizer(UIPinchGestureRecognizer(target: drawingView, action: "scale:"))
            drawingView.addGestureRecognizer(UIPanGestureRecognizer(target: drawingView, action: "move:"))
            let tapRecognizer = UITapGestureRecognizer(target: drawingView, action: "doubleTap:")
            tapRecognizer.numberOfTapsRequired = 2
            drawingView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController
        switch segue.identifier! {
        case Constants.StatusSegueIdentifier:
            if let gsv = destination as? GraphStatusViewController {
                if let ppv = gsv.popoverPresentationController {
                    ppv.delegate = self
                }
                gsv.text = drawingView.status?.description ?? ""
            }
        default: break
        }
    }
    
    // make sure that the popover is displayed even it's running on iPhone.
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    let brain = CalculatorBrain()
    
    var symbols: AnyObject? {
        didSet {
            brain.program = symbols ?? [AnyObject]()
            updateUI()
        }
    }
    
    private func updateUI() {
        title = getLastExpressionDesc(brain.description)
        drawingView?.setNeedsDisplay()
    }
    
    private func getLastExpressionDesc(desc: String) -> String {
        let separated = desc.componentsSeparatedByString(",")
        return separated[separated.endIndex-1]
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
