//
//  ScreenshotFramer.swift
//  FrameScreenshot
//
//  Created by Lukasz on 10/01/2024.
//

import Foundation
import CoreGraphics
import AppKit
import Cocoa

enum FramingError: Error {
    case defaultError
}

struct ScreenshotFramer {
    func frameScreenshot(file: URL) -> Result<Any, FramingError> {
        let inputImage = NSImage(contentsOf: file)!
        
        let image = drawRectangleOnImage(srcImage: inputImage)
        
        guard let data = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: data),
              let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {

            return .failure(.defaultError)
        }

        do {
            try imgData.write(to: file, options: .atomic)
        } catch _ {
            return .failure(.defaultError)
        }
        
        return .success(true)
    }
                           
    func drawRectangleOnImage(srcImage: NSImage) -> NSImage {
        let bounds = CGRectMake(0, 0, srcImage.size.width, srcImage.size.height)
        _ = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        let cgImage = srcImage.CGImage
        
        let ctx = CGContext(data: nil,
                            width: cgImage.width,
                            height: cgImage.height,
                            bitsPerComponent: cgImage.bitsPerComponent,
                            bytesPerRow: cgImage.bytesPerRow,
                            space: cgImage.colorSpace!,
                            bitmapInfo: bitmapInfo.rawValue)!
        
        ctx.draw(cgImage, in: bounds)
        
        ctx.setStrokeColor(.black)
        ctx.stroke(bounds, width: 1)
        
        let resultCGimage = ctx.makeImage()
        ctx.draw(resultCGimage!, in: bounds)//    CGContextDrawImage(ctx, bounds, resultCGimage)
        return NSImage(cgImage: resultCGimage!, size: NSSize(width: srcImage.size.width, height: srcImage.size.height))
    }
    
//    func drawRectangleOnImage(image: NSImage) -> NSImage {
//        let imageSize = image.size
//        let scale: CGFloat = 0
//        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
//
//        image.draw(at: CGPoint.zero)
//
//        let rectangle = CGRect(x: 0, y: (imageSize.height/2) - 30, width: imageSize.width, height: 60)
//
//        UIColor.black.setFill()
//        UIRectFill(rectangle)
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
}

extension NSImage {
    var CGImage: CGImage {
        get {
            let imageData = self.tiffRepresentation!
            let source = CGImageSourceCreateWithData(imageData as CFData, nil).unsafelyUnwrapped
            let maskRef = CGImageSourceCreateImageAtIndex(source, Int(0), nil)
            return maskRef.unsafelyUnwrapped
        }
    }
}
