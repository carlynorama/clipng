import Foundation
import ArgumentParser
import SwiftLIBPNG

@main
struct clipng:ParsableCommand {
static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "A utility for performing maths.",

        // Commands can define a version for automatic '--version' support.
        version: "0.0.1",
        subcommands: [Add.self, Multiply.self],
        defaultSubcommand: Add.self)
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

    struct Add: ParsableCommand {
        static var configuration =
            CommandConfiguration(abstract: "Print the sum of the values.")

        // The `@OptionGroup` attribute includes the flags, options, and
        // arguments defined by another `ParsableArguments` type.
        @OptionGroup var options: Options

        mutating func run() {
            let result = options.values.reduce(0, +)
            print(format(result, usingHex: options.hexadecimalOutput))
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
