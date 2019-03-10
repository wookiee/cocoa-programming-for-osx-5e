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
            let font = NSFont.systemFont(ofSize: textLayer.fontSize)
            let attributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font) : font]
            var size = text?.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attributes)) ?? CGSize.zero
            // Ensure that the size is in whole numbers:
            size.width = ceil(size.width)
            size.height = ceil(size.height)
            textLayer.bounds = CGRect(origin: CGPoint.zero, size: size)
            textLayer.superlayer!.bounds
                = CGRect(x: 0, y: 0, width: size.width + 16, height: size.height + 20)
            textLayer.string = text
        }
    }
    
    
    func addImagesFromFolderURL(_ folderURL: URL) {
        let t0 = Date.timeIntervalSinceReferenceDate
        
        let fileManager = FileManager()
        let directoryEnumerator = fileManager.enumerator(at: folderURL,
                                  includingPropertiesForKeys: nil,
                                                     options: [],
                                                errorHandler: nil)!
        
        var allowedFiles = 10
        
        while let url = directoryEnumerator.nextObject() as? URL {
            // Skip directories:
            
            var isDirectoryValue: AnyObject?
            do {
                try (url as NSURL).getResourceValue(&isDirectoryValue,
                                 forKey: URLResourceKey.isDirectoryKey)
            } catch {
                print("error checking whether URL is directory: \(error)")
                continue
            }
            
            guard let isDirectory = isDirectoryValue as? Bool,
                  isDirectory == false else {
                    continue
            }
            
            guard let image = NSImage(contentsOf: url) else {
                continue
            }
            
            allowedFiles -= 1
            guard allowedFiles >= 0 else {
                break
            }
            
            let thumbImage = thumbImageFromImage(image)
            
            presentImage(thumbImage)
            let t1 = Date.timeIntervalSinceReferenceDate
            let interval = t1 - t0
            text = String(format: "%0.1fs", interval)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set view to be layer-hosting:
        view.layer = CALayer()
        view.wantsLayer = true
        
        let textContainer = CALayer()
        textContainer.anchorPoint = CGPoint.zero
        textContainer.position = CGPoint(x: 10, y: 10)
        textContainer.zPosition = 100
        textContainer.backgroundColor = NSColor.black.cgColor
        textContainer.borderColor = NSColor.white.cgColor
        textContainer.borderWidth = 2
        textContainer.cornerRadius = 15
        textContainer.shadowOpacity = 0.5
        view.layer!.addSublayer(textContainer)
        
        let textLayer = CATextLayer()
        textLayer.anchorPoint = CGPoint.zero
        textLayer.position = CGPoint(x: 10, y: 6)
        textLayer.zPosition = 100
        textLayer.fontSize = 24
        textLayer.foregroundColor = NSColor.white.cgColor
        self.textLayer = textLayer
        
        textContainer.addSublayer(textLayer)
        
        // Rely on text's didSet to update textLayer's bounds:
        text = "Loading..."
        
        let url = URL(fileURLWithPath: "/Library/Desktop Pictures",
                            isDirectory: true)
        addImagesFromFolderURL(url)
    }
    
    
    func thumbImageFromImage(_ image: NSImage) -> NSImage {
        let targetHeight: CGFloat = 200.0
        let imageSize = image.size
        let smallerSize
            = NSSize(width: targetHeight * imageSize.width / imageSize.height,
                    height: targetHeight)
        
        let smallerImage = NSImage(size: smallerSize,
                                flipped: false) { rect -> Bool in
                                        image.draw(in: rect)
                                        return true
        }
        
        return smallerImage
    }
    
    
    func presentImage(_ image: NSImage) {
        let superlayerBounds = view.layer!.bounds
        
        let center = CGPoint(x: superlayerBounds.midX, y: superlayerBounds.midY)
        
        let imageBounds = CGRect(origin: CGPoint.zero, size: image.size)
        
        let randomPoint =
            CGPoint(x: CGFloat(arc4random_uniform(UInt32(superlayerBounds.maxX))),
                    y: CGFloat(arc4random_uniform(UInt32(superlayerBounds.maxY))))
        
        let timingFunction
            = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
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
        layer.actions =
            ["position" : positionAnimation,
             "bounds"   : boundsAnimation]
        
        CATransaction.begin()
        view.layer!.addSublayer(layer)
        layer.position = randomPoint
        layer.bounds = imageBounds
        CATransaction.commit()
    }
    
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
