//
//  LifeModel.swift
//  Gaucho Life
//
//  Created by Mike Piatek-Jimenez on 9/10/18.
//  Copyright © 2018 Gaucho Software, LLC.
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
import Cocoa

@objc public class LifeModel: NSObject {

    var blockSize: CGFloat = 24 {
        didSet {
            // This will trigger a reset in the next draw loop.
            lastRect = nil
        }
    }
    
    var board: LifeBoard?
    
    private var lastRect: NSRect?
    private var iterationsSinceReset: Int = 0
    private let maxIterationsSinceReset: Int = 500
    
    @objc public func draw(in rect: NSRect) {
        if lastRect != rect {
            reset(viewSize: rect.size)
            lastRect = rect
        }

        if iterationsSinceReset > maxIterationsSinceReset {
            reset(viewSize: rect.size)
        }

        guard let board = board else { return }

        guard let context = NSGraphicsContext.current?.cgContext else { return }
        context.saveGState()
        context.setFillColor(NSColor.black.cgColor)
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
    
    @objc private func reset(viewSize: CGSize) {
        board = LifeBoard(width: UInt(viewSize.width / blockSize), height: UInt(viewSize.height / blockSize))
        board?.nextDay()

        iterationsSinceReset = 0
    }
    
    @objc public func increment() {
        board?.nextDay()
        iterationsSinceReset += 1
    }
    
}

struct LifeBoard {
    static let palette = NSGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple])
    static let gradations: CGFloat = 64

    let width: UInt
    let height: UInt
    
    var grid: [Bool]

    var colors: [CGFloat]
    
    init(width: UInt, height: UInt) {
        self.width = width
        self.height = height
        
        var randomGrid = [Bool](repeating: false, count: Int(width * height))
        for index in 0..<Int(width*height) {
            randomGrid[index] = (arc4random() % 8 == 0)
        }
        
        grid = randomGrid

        colors = [CGFloat](repeating: 0, count: Int(width * height))
    }
    
    init?(width: UInt, height: UInt, grid: [Bool]) {
        guard grid.count == width * height else { return nil }
        
        self.width = width
        self.height = height
        self.grid = grid

        colors = [CGFloat](repeating: 0, count: Int(width * height))
    }
    
    mutating func nextDay() {
        let newGrid: [Bool] = grid.enumerated().map { (index, living) in
            // Count neighbors
            let neighbors = livingNeighbors(index: index)

            if living {
                if (neighbors == 2) || (neighbors == 3) {
                    colors[index] = min(colors[index] + (1 / LifeBoard.gradations), 1)
                    return true
                }
            }
            else if neighbors == 3 {
                colors[index] = min(colors[index] + (1 / LifeBoard.gradations), 1)
                return true
            }
            
            colors[index] = 0
            return false
        }
        
        grid = newGrid
    }
    
    func cell(_ x: Int, _ y: Int) -> Bool {
        return cell(index: y * Int(width) + x)
    }

    func setColor(_ context: CGContext, _ x: Int, _ y: Int) {
        guard let color = LifeBoard.palette?.interpolatedColor(atLocation: colors[y * Int(width) + x]).cgColor else { return }
        context.setFillColor(color)
    }

    private func cell(index: Int) -> Bool {
        guard index >= 0, index < width * height else { return false }
        return grid[index]
    }
    
    private func livingNeighbors(index: Int) -> Int {
        let upperRowIndex = index - Int(width)
        let lowerRowIndex = index + Int(width)
        
        return
            (cell(index: upperRowIndex - 1) ? 1 : 0) +
            (cell(index: upperRowIndex) ? 1 : 0) +
            (cell(index: upperRowIndex + 1) ? 1 : 0) +
            (cell(index: index - 1) ? 1 : 0) +
            (cell(index: index + 1) ? 1 : 0) +
            (cell(index: lowerRowIndex - 1) ? 1 : 0) +
            (cell(index: lowerRowIndex) ? 1 : 0) +
            (cell(index: lowerRowIndex + 1) ? 1 : 0)
    }
}
