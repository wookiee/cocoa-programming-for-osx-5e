//
//  NerdTabViewController.swift
//  ViewControl
//
//  Created by Juan Pablo Claude on 2/20/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa


@objc
protocol ImageRepresentable {
    var image: NSImage? { get }
}


class NerdTabViewController : NSViewController {
    
    var box = NSBox()
    var buttons: [NSButton] = []
    
    
    func selectTabAtIndex(_ index: Int) {
        assert(index >= 0 && index < children.count, "index out of range")
        for (i, button) in buttons.enumerated() {
            button.state = (index == i) ? NSControl.StateValue.on : NSControl.StateValue.off
        }
        let viewController = children[index]
        box.contentView = viewController.view
    }
    
    
    @objc func selectTab(_ sender: NSButton) {
        let index = sender.tag
        selectTabAtIndex(index)
    }
    
    
    override func loadView() {
        view = NSView()
        reset()
    }
    
    
    func reset() {
        view.subviews = []
        let buttonWidth: CGFloat = 28
        let buttonHeight: CGFloat = 28
        
        let viewControllers = children
        buttons = viewControllers.enumerated().map {
            (index, viewController) -> NSButton in
            let button = NSButton()
            button.setButtonType(.toggle)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isBordered = false
            button.target = self
            button.action = #selector(NerdTabViewController.selectTab(_:))
            button.tag = index
            if let viewController = viewController as? ImageRepresentable {
                button.image = viewController.image
            }
            else {
                button.title = viewController.title!
            }
            button.addConstraints([
                NSLayoutConstraint(item: button,
                              attribute: .width,
                              relatedBy: .equal,
                                 toItem: nil,
                              attribute: .notAnAttribute,
                             multiplier: 1.0,
                               constant: buttonWidth),
                NSLayoutConstraint(item: button,
                              attribute: .height,
                              relatedBy: .equal,
                                 toItem: nil,
                              attribute: .notAnAttribute,
                             multiplier: 1.0,
                               constant: buttonHeight)
                ])
            return button
        }
        
            let stackView = NSStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.orientation = .horizontal
            stackView.spacing = 4
            for button in buttons {
                stackView.addView(button, in: .center)
            }
            
            box.translatesAutoresizingMaskIntoConstraints = false
            box.borderType = .noBorder
            box.boxType = .custom
            
            let separator = NSBox()
            separator.boxType = .separator
            separator.translatesAutoresizingMaskIntoConstraints = false
            
            view.subviews = [stackView, separator, box]
            
            let views = ["stack": stackView, "separator": separator, "box": box]
            let metrics = ["buttonHeight": buttonHeight]
            
            func addVisualFormatConstraints(_ visualFormat:String) {
                let constraints =
                NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                      options: [],
                                                      metrics: metrics as [String : NSNumber],
                                                        views: views)
                NSLayoutConstraint.activate(constraints)
            }
            addVisualFormatConstraints("H:|[stack]|")
            addVisualFormatConstraints("H:|[separator]|")
            addVisualFormatConstraints("H:|[box(>=100)]|")
            addVisualFormatConstraints("V:|[stack(buttonHeight)][separator(==1)][box(>=100)]|")
            
            if children.count > 0 {
                selectTabAtIndex(0)
            }
        
    }
    
    
    override func insertChild(_ childViewController: NSViewController,
                                                  at index: Int) {
        super.insertChild(childViewController, at: index)
        if isViewLoaded {
        reset()
        }
    }
    
    
    override func removeChild(at index: Int) {
        super.removeChild(at: index)
        if isViewLoaded {
        reset()
        }
    }
}
