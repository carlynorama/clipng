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
        subcommands: [random_purple.self],
        defaultSubcommand: random_purple.self)
}

struct Flags: ParsableArguments {
    @Flag(name: [.customLong("hex-output"), .customShort("x")],
          help: "Use hexadecimal notation for the result.")
    var hexadecimalOutput = false
    
    @Flag(name: [.customLong("verbose"), .customShort("v")],
          help: "Print extra information to the console.")
    var verboseOutput = false
}

extension clipng {
    static func format(_ result: Int, usingHex: Bool) -> String {
        usingHex ? String(format: "0x%02x", result)
        : String(result)
    }
    
    struct random_purple: ParsableCommand {
        
        static var configuration =
        CommandConfiguration(abstract: "Generate a RGBA PNG file with each pixel a random shade of purple.")
        
        @Argument var width:UInt32
        @Argument var height:UInt32
        
        @OptionGroup var flags: Flags
        
        mutating func run() {
            
            let data = try? SwiftLIBPNG.buildSimpleDataExample(width: width, height: height, pixelData: PixelGenerator.purple_pixels_RGBA(width: Int(width), height: Int(height)))
            if let data {
                if flags.verboseOutput {
                    for item in data {
                        
                        print(format(Int(item), usingHex: flags.hexadecimalOutput), terminator: "\t")
                    }
                    print()
                }
                
                do {
                    let fileName = "random_purple_\(FileIO.timeStamp()).png"
                    try FileIO.writeDataToFile(data: data, filePath: fileName)
                } catch {
                    print("could not save")
                }
            }
        }
    }
    
    //    struct Multiply: ParsableCommand {
    //        static var configuration =
    //        CommandConfiguration(abstract: "Print the product of the values.")
    //
    //        @OptionGroup var options: Options
    //
    //        mutating func run() {
    //            let result = options.values.reduce(1, *)
    //            print(format(result, usingHex: options.hexadecimalOutput))
    //        }
    //    }
}
