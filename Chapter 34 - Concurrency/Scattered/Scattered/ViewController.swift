//
//  ViewController.swift
//  Scattered
//
//  Created by Juan Pablo Claude on 2/26/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var textLayer: CATextLayer!
    var text: String? {
        didSet {
            let font = NSFont.systemFontOfSize(textLayer.fontSize)
            let attributes = [NSFontAttributeName : font]
            var size = text?.sizeWithAttributes(attributes) ?? CGSize.zero
            // Ensure that the size is in whole numbers:
            size.width = ceil(size.width)
            size.height = ceil(size.height)
            textLayer.bounds = CGRect(origin: CGPoint.zero, size: size)
            textLayer.superlayer!.bounds = CGRect(x: 0, y: 0, width: size.width + 16, height: size.height + 20)
            textLayer.string = text
        }
    }
    
    
    let processingQueue: NSOperationQueue = {
        let result = NSOperationQueue()
        //result.maxConcurrentOperationCount = 4
        return result
    }()
    
    
    func addImagesFromFolderURL(folderURL: NSURL) {
        processingQueue.addOperationWithBlock {
            let t0 = NSDate.timeIntervalSinceReferenceDate()
            
            let fileManager = NSFileManager()
            let directoryEnumerator = fileManager.enumeratorAtURL(folderURL,
                                      includingPropertiesForKeys: nil,
                                                         options: [],
                                                    errorHandler: nil)!
            
            while let url = directoryEnumerator.nextObject() as? NSURL {
                // Skip directories:
                
                var isDirectoryValue: AnyObject?
                do {
                    try url.getResourceValue(&isDirectoryValue,
                        forKey: NSURLIsDirectoryKey)
                } catch {
                    print("error checking whether URL is directory: \(error)")
                    continue
                }
                
                self.processingQueue.addOperationWithBlock {
                    guard let isDirectory = isDirectoryValue as? Bool where
                        isDirectory == false else {
                            return
                    }
                
                    guard let image = NSImage(contentsOfURL: url) else {
                        return
                    }
                    
                    let thumbImage = self.thumbImageFromImage(image)
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.presentImage(thumbImage)
                        let t1 = NSDate.timeIntervalSinceReferenceDate()
                        let interval = t1 - t0
                        self.text = String(format: "%0.1fs", interval)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set view to be layer-hosting:
        view.layer = CALayer()
        view.wantsLayer = true
        
        let textContainer = CALayer()
        textContainer.anchorPoint = CGPoint.zero
        
        textContainer.position = CGPointMake(10, 10)
        textContainer.zPosition = 100
        textContainer.backgroundColor = NSColor.blackColor().CGColor
        textContainer.borderColor = NSColor.whiteColor().CGColor
        textContainer.borderWidth = 2
        textContainer.cornerRadius = 15
        textContainer.shadowOpacity = 0.5
        view.layer!.addSublayer(textContainer)
        
        let textLayer = CATextLayer()
        textLayer.anchorPoint = CGPoint.zero
        textLayer.position = CGPointMake(10, 6)
        textLayer.zPosition = 100
        textLayer.fontSize = 24
        textLayer.foregroundColor = NSColor.whiteColor().CGColor
        self.textLayer = textLayer
        
        textContainer.addSublayer(textLayer)
        
        // Rely on text's didSet to update textLayer's bounds:
        text = "Loading..."
        
        let url = NSURL.fileURLWithPath("/Library/Desktop Pictures", isDirectory: true)
        addImagesFromFolderURL(url)
    }
    
    
    func thumbImageFromImage(image: NSImage) -> NSImage {
        let targetHeight: CGFloat = 200.0
        let imageSize = image.size
        let smallerSize = NSSize(width: targetHeight * imageSize.width / imageSize.height, height: targetHeight)
        
        let smallerImage = NSImage(size: smallerSize,
                                   flipped: false) { (rect) -> Bool in
                                        image.drawInRect(rect)
                                        return true
        }
        
        return smallerImage
   }
    
    
    func presentImage(image: NSImage) {
        let superlayerBounds = view.layer!.bounds
            
        let center = CGPoint(x: superlayerBounds.midX, y: superlayerBounds.midY)
            
        let imageBounds = CGRect(origin: CGPoint.zero, size: image.size)
            
        let randomPoint =
            CGPoint(x: CGFloat(arc4random_uniform(UInt32(superlayerBounds.maxX))),
                    y: CGFloat(arc4random_uniform(UInt32(superlayerBounds.maxY))))
            
        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
        let positionAnimation = CABasicAnimation()
        positionAnimation.fromValue = NSValue(point: center)
        positionAnimation.duration = 1.5
        positionAnimation.timingFunction = timingFunction
            
        let boundsAnimation = CABasicAnimation()
        boundsAnimation.fromValue = NSValue(rect: CGRect.zero)
        boundsAnimation.duration = 1.5
        boundsAnimation.timingFunction = timingFunction
        
        let layer = CALayer()
        layer.contents = image
        layer.actions = ["position" : positionAnimation,
                         "bounds"   : boundsAnimation]
            
        CATransaction.begin()
        view.layer!.addSublayer(layer)
        layer.position = randomPoint
        layer.bounds = imageBounds
        CATransaction.commit()
    }
    
    
}

