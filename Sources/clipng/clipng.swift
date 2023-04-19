import Foundation
import ArgumentParser
import SwiftLIBPNG

@main
struct clipng:ParsableCommand {
    static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "A interface for testing SwiftLIBPNG.",
        
        // Commands can define a version for automatic '--version' support.
        version: "0.0.1",
        subcommands: [random_purple.self, Multiply.self],
        defaultSubcommand: random_purple.self)
}

struct Options: ParsableArguments {
    @Flag(name: [.customLong("hex-output"), .customShort("x")],
          help: "Use hexadecimal notation for the result.")
    var hexadecimalOutput = false
    
    @Argument(
        help: "A group of integers to operate on.")
    var values: [Int] = []
}

extension clipng {
    static func format(_ result: Int, usingHex: Bool) -> String {
        usingHex ? String(result, radix: 16)
        : String(result)
    }
    
    struct random_purple: ParsableCommand {
        
        static var configuration =
        CommandConfiguration(abstract: "Generate a RGBA PNG file with each pixel a random shade of purple.")
        
        @Argument var width:UInt32
        @Argument var height:UInt32
        
        mutating func run() {
            let data = try? SwiftLIBPNG.buildSimpleDataExample(width: width, height: height, pixelData: PixelGenerator.purple_pixels_RGBA(width: Int(width), height: Int(height)))
            if let data {
                for item in data {
                    print(String(format: "0x%02x", item), terminator: "\t")
                }
                print()
                
                //                let locationToWrite = URL.documentsDirectory.appendingPathComponent("testImage", conformingTo: .png)
                //                do {
                //                    try data.write(to: locationToWrite)
                //                } catch {
                //                    print(error.self)
                //                }
            }
        }
    }
    
    struct Multiply: ParsableCommand {
        static var configuration =
        CommandConfiguration(abstract: "Print the product of the values.")
        
        @OptionGroup var options: Options
        
        mutating func run() {
            let result = options.values.reduce(1, *)
            print(format(result, usingHex: options.hexadecimalOutput))
        }
    }
}
