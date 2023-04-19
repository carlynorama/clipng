//
//  File.swift
//  
//
//  Created by Carlyn Maw on 4/19/23.
//

import Foundation


struct PixelGenerator {
    static func purple_pixels_RGBA(width:Int, height:Int) -> [UInt8] {
        var pixelData:[UInt8] = []
        //TODO: would for _ in 0..<multWH be faster? 
        for _ in 0..<height {
            for _ in 0..<width {
                pixelData.append(0x77)
                pixelData.append(0x00)
                pixelData.append(UInt8.random(in: 0...UInt8.max))
                pixelData.append(0xFF)
            }
        }
        return pixelData
    }
    
    static func purple_pixels_RGB(width:Int, height:Int) -> [UInt8] {
        var pixelData:[UInt8] = []
        //TODO: would for _ in 0..<multWH be faster?
        for _ in 0..<height {
            for _ in 0..<width {
                pixelData.append(0x77)
                pixelData.append(0x00)
                pixelData.append(UInt8.random(in: 0...UInt8.max))
            }
        }
        return pixelData
    }
}
