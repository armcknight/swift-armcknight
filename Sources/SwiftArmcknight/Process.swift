//
//  Process.swift
//  swift-armcknight
//
//  Created by Andrew McKnight on 12/16/22.
//  Copyright © Andrew McKnight 2016-2022
//

import Foundation

public extension Process {
    static func run(_ path: String, cwd: URL? = nil, _ arguments: String ...) {
        _run(path, cwd: cwd, Array(arguments))
    }

    static func runBrewed(_ utility: String, stdin: String? = nil, _ arguments: String ...) {
        _run(_path(forBrewed: utility), stdin: stdin, Array(arguments))
    }

    static func runBrewedWithResult(_ utility: String, stdin: String? = nil, _ arguments: String ...) -> String {
        var result: String!
        let group = DispatchGroup()
        let stdout = Pipe()
        stdout.fileHandleForReading.readabilityHandler = {
            result = String(data: $0.readDataToEndOfFile(), encoding: .utf8)!
            if #available(macOS 10.15, *) {
                try! $0.close()
            } else {
                $0.closeFile()
            }
            group.leave()
        }
        group.enter()
        _run(_path(forBrewed: utility), stdin: stdin, stdout: stdout, Array(arguments))
        group.wait()
        return result
    }

    private static func _path(forBrewed utility: String) -> String {
        let x86_64Path = "/usr/local/bin/\(utility)"
        return FileManager.default.fileExists(atPath: x86_64Path) ? x86_64Path : "/opt/homebrew/bin/\(utility)"
    }

    private static func _run(_ path: String, stdin: String? = nil, stdout: Pipe? = nil, cwd: URL? = nil, _ arguments: [String]) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments
        if let stdin {
            let pipe = Pipe()
            pipe.fileHandleForWriting.write(stdin.data(using: .utf8)!)
            if #available(macOS 10.15, *) {
                try! pipe.fileHandleForWriting.close()
            } else {
                pipe.fileHandleForWriting.closeFile()
            }
        }
        process.standardInput = pipe

        if let stdout {
            process.standardOutput = stdout
        }
        if let cwd {
            process.currentDirectoryURL = cwd
        }
        try! process.run()
    }
}

