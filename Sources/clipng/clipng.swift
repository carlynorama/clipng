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
            purple.self, 
            random.self,
            vbars_grayscale.self
        ],
        defaultSubcommand: random.self)
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

    @Flag(name: [.customLong("grayscale"), .customShort("g")],
          help: "Generate PNG data as a grayscale pallette. For functions where this not implemented or relevant, flag will be ignored.")
    var isGrayScale:Bool = false
}

extension clipng {
    static func format(_ result: Int, usingHex: Bool) -> String {
        usingHex ? String(format: "0x%02x", result)
        : String(result)
    }

    struct random: ParsableCommand {
        
        static var configuration =
        CommandConfiguration(abstract: "Generate a RGBA PNG file with each pixel a random 24 or 32 bit color.")
        
        @Argument var width:UInt32
        @Argument var height:UInt32
        
        @OptionGroup var flags: Flags
        
        mutating func run() {
            if flags.verboseOutput {
                if flags.isGrayScale {
                    print("grayscale requested.")
                }
                if flags.includeAlpha {
                    print("alpha channel requested.")
                }
            }

            
            let data:Data? 
            let fileName:String
            if flags.includeAlpha {
                if flags.isGrayScale { 
                    fileName = "random_GA8_\(FileIO.timeStamp()).png"
                    data = try? SwiftLIBPNG.pngData(for:PixelGenerator.grayscale_random8(width: Int(width), height: Int(height), includeAlpha: true), width: width, height: height, bitDepth: .eight, colorType: .grayscaleA, metaInfo: generatePNGMetaText())
                } else { 
                    fileName = "random_RGBA8_\(FileIO.timeStamp()).png"
                    data = try? SwiftLIBPNG.pngData(for:PixelGenerator.truecolor_random8(width: Int(width), height: Int(height), includeAlpha:true), width: width, height: height, bitDepth: .eight, colorType: .truecolorA, metaInfo: generatePNGMetaText())
                }
            } else {
                if flags.isGrayScale { 
                    fileName = "random_G8_\(FileIO.timeStamp()).png"
                    data = try? SwiftLIBPNG.pngData(for:PixelGenerator.grayscale_random8(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .grayscale, metaInfo: generatePNGMetaText())
                } else { 
                    fileName = "random_RGB8_\(FileIO.timeStamp()).png"
                    data = try? SwiftLIBPNG.pngData(for:PixelGenerator.truecolor_random8(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .truecolor, metaInfo: generatePNGMetaText())
                }
            }
            

            if let data {
                saveData(data, fileName:fileName, flags: flags)
            }
        }
    }

    
    struct purple: ParsableCommand {
        
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
                //TODO: Switch to main function?
                data = SwiftLIBPNG.optionalPNGForRGBA(width: width, height: height, pixelData: PixelGenerator.purple_pixels(width: Int(width), height: Int(height), includeAlpha:true))
            } else {
                fileName = "random_purple_RGB8_\(FileIO.timeStamp()).png"
                data = try? SwiftLIBPNG.pngData(for:PixelGenerator.purple_pixels(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .truecolor, metaInfo: generatePNGMetaText())
            }
            

            if let data {
                saveData(data, fileName:fileName, flags: flags)
            }
        }
    }
    
    struct vbars_grayscale: ParsableCommand {
        
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
                data = try? SwiftLIBPNG.pngData(for: PixelGenerator.grayscale_randomAlphaTest(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .grayscaleA, metaInfo:generatePNGMetaText() )
            } else {
                fileName = "verticalStripes_G8_\(FileIO.timeStamp()).png"
                data = try? SwiftLIBPNG.pngData(for: PixelGenerator.grayscale_verticalStripe(width: Int(width), height: Int(height)), width: width, height: height, bitDepth: .eight, colorType: .grayscale, metaInfo: generatePNGMetaText())
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

    static func generatePNGMetaText(_ comment:String? = nil) -> Dictionary<String, String> {
        var base = [
            "Author":"Carlyn Maw or PixelGenerator.swift, depending on who's asking.",
            "Source":"https://github.com/carlynorama/clipng/"
            ]
        if let comment {
            base["Comment"] = comment
        }
        return base
    }
}
