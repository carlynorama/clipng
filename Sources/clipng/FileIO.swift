//
//  File.swift
//  
//
//  Created by Labtanza on 4/19/23.
//

import Foundation


struct FileIO {
   
    static func timeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd'T'HHmmss"
        if #available(macOS 12, *) {
            return formatter.string(from: Date.now)
        } else {
            return formatter.string(from: Date.init(timeIntervalSinceReferenceDate: Date.timeIntervalSinceReferenceDate))
        }
    }
    
    static func writeDataToFile(data:Data , filePath:String) throws {
        //TODO: For iOS?? 
        //let locationToWrite = URL.documentsDirectory.appendingPathComponent("testImage", conformingTo: .png)
        
        if #available(macOS 13.0, *) {
            try data.write(to: URL(filePath: filePath))
        } else {
            // Fallback on earlier versions
            try data.write(to:URL(fileURLWithPath: filePath))
        }
        
        
        
    }
}
