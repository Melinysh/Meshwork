//
//  NetworkBinaryTreeView.swift
//  Binary Tree
//
//  Created by Sam Haves on 2015-09-19.
//  Copyright (c) 2015 Sam Haves. All rights reserved.
//

import UIKit

protocol NetworkBinaryTreeDataSource: class {
    func contacts(sender: NetworkBinaryTreeView) -> [String]?
    func peers(sender: NetworkBinaryTreeView) -> Int?
}

extension Double {
        var degreesToRadians : CGFloat {
            return CGFloat(self) * CGFloat(M_PI) / 180.0
        }
    }

@IBDesignable
class NetworkBinaryTreeView: UIView {
    
    
    
    @IBInspectable
    var scale:CGFloat = 10{didSet{setNeedsDisplay()}}
    var strokeWidth: CGFloat = 2.0
    var known: Bool = true
    var numberOfContactsDrawn: Int = 0
    
    var viewCenter: CGPoint{
        return convertPoint(center, fromView: superview)
    }
    
    weak var dataSource: NetworkBinaryTreeDataSource!
    
    //TODO:  ask about not having contacts default
    /*var contacts = ["jim", "jack", "ass", "dick", "jack", "jack", "ass", "dick", "jack", "jack", "ass", "dick", "jack"]
    var numberOfUsers = 24*/
    
    private struct Constants {
        static let nodeRadius: CGFloat = 4
    }
    
    func scale(gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed {
            known = true
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    private func drawLine(startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        path.lineWidth = strokeWidth
        
        return path
    }
    
    private func drawNode(endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: endPoint, radius: Constants.nodeRadius , startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = strokeWidth
        
        return path
    }
    
    private func getColor() -> UIColor{
        var color:UIColor
        if(known){
            color = UIColor.blueColor()
        }else{
            color = UIColor(
                red:0.0,
                green:0.0,
                blue:0.0,
                alpha:0.3)
        }
        
        return color
    }
    
    private func findHighestSumOfTwoPower(input: Int) -> Int {
        var currentSum : Int = 0
        var currentPower: Double = 0
        while(input > currentSum){
            
            currentSum = currentSum + Int(pow(2.0, currentPower))
            if(input > currentSum){
                currentPower++
            }
        }
        println(currentSum)
        return Int(currentPower)
    }
    
    
    private func drawBinaryTree(angle: Double, startPoint: CGPoint, iter: CGFloat){
        if(iter > 0){
            
            var x2: CGFloat = startPoint.x + ((CGFloat(cos(angle.degreesToRadians)) * scale) * iter)
            var y2: CGFloat = startPoint.y + ((CGFloat(sin(angle.degreesToRadians)) * scale) * iter)
            
            if (numberOfContactsDrawn >= contacts.count){known = false}
            
            let endPoint: CGPoint = CGPoint(x: x2, y: y2)
            
            let color: UIColor = getColor()
            color.setStroke()
            color.setFill()
            
            if(numberOfContactsDrawn < numberOfUsers){
                drawLine(startPoint, endPoint: endPoint).stroke()
                drawNode(endPoint).fill()
                numberOfContactsDrawn++
            }
            
            drawBinaryTree(angle + 40, startPoint: endPoint, iter: iter - 1)
            drawBinaryTree(angle - 40, startPoint: endPoint, iter: iter - 1)
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        
        println(CGFloat(findHighestSumOfTwoPower(numberOfUsers)))
        drawBinaryTree(-90 , startPoint: viewCenter, iter: CGFloat(findHighestSumOfTwoPower(numberOfUsers)) + 1)
        numberOfContactsDrawn = 0
    }
}

