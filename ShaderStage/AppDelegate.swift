//
//  AppDelegate.swift
//  ShaderStage
//
//  Created by Michael Dominic K. on 01/11/2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet var sliderA: NSSlider!
    @IBOutlet var sliderB: NSSlider!
    @IBOutlet var mainView: MainView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainView.aValue = sliderA.doubleValue
        mainView.bValue = sliderB.doubleValue
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @IBAction func onSliderA(_ sender: AnyObject?) {
        mainView.aValue = sliderA.doubleValue
    }
    
    @IBAction func onSliderB(_ sender: AnyObject?) {
        mainView.bValue = sliderB.doubleValue
    }
    
    @IBAction func onCopyToClipboard(_ sender: AnyObject?) {
        let data = self.mainView.getTiffProcessedImage()
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setData(data, forType: .tiff)
    }
}

