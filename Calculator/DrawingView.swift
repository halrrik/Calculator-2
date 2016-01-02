//
//  DrawingView.swift
//  Calculator
//
//  Created by Hanzhou Shi on 12/31/15.
//  Copyright © 2015 USF. All rights reserved.
//

import UIKit

// gives all points to be drawn from the data source
// the coordinate system for the points is centered
// at the conventional origin, which is the center of 
// the screen. user might need to do some conversions.
protocol DataSource: class {
    func allPointsInXRange(sender: DrawingView, from: CGFloat, to: CGFloat) -> [CGPoint]?
}

@IBDesignable
class DrawingView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 50 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blueColor()  { didSet { setNeedsDisplay() } }
    @IBInspectable
    var axesColor: UIColor = UIColor.blueColor()  { didSet { setNeedsDisplay() } }
    
    weak var source: DataSource?
    
    var currentOrigin: CGPoint {
        get {
            return origin ?? convertPoint(center, fromView: superview)
        }
    }
    
    var origin: CGPoint? { didSet { setNeedsDisplay() } }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            scale *= gesture.scale
            gesture.scale = 1
        default: break
        }
    }
    
    func move(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            let x = currentOrigin.x
            let y = currentOrigin.y
            origin = CGPoint(x: x + translation.x, y: y + translation.y)
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }

    override func drawRect(rect: CGRect) {
        let drawer = AxesDrawer(color: axesColor, contentScaleFactor: contentScaleFactor)
        drawer.drawAxesInRect(bounds, origin: currentOrigin, pointsPerUnit: scale)
        
        // draw all points fed from data source else we leave the view empty.
        let minX = (bounds.minX - currentOrigin.x) / scale
        let maxX = (bounds.maxX - currentOrigin.x) / scale
        if let points = source?.allPointsInXRange(self, from: minX, to: maxX) {
            connectAllPoints(points)
        }
    }
    
    private func connectAllPoints(points: [CGPoint]) {
        CGContextSaveGState(UIGraphicsGetCurrentContext())
        color.set()
        let path = UIBezierPath()
        path.moveToPoint(convertPointBack(points[0]))
        for point in points[1..<points.endIndex] {
            let convertedPoint = convertPointBack(point)
            path.addLineToPoint(convertedPoint)
            path.moveToPoint(convertedPoint)
        }
        path.stroke()
        CGContextRestoreGState(UIGraphicsGetCurrentContext())
    }
    
    private func convertPointBack(point: CGPoint) -> CGPoint {
        let x = point.x * scale + currentOrigin.x
        let y = currentOrigin.y - point.y * scale
        return CGPoint(x: x, y: y)
    }
}
