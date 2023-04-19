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
        
        @Argument var width:Int
        @Argument var height:Int
        var pixelData:[UInt8] = []
        
        mutating func run() {
            for _ in 0..<height {
                for _ in 0..<width {
                    pixelData.append(0x77)
                    pixelData.append(0x00)
                    pixelData.append(UInt8.random(in: 0...UInt8.max))
                    pixelData.append(0xFF)
                }
            }
            let data = try? SwiftLIBPNG.buildSimpleDataExample(width: 5, height: 3, pixelData: pixelData)
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
