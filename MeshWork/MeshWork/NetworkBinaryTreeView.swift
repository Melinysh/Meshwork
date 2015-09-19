//
//  NetworkBinaryTreeView.swift
//  Binary Tree
//
//  Created by Sam Haves on 2015-09-19.
//  Copyright (c) 2015 Sam Haves. All rights reserved.
//

import UIKit

protocol NetworkBinaryTreeDataSource: class {
<<<<<<< HEAD
    func contacts(sender: NetworkBinaryTreeView) -> [String]?
    func peers(sender: NetworkBinaryTreeView) -> Int?
=======
    func contacts(sender: NetworkBinaryTreeView) -> [ContactObject]
    func peers(sender: NetworkBinaryTreeView) -> [ContactObject]
>>>>>>> 2686b918bffd35021e1e5e73d87a861bdea6eec8
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
    
    @IBInspectable
    var scale:CGFloat = 10{didSet{setNeedsDisplay()}}
    var strokeWidth: CGFloat = 2.0
    var known: Bool = true
    var numberOfContactsDrawn: Int = 0
	
	var startPoint : CGPoint? = nil
    
<<<<<<< HEAD
    var viewCenter: CGPoint{
        return convertPoint(center, fromView: superview)
    }
    
    weak var dataSource: NetworkBinaryTreeDataSource!
=======
//    var viewCenter: CGPoint{
//        return convertPoint(center, fromView: superview)
//    }
	
    weak var dataSource: NetworkBinaryTreeDataSource?
>>>>>>> 2686b918bffd35021e1e5e73d87a861bdea6eec8
    
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
	func pan(gesture : UIPanGestureRecognizer) {
		
		if gesture.state == UIGestureRecognizerState.Began {
			known = true
			let place = gesture.locationInView(self)
			let rootLoc = allNodes.first!.currentPoint
			initialPanDeltaX = place.x - rootLoc.x
			initialPanDeltaY = place.y - rootLoc.y
		} else if gesture.state == .Changed {
			known = true
			let place = gesture.locationInView(self)
			startPoint = CGPoint(x: place.x + initialPanDeltaX, y: place.y + initialPanDeltaY)
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
            /*color = UIColor(
                red:0.0,
                green:0.0,
                blue:0.0,
                alpha:0.3)*/
			color = UIColor.greenColor()
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
    
    
    private func drawBinaryTree(angle: Double, startPoint: CGPoint, iter: CGFloat){
        if(iter > 0){
            
            let x2: CGFloat = startPoint.x + ((CGFloat(cos(angle.degreesToRadians)) * scale) * iter)
            let y2: CGFloat = startPoint.y + ((CGFloat(sin(angle.degreesToRadians)) * scale) * iter)
            
            if (numberOfContactsDrawn >= contacts.count){known = false}
            
            let endPoint: CGPoint = CGPoint(x: x2, y: y2)
            
            let color: UIColor = getColor()
            color.setStroke()
            color.setFill()
            
            if(numberOfContactsDrawn < (contacts.count + peers.count)){
                let l = drawLine(startPoint, endPoint: endPoint)
				l.stroke()
				allLines.append(l)
                let n = drawNode(endPoint)
				n.fill()
				allNodes.append(n)
                numberOfContactsDrawn++
            }
            
            drawBinaryTree(angle + 40, startPoint: endPoint, iter: iter - 1)
            drawBinaryTree(angle - 40, startPoint: endPoint, iter: iter - 1)
        }
    }
    
    override func drawRect(rect: CGRect) {
		allNodes.forEach { $0.removeAllPoints() }
		allLines.forEach { $0.removeAllPoints() }
		allLines = []
		allNodes = []
		print("Cleared lines and nodes")
		let nodeCount = contacts.count + peers.count
        drawBinaryTree(-90 , startPoint: startPoint ?? center, iter: CGFloat(findHighestSumOfTwoPower(nodeCount)) + 1)
        numberOfContactsDrawn = 0
    }
}

