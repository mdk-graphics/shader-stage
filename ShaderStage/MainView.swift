//
//  MainView.swift
//  ShaderStage
//
//  Created by Michael Dominic K. on 01/11/2022.
//

import Foundation
import AppKit

class MainView: NSView {
    var inputImage: NSImage?
    var processedImage: CGImage?
    
    var aValue: Double = 0 {
        didSet {
            self.setNeedsDisplay(.infinite)
        }
    }
    
    var bValue: Double = 0 {
        didSet {
            self.setNeedsDisplay(.infinite)
        }
    }
    
    override func awakeFromNib() {
        inputImage = NSImage(named: "Input")
    }
    
    func processImage() {
        guard let cgImage = inputImage?.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            fatalError()
        }
        
        // Ensure pixel format is proper, the only one we support right now
        if cgImage.bitsPerComponent != 8 {
            fatalError()
        }
       
        // We only support RGBA (32bit) input for now.
        if cgImage.alphaInfo == .alphaOnly || cgImage.alphaInfo == .none {
            fatalError()
        }
        
        self.processedImage = ProcessCGImage(cgImage, Float(self.aValue), Float(self.bValue)).takeRetainedValue()
    }
    
    func getTiffProcessedImage() -> Data? {
        guard let cgImage = processedImage else {
            return nil
        }
        
        return NSImage(cgImage: cgImage,
                       size: .init(width: cgImage.width, height: cgImage.height)).tiffRepresentation(using: .lzw, factor: 1.0)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.processImage()
        
        guard let cgImage = processedImage else {
            return
        }
        
        guard let context = NSGraphicsContext.current else {
            return
        }
        
        let bounds = CGRect(x: 0, y: 0,
                            width: CGFloat(cgImage.width) * 0.5,
                            height: CGFloat(cgImage.height) * 0.5)
        context.cgContext.draw(cgImage, in: bounds)
    }
}
