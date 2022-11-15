//
//  LifeSaverView.swift
//  Gaucho Life
//
//  Created by Mike Piatek-Jimenez on 11/15/22.
//  Copyright © 2022 Mike Piatek-Jimenez. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this
//     list of conditions and the following disclaimer in the documentation and/or
//     other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its contributors
//     may be used to endorse or promote products derived from this software without
//     specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//  OF THE POSSIBILITY OF SUCH DAMAGE.
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
