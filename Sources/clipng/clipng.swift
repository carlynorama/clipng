import Foundation
import ArgumentParser
import SwiftLIBPNG

@main
public struct clipng {
    public private(set) var text = "Hello, World!"

    public static func main() {
        print(clipng().text)
    }
}
