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
    var annotation : MGLPointAnnotation?
    
    let initialRadius = 1000.0
    
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
       
        (annotation == nil) ? createAnnotation(center: annotationPoint): moveAnnotation(center: annotationPoint)
        
        
        
//        let layer = MGLCircleStyleLayer(identifier: "circles", source: population)
//        layer.sourceLayerIdentifier = "population"
//        layer.circleColor = MGLStyleValue(rawValue: .green)
//        layer.circleRadius = MGLStyleValue(interpolationMode: .exponential,
//                                           cameraStops: [12: MGLStyleValue(rawValue: 2),
//                                                         22: MGLStyleValue(rawValue: 180)],
//                                           options: [.interpolationBase: 1.75])
//        layer.circleOpacity = MGLStyleValue(rawValue: 0.7)
//        layer.predicate = NSPredicate(format: "%K == %@", "marital-status", "married")
//        mapView.style?.addLayer(layer)

        
        
//        if (annotation == nil){
//            annotation = CustomAnnotation(coordinate: annotationPoint, title: "Custom Point Annotation", subtitle: nil)
//            annotation?.reuseIdentifier = "CustomAnnotation"
//
//
//        }
//        else{
//            mapView?.removeAnnotation(annotation!)
//        }
//        annotation?.coordinate = annotationPoint
//        self.mapView?.addAnnotation(self.annotation!)
//        DispatchQueue.main.async{
//        self.mapView?.addAnnotation(self.annotation!)
//        }
        
        
    }
    
    @objc func editButtonPressed(){
        guard mapView != nil else{return}
        mapView!.isScrollEnabled = !(mapView!.isScrollEnabled)
            
    }
    
//    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
//        if let pointAnnotation = annotation as? CustomAnnotation, let reuseIdentifier = pointAnnotation.reuseIdentifier {
//            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) {
//                // The annotatation view has already been cached, just reuse it.
//
//                return annotationView
//            } else {
//                // Create a new annotation image.
//                return CustomAnnotationView(annotation: pointAnnotation, reuseIdentifier: reuseIdentifier, radius: initialRadius)
//            }
//        }
//        return nil
//    }
    
    func createAnnotation(center: CLLocationCoordinate2D){
        let point = MGLPointAnnotation()
        let source = MGLShapeSource(identifier: "circle", shape: point , options: nil)
        annotation = point
        mapView?.style?.addSource(source)
        
        let layer = MGLCircleStyleLayer(identifier: "circle", source: source)
        let radiusPoints = initialRadius / (mapView!.metersPerPoint(atLatitude: center.latitude))
        layer.circleRadius = MGLStyleValue(rawValue: NSNumber(value: radiusPoints))
        layer.circleColor = MGLStyleValue(rawValue: UIColor.red)
        layer.circleOpacity = MGLStyleValue(rawValue: 0.5)
        mapView?.style?.addLayer(layer)
        
        
    }
    
    func moveAnnotation(center: CLLocationCoordinate2D){
        annotation?.coordinate = center
    }
    
    func mapViewRegionIsChanging(_ mapView: MGLMapView) {
        if let layer = mapView.style?.layer(withIdentifier: "circle") as? MGLCircleStyleLayer, let pointAnnotation = annotation {
            let radiusPoints = initialRadius / mapView.metersPerPoint(atLatitude: pointAnnotation.coordinate.latitude)
            layer.circleRadius = MGLStyleValue(rawValue: NSNumber(value: radiusPoints))
        }
    }

    
    
    
    
   
}

