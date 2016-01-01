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
    var scale: CGFloat = 25
    
    weak var source: DataSource?
    
    var axesCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }

    override func drawRect(rect: CGRect) {
        let drawer = AxesDrawer()
        drawer.drawAxesInRect(bounds, origin: axesCenter, pointsPerUnit: scale)
        
        // draw all points fed from data source else we leave the view empty.
        let minX = bounds.minX - axesCenter.x
        let maxX = bounds.maxX - axesCenter.x
        if let points = source?.allPointsInXRange(self, from: minX, to: maxX) {
            connectAllPoints(points)
        }
    }
    
    private func connectAllPoints(points: [CGPoint]) {
        for point in points {
            print("connecting: \(point)")
        }
    }
}
