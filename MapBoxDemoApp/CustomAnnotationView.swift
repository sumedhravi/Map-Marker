//
//  CustomAnnotationView.swift
//  MapBoxDemoApp
//
//  Created by Sumedh Ravi on 06/11/17.
//  Copyright © 2017 Sumedh Ravi. All rights reserved.
//

import UIKit
import Mapbox

class CustomAnnotationView: MGLAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let lineWidth = 3.0
    let minRadius = 20.0
    let maxRadius = 500
    var radiusOfCircle = 0.0
    var inResizeArea : Bool = true
    
    init(annotation: MGLAnnotation?, reuseIdentifier: String?,radius: Double) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        bounds = CGRect(x: 0, y: 0, width: 2*radius, height: 2*radius)
//        let rect = CGRect(origin: CGPoint(x: Double() - radius, y: Double(origin.y) - radius), size: CGSize(width: radius * 2, height: radius * 2))
        
        
//        super.init(frame: rect)
        
        initGestureRecognizer()
        self.backgroundColor = .clear
        self.radiusOfCircle = radius
        self.clipsToBounds = true

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let insetRect = rect.insetBy(dx: CGFloat(lineWidth/2), dy: CGFloat(lineWidth/2))
        let path = UIBezierPath(ovalIn: insetRect)
        path.lineWidth = CGFloat(lineWidth)
        UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).setFill()
        UIColor.black.setStroke()
        path.fill()
        path.stroke()
        
    }
    
    func initGestureRecognizer(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRadiusChange))
        addGestureRecognizer(panGesture)
    }
    
    
    @objc func handleRadiusChange(pan: UIPanGestureRecognizer){
        switch pan.state {
        case .began:
            
            self.superview!.bringSubview(toFront: self)
            inResizeArea = pan.location(in: self).x < CGFloat(bounds.width/2)
        case.changed:
            
            
            print(inResizeArea)
            
            let dx = pan.translation(in: self.superview).x
            var newRadius = radiusOfCircle + Double((inResizeArea ? -1 : 1)*dx)
            newRadius = min(Double(maxRadius),newRadius)
            newRadius = max(minRadius,newRadius)
            print("New radius:\(newRadius)")
            scale(newRadius: newRadius)
            pan.setTranslation(CGPoint.zero, in: self)
            
        default: break
            
            
        }
    }
        
    func scale(newRadius: Double){
            let scale = newRadius/radiusOfCircle
            transform = transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
        radiusOfCircle = newRadius
        print("Radius:\(radiusOfCircle)")
        
        }
    
    
    
    

}
