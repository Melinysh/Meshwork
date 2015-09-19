//
//  NetworkBinaryTreeView.swift
//  Binary Tree
//
//  Created by Sam Haves on 2015-09-19.
//  Copyright (c) 2015 Sam Haves. All rights reserved.
//

import UIKit

protocol NetworkBinaryTreeDataSource: class {
    func contacts(sender: NetworkBinaryTreeView) -> [ContactObject]
    func peers(sender: NetworkBinaryTreeView) -> [ContactObject]
}

extension Double {
        var degreesToRadians : CGFloat {
            return CGFloat(self) * CGFloat(M_PI) / 180.0
        }
    }

@IBDesignable
class NetworkBinaryTreeView: UIView {
    
    var allLines = [UIBezierPath]()
	var allNodes = [UIBezierPath]()
    var curX: CGFloat = 0
    var curY: CGFloat = 0
    var middleX: CGFloat = 0
    var middleY: CGFloat = 0
    
    @IBInspectable
    var scale:CGFloat = 10{didSet{setNeedsDisplay()}}
    var strokeWidth: CGFloat = 2.0
    var known: Bool = true
    var numberOfContactsDrawn: Int = 0
	
	//var startPoint : CGPoint? = nil
	
    
    weak var dataSource: NetworkBinaryTreeDataSource!

    
    //TODO:  ask about not having contacts default
	
	let c1 = ContactObject(photo: UIImagePNGRepresentation(UIImage(named: "stevo.png")!), name: "Stephen Melinyshyn")
	let c2 = ContactObject(photo: nil, name: "Sam Haves")
	let c3 = ContactObject(photo: nil, name: "David Tsenter")
	let c4 = ContactObject(photo: nil, name: "Jon Galaperin")
	var contacts : [ContactObject] = []
	var peers : [ContactObject] = []
	
	convenience init (contacts : [ContactObject], peers : [ContactObject]) {
		self.init()
		self.peers = [c1,c2,c3] // TODO: Change to params
		self.contacts = [c4]
        self.curX = center.x
        self.curY = center.y
        self.middleX = curX
        self.middleY = curY
		self.backgroundColor = UIColor.whiteColor()
		self.clearsContextBeforeDrawing = true
		self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "scale:"))
		self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "pan:"))
	}

	
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
	
	var initialPanDeltaX : CGFloat!
	var initialPanDeltaY : CGFloat!
    var deltaX : CGFloat = 0
    var deltaY : CGFloat = 0
    var initPoint: CGPoint = CGPoint(x: 0, y: 0)
    var shiftPoint: CGPoint = CGPoint(x:0, y:0)
    
	func pan(gesture : UIPanGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizerState.Began {
			known = true
			initPoint = gesture.locationInView(self)
            shiftPoint = CGPoint(x: deltaX, y: deltaY)
			/*initialPanDeltaX = place.x - rootLoc.x
			initialPanDeltaY = place.y - rootLoc.y*/
		} else if gesture.state == .Changed {
			known = true
			let place = gesture.locationInView(self)
            let x = (place.x - initPoint.x)
            let y = (place.y - initPoint.y)
            
            deltaX = shiftPoint.x + x
            deltaY = shiftPoint.y + y
			//startPoint = CGPoint(x: place.x + initialPanDeltaX, y: place.y + initialPanDeltaY)
			self.setNeedsDisplay()
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
        print(currentSum)
        return Int(currentPower)
    }
    
    
    private func drawBinaryTree(angle: Double, x: CGFloat, y: CGFloat, iter: CGFloat){
        if(iter > 0){
            
            let x2: CGFloat = x + ((CGFloat(cos(angle.degreesToRadians)) * scale) * iter)
            let y2: CGFloat = y + ((CGFloat(sin(angle.degreesToRadians)) * scale) * iter)
            
            if (numberOfContactsDrawn >= contacts.count){known = false}
            
            let endPoint: CGPoint = CGPoint(x: x2, y: y2)
            
            let color: UIColor = getColor()
            color.setStroke()
            color.setFill()
            
            let startPoint = CGPoint(x: x,y: y)
            if(numberOfContactsDrawn < (contacts.count + peers.count)){
                let l = drawLine(startPoint, endPoint: endPoint)
				l.stroke()
				allLines.append(l)
                let n = drawNode(endPoint)
				n.fill()
				allNodes.append(n)
                numberOfContactsDrawn++
            }
            
            drawBinaryTree(angle + 40, x: endPoint.x, y: endPoint.y, iter: iter - 1)
            drawBinaryTree(angle - 40, x: endPoint.x, y: endPoint.y, iter: iter - 1)
        }
    }
    
    override func drawRect(rect: CGRect) {
		allNodes.forEach { $0.removeAllPoints() }
		allLines.forEach { $0.removeAllPoints() }
		allLines = []
		allNodes = []
		
		let nodeCount = contacts.count + peers.count
        curX = center.x + deltaX
        curY = center.y + deltaY
        print("\(curX) \(curY)")
        drawBinaryTree(-90 , x: curX , y: curY, iter: CGFloat(findHighestSumOfTwoPower(nodeCount)) + 1)
        numberOfContactsDrawn = 0
    }
}

