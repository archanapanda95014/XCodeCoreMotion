//
//  ViewController.swift
//  Mirage
//
//  Created by Archana Panda on 9/6/18.
//  Copyright © 2018 Archana Panda. All rights reserved.
//

import UIKit
import CoreMotion

extension Double {
    func toCGFloat() -> CGFloat {
        let myFloat = NSNumber.init(value: self).floatValue
        return CGFloat(myFloat)
    }
}

class ImageRing {
    var images: [UIImageView] = []
    var radius: Double
    var center: CGPoint
    
    init(baseImageView: UIImageView, numImage: Int, radius: Double, center:CGPoint, toView view: UIView){
        self.radius = radius
        self.center = center
        
        // Make images
        for i in 0..<numImage {
            let thisImage = UIImageView()

            thisImage.image = baseImageView.image
            
            thisImage.frame = CGRect(
                x: radius * cos(Double(i)/Double(numImage) * 2 * Double.pi) + Double(center.x),
                y: radius * sin(Double(i)/Double(numImage) * 2 * Double.pi) + Double(center.y),
                width: 50,
                height:50)
            
            self.images.append(thisImage)
            view.addSubview(thisImage)
        }
    }
    
    func updateRadius(_ radius: Double) {
        self.radius = radius
        print("RADIUS: \(self.radius)")
        for i in 0..<images.count {
//            images[i].transform = CGAffineTransform(
//                translationX: 20.toCGFloat(), y: 100.0.toCGFloat()
////                translationX: (
////                    radius *
////                    cos(
////                        Double(i) / Double(images.count)
////                        * 2 * Double.pi
////                        )
////                    + Double(center.x)
////                    )
////                    .toCGFloat(),
////                y: (
////                    radius *
////                    sin(
////                        Double(i) / Double(images.count)
////                        * 2 * Double.pi
////                        )
////                    + Double(center.x)
////                    )
////                    .toCGFloat()
//            )
            
            images[i].frame = CGRect(
                x: radius * cos(Double(i)/Double(images.count) * 2 * Double.pi) + Double(center.x),
                y: radius * sin(Double(i)/Double(images.count) * 2 * Double.pi) + Double(center.y),
                width: 50,
                height:50)
        } // endfor
    }
}
class ViewController: UIViewController {
    
    @IBOutlet weak var testImage: UIImageView!
    
    let newImage =  UIImage(named: "test2")
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()

   
    
    
    func rotateImage(targetView: UIImageView, byRadians rotateRad: Double) {
        targetView.transform = CGAffineTransform(
            rotationAngle: CGFloat(rotateRad * 3)
        )
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgRing = ImageRing(
            baseImageView: testImage,
            numImage: 6,
            radius: 75,
            center: view.center,
            toView: view
        )
        
        testImage.isHidden = true
        if motionManager.isDeviceMotionAvailable {
            print("We can detect device motion")
            startReadingMotionData(imgRing)
        }
        else {
            print("We cannot detect device motion")
        }
        print(Thread.isMainThread)
        
        
    }
    
    
    func startReadingMotionData(_ imgRing: ImageRing) {
        // set read speed
        print(Thread.isMainThread)
        motionManager.deviceMotionUpdateInterval = 0.1
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in

            if let mydata = data {
//                print("mydata", mydata.gravity)
//                print("pitch raw", mydata.attitude.pitch)
//                print("DEGREES: \(self.degrees(mydata.attitude.pitch))")
//                print(Thread.isMainThread)
                DispatchQueue.main.async {
                    imgRing.updateRadius(mydata.attitude.pitch * 1000)
                    for image in imgRing.images {
                        self.rotateImage(targetView: image, byRadians: mydata.attitude.pitch)
                    }
                }
            }
        }
    }
    


    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    
}



