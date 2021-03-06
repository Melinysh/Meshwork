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

class ContactImageNode : UIImageView {
	var contact : ContactObject!
}



@IBDesignable
class NetworkBinaryTreeView: UIView {
    
    var allLines = [UIBezierPath]()
	var allNodes = [UIBezierPath]()
    var curX: CGFloat = 0
    var curY: CGFloat = 0
	
	var controller : NetworkBinaryTreeViewController!
    
    @IBInspectable
    var scale:CGFloat = 30{didSet{setNeedsDisplay()}}
    var strokeWidth: CGFloat = 2.0
    var known: Bool = true
    var numberOfContactsDrawn: Int = 0
	
    
    weak var dataSource: NetworkBinaryTreeDataSource!
	
	let c1 = ContactObject(photo: UIImagePNGRepresentation(UIImage(named: "stevo.png")!), name: "Stephen Melinyshyn")
	let c2 = ContactObject(photo:  nil, name: "Sam Haves")
	let c3 = ContactObject(photo: nil, name: "David Tsenter")
	let c4 = ContactObject(photo: nil, name: "Jon Galaperin")
    let c5 = ContactObject(photo: nil, name: "Jack")
    let c6 = ContactObject(photo: nil, name: "Bill")
    let c7 = ContactObject(photo: nil, name: "Alex")
    let c8 = ContactObject(photo: nil, name: "Jose")
	var contacts : [ContactObject] = []
	var peers : [ContactObject] = []
	
	convenience init (contacts : [ContactObject], peers : [ContactObject]) {
		self.init()

		self.peers =  peers  + [c1,c2,c3,c6] // TODO: Change to params
		self.contacts =  contacts + [c4,c8,c7,c5]

        self.curX = center.x
        self.curY = center.y

		self.backgroundColor = UIColor.whiteColor()
		self.clearsContextBeforeDrawing = true
		self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "scale:"))
		self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "pan:"))
	}

	
    private struct Constants {
        static let nodeRadius: CGFloat = 20
    }
    
    func scale(gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed {
            known = true
            scale *= gesture.scale
            //trying to fix scaling
            //deltaX += (scale/10)
            //deltaY += (scale/10)
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
		} else if gesture.state == .Changed {
			known = true
			let place = gesture.locationInView(self)
            let x = (place.x - initPoint.x)
            let y = (place.y - initPoint.y)
            
            deltaX = shiftPoint.x + x
            deltaY = shiftPoint.y + y
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
	
	var contactsPulled = 0
	var peersPulled = 0
    private func drawNode(endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: endPoint, radius: Constants.nodeRadius , startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = strokeWidth
		
		// stephen can't believe this works, yet understands how shitty it really is
		
		let contact : ContactObject!
		if contactsPulled != contacts.count {
			contact = contacts[contactsPulled]
			contactsPulled++
		} else {
			contact = peers[peersPulled]
			peersPulled++
		}
		
		
		if let photoData = contact.photo {
			let imageView = ContactImageNode(image: UIImage(data: photoData)!)
			imageView.layer.cornerRadius = Constants.nodeRadius
			imageView.frame = CGRectMake(CGPathGetPathBoundingBox(path.CGPath).origin.x + 2, CGPathGetPathBoundingBox(path.CGPath).origin.y + 2 , Constants.nodeRadius * 2 - 4 , Constants.nodeRadius * 2 - 4)
			imageView.addGestureRecognizer(UITapGestureRecognizer(target: self.controller, action: "didTapNode:"))
			imageView.contact = contact
			imageView.userInteractionEnabled = true
			
			self.addSubview(imageView)
		} else {
			let imageView = ContactImageNode(image: UIImage(named: "placeholder.jpeg")!)
			imageView.layer.cornerRadius = Constants.nodeRadius
			imageView.frame = CGRectMake(CGPathGetPathBoundingBox(path.CGPath).origin.x + 2, CGPathGetPathBoundingBox(path.CGPath).origin.y + 2, Constants.nodeRadius * 2 - 4, Constants.nodeRadius * 2 - 4)
			imageView.addGestureRecognizer(UITapGestureRecognizer(target: self.controller, action: "didTapNode:"))
			imageView.contact = contact
			imageView.userInteractionEnabled = true

			self.addSubview(imageView)
		}
        return path
    }
    
    //TODO: randomize which cat picture is a placeholder
	
	
	
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
		// Clean up first then redraw
		contactsPulled = 0
		peersPulled = 0
		subviews.forEach { $0.removeFromSuperview() }
		allNodes.forEach { $0.removeAllPoints() }
		allLines.forEach { $0.removeAllPoints() }
		allLines = []
		allNodes = []
		
		let nodeCount = contacts.count + peers.count
        curX = center.x + deltaX
        curY = center.y + deltaY
		//    print("\(curX) \(curY)")
        drawBinaryTree(-90 , x: curX , y: curY, iter: CGFloat(findHighestSumOfTwoPower(nodeCount)) + 1)
        numberOfContactsDrawn = 0
    }
}

