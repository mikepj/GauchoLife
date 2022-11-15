//
//  LifeDrawing.swift
//  Gaucho Life
//
//  Created by Mike Piatek-Jimenez on 11/15/22.
//  Copyright © 2022 Mike Piatek-Jimenez. All rights reserved.
//

import Cocoa

protocol LifeDrawing {
    func draw(board: LifeBoard, blockSize: CGFloat, in rect: NSRect)
}

extension LifeDrawing {
    
    func draw(board: LifeBoard, blockSize: CGFloat, in rect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        context.saveGState()
        context.setFillColor(NSColor(calibratedRed: 0.08, green: 0.08, blue: 0.123, alpha: 1).cgColor)
        context.fill(NSRectToCGRect(rect))

        for x in 0..<Int(board.width) {
            for y in 0..<Int(board.height) {
                if board.cell(x, y) {
                    board.setColor(context, x, y)

                    let cellRect = CGRect(x: CGFloat(x) * blockSize, y: CGFloat(y) * blockSize, width: blockSize, height: blockSize)
                    context.fillEllipse(in: cellRect)
                }
            }
        }

        context.restoreGState()
    }
    
}
