//
//  ViewController.swift
//  MapBoxDemoApp
//
//  Created by Sumedh Ravi on 06/11/17.
//  Copyright © 2017 Sumedh Ravi. All rights reserved.
//

import UIKit
import Mapbox


class ViewController: UIViewController,MGLMapViewDelegate, UIGestureRecognizerDelegate {
    
    var mapView : MGLMapView?
    var annotation : CustomAnnotation?
    var annotationView : CustomAnnotationView?
    var radius = 250.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
                
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView?.userTrackingMode = .follow
        view.addSubview(mapView!)
        
        mapView?.delegate = self
        mapView?.showsUserLocation = true
        initGestureRecognizer()
        
        let button = UIButton(frame: CGRect(x: 10, y: 30, width: 100, height: 30))
        button.setTitle("Edit", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .blue
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        mapView?.addSubview(button)
        
        
        
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initGestureRecognizer(){
        let mapTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        for recognizer in mapView!.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            mapTapGestureRecognizer.require(toFail: recognizer)
        }
        mapView?.addGestureRecognizer(mapTapGestureRecognizer)
        
    }

    @objc func handleTapGesture(sender: UITapGestureRecognizer){
        let point = sender.location(in: self.mapView)
        let tapPoint = mapView?.convert(point, toCoordinateFrom: self.view)

        guard let annotationPoint = tapPoint else{return}
        if (annotation == nil) {
            
            annotation = CustomAnnotation(coordinate: annotationPoint, title: "Custom Point Annotation", subtitle: nil)
            annotation?.reuseIdentifier = "CustomAnnotation"
           
        }
        else{
            mapView?.removeAnnotation(annotation!)
        }
        annotation?.coordinate = annotationPoint
        self.mapView?.addAnnotation(annotation!)
//        DispatchQueue.main.async{
//        self.mapView?.addAnnotation(self.annotation!)
//        }
    }
    
    @objc func editButtonPressed(){
        guard mapView != nil else{return}
        mapView!.isScrollEnabled = !(mapView!.isScrollEnabled)
            
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if let pointAnnotation = annotation as? CustomAnnotation, let reuseIdentifier = pointAnnotation.reuseIdentifier {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) {
                // The annotatation view has already been cached, just reuse it.
                
                return annotationView
            } else {
                // Create a new annotation image.
                let radiusPoints = mapView.metersPerPoint(atLatitude: annotation.coordinate.latitude)
                annotationView = CustomAnnotationView(annotation: pointAnnotation, reuseIdentifier: reuseIdentifier, radius: radius/radiusPoints)
                return annotationView
                
            }
        }
        
        return nil
    }
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        if let pointAnnotationView = annotationView {
            let radiusPoints = pointAnnotationView.radiusOfCircle / mapView.metersPerPoint(atLatitude: (annotation?.coordinate.latitude)!)
            var newRadius = radiusPoints
//            newRadius = min(500,newRadius)
//            newRadius = max(20,newRadius)
            pointAnnotationView.scale(newRadius: radiusPoints)
//            pointAnnotationView.transform.scaledBy(x: CGFloat(radiusPoints/pointAnnotationView.radiusOfCircle), y: CGFloat(radiusPoints/pointAnnotationView.radiusOfCircle))
            pointAnnotationView.scale(newRadius: radiusPoints)
            
        }
    
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        <#code#>
    }
   
    
}

