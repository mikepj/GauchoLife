//
//  LifeSaverView.swift
//  Gaucho Life
//
//  Created by Mike Piatek-Jimenez on 11/15/22.
//  Copyright © 2022 Mike Piatek-Jimenez. All rights reserved.
//

import Foundation
import ScreenSaver

/// There isn't a separate NSViewController for a ScreenSaverView, so this class performs controller actions as well.
class LifeSaverView: ScreenSaverView, LifeDrawing {
    
    private var timer: Timer?
    private var model = LifeModel()
    private var lastRect: NSRect?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.model.increment()
        }
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        if lastRect != rect {
            model.reset(
                boardWidth: UInt(frame.width / model.blockSize),
                boardHeight: UInt(frame.height / model.blockSize)
            )
            lastRect = rect
        }

        guard let board = model.board else { return }
        draw(board: board, blockSize: model.blockSize, in: bounds)
    }
    
    override func animateOneFrame() {
        setNeedsDisplay(bounds)
    }
    
    override var hasConfigureSheet: Bool { false }
    override var configureSheet: NSWindow? { nil }
}
