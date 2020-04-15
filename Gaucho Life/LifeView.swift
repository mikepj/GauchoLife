//
//  LifeView.swift
//  Gaucho Life
//
//  Created by Mike Piatek-Jimenez on 9/10/18.
//  Copyright © 2018 Mike Piatek-Jimenez. All rights reserved.
//

import Cocoa

class LifeView: NSView {
    
    let model = LifeModel()
    
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { [weak self] (_) in
            guard let self = self else { return }
            
            self.model.increment()
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        model.draw(in: self.bounds)
    }
    
}
