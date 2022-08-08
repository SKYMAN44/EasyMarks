//
//  SourceEditorCommand.swift
//  EasyMarks
//
//  Created by Дмитрий Соколов on 26.07.2022.
//

import Foundation
import XcodeKit


class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    private let storage = UserDefaults(suiteName: MarkSuit.APP_GROUP_ID)!

    private var cachedLines: NSMutableArray = []

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        defer { completionHandler(nil) }

        guard let regex = createRegex(rule: "extension [a-zA-Z_][0-9a-zA-Z_]*: (.*)")
        else {
            completionHandler(nil)
            return
        }

        let lines = invocation.buffer.lines
        for line in lines {
            // since we insert new lines with Marks above reference line we need to check
            //  in order not to write new mark comment (fix later with jumping to next line)
            guard !cachedLines.contains(line) else {
                continue
            }

            if let l = line as? String {
                let matches = regex.firstMatch(
                    in: l,
                    range: NSRange(location: 0, length: l.utf16.count)
                )

                if let match = matches {
                    let range = match.range(at: 1)
                    if let swiftRange = Range(range, in: l) {
                        var name = String(l[swiftRange])
                        clearNameIfNeeded(str: &name)
                        let correctMark = "// MARK: - \(name)"
                        let index = lines.index(of: line)

                        if let markIndex = checkIfMarkExists(lines: lines, extensionIndex: index) {
                            let correctMark = fixIfMarkIncorrect(markLine: lines[markIndex] as! String, correctMark: correctMark)
                            lines[markIndex] = correctMark
                        } else {
                            lines.insert(correctMark, at: index)
                            cachedLines.add(line)
                        }
                    }
                }
            }
        }
        completionHandler(nil)
    }

    private func checkIfMarkExists(lines: NSMutableArray, extensionIndex: Int) -> Int? {
        var meetSpace = true
        for i in (0..<extensionIndex).reversed() {
            // check if line contains mark, if containts return line number
            guard let reg = createRegex(rule: "// MARK: - [a-zA-Z_][0-9a-zA-Z_]*"),
                  let l = lines[i] as? String
            else { return nil }

            if let markMatch = reg.firstMatch(
                in: l,
                range: NSRange(location: 0, length: l.utf16.count)
            ) {
                return i
            }
            // check if line contains something except spaces/tabs
            guard let regex = createRegex(rule: "[a-zA-Z_][0-9a-zA-Z_]*") else { return nil }
            if let matches = regex.firstMatch(
                in: l,
                range: NSRange(location: 0, length: l.utf16.count)
            ) {
                meetSpace = false
            }

            if(!meetSpace) {
                return nil
            }
        }
        return nil
    }

    // actually uselessFunction
    private func fixIfMarkIncorrect(markLine: String, correctMark: String) -> String {
        var fixedMark = markLine
        let option = storage.fixExistingMarks
        if(markLine != correctMark && option) {
            fixedMark = correctMark
        }
        return fixedMark
    }

    // MARK: - Utils
    private func clearNameIfNeeded(str: inout String) {
        if let index = str.firstIndex(of: "{") {
            str.remove(at: index)
        }
        if let index = str.firstIndex(of: "}") {
            str.remove(at: index)
        }
    }

    private func createRegex(rule: String) -> NSRegularExpression? {
        guard let regex = try? NSRegularExpression(
            pattern: rule,
            options: NSRegularExpression.Options.caseInsensitive
        )
        else {
            return nil
        }
        return regex
    }
}
