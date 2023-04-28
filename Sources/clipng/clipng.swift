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
        subcommands: [
            random_purple.self, 
            random_pixels.self,
            striped_grayscale.self
        ],
        defaultSubcommand: random_pixels.self)
}

struct Flags: ParsableArguments {
    @Flag(name: [.customLong("hex-output"), .customShort("x")],
          help: "Use hexadecimal notation for the result.")
    var hexadecimalOutput = false
    
    @Flag(name: [.customLong("verbose"), .customShort("v")],
          help: "Print extra information to the console.")
    var verboseOutput = false

    @Flag(name: [.customLong("alpha"), .customShort("a")],
          help: "Generate PNG data with alpha channel.")
    var includeAlpha:Bool = false
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
            
            let data:Data? 
            let fileName:String
            if flags.includeAlpha {
                fileName = "random_purple_RGBA8_\(FileIO.timeStamp()).png"
                data = SwiftLIBPNG.optionalPNGForRGBA(width: width, height: height, pixelData: PixelGenerator.purple_pixels_RGBA8(width: Int(width), height: Int(height)))
            } else {
                fileName = "random_purple_RGB8_\(FileIO.timeStamp()).png"
                data = try? SwiftLIBPNG.pngData(for:PixelGenerator.purple_pixels_RGB8(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .truecolor)
            }
            

            if let data {
                saveData(data, fileName:fileName, flags: flags)
            }
        }
    }
    
    struct striped_grayscale: ParsableCommand {
        
        static var configuration =
        CommandConfiguration(abstract: "Generate a grayscale PNG where the first column is black, the second, random, the third, white. If alpha flag is set, black and white columns will have a random alpha.")
        
        @Argument var width:UInt32
        @Argument var height:UInt32
        
        @OptionGroup var flags: Flags
        
        mutating func run() {

            let data:Data? 
            let fileName:String
            if flags.includeAlpha {
                fileName = "verticalAlphaStripes_GA8_\(FileIO.timeStamp()).png"
                data = try? SwiftLIBPNG.pngData(for: PixelGenerator.grayscale_randomAlphaTest(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .grayscaleA)
            } else {
                fileName = "verticalAlphaStripes_G8_\(FileIO.timeStamp()).png"
                data = try? SwiftLIBPNG.pngData(for: PixelGenerator.grayscale_verticalStripe(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .grayscale)
            }

            
                
            if let data {
                saveData(data, fileName:fileName, flags: flags)
            }
        }
    }

    struct random_pixels: ParsableCommand {
        
        static var configuration =
        CommandConfiguration(abstract: "Generate a RGBA PNG file with each pixel a random 24 or 32 bit color.")
        
        @Argument var width:UInt32
        @Argument var height:UInt32
        
        @OptionGroup var flags: Flags
        
        mutating func run() {
            
            let data:Data? 
            let fileName:String
            if flags.includeAlpha {
                fileName = "random_RGBA8_\(FileIO.timeStamp()).png"
                data = try? SwiftLIBPNG.pngData(for:PixelGenerator.truecolor_randomRGBA8(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .truecolorA)
            } else {
                fileName = "random_RGB8_\(FileIO.timeStamp()).png"
                data = try? SwiftLIBPNG.pngData(for:PixelGenerator.truecolor_randomRGB8(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .truecolor)
            }
            

            if let data {
                saveData(data, fileName:fileName, flags: flags)
            }
        }
    }


    static func saveData(_ data:Data, fileName:String, flags:Flags) {
        if flags.verboseOutput {
            for item in data {
                print(format(Int(item), usingHex: flags.hexadecimalOutput), terminator: "\t")
            }
            print()
        }
        
        do {
            try FileIO.writeDataToFile(data: data, filePath: fileName)
        } catch {
            print("could not save")
        }
    }
}
