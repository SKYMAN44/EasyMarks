//
//  SourceEditorCommand.swift
//  EasyMarks
//
//  Created by Дмитрий Соколов on 26.07.2022.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    private var cachedLines: NSMutableArray = []

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        defer { completionHandler(nil) }

        var regex: NSRegularExpression?
        do {
             regex = try NSRegularExpression(
                pattern: "extension [a-zA-Z_][0-9a-zA-Z_]*: (.*)",
                options: NSRegularExpression.Options.caseInsensitive
            )
        }
        catch {
            fatalError("Can't create regular expression")
        }

        guard let regex = regex else {
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
//            let index = lines.index(of: line)
//            let prevLine = lines[index - 1]

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

                        let index = lines.index(of: line)
                        lines.insert("// MARK: - \(name)", at: index)
                        cachedLines.add(line)
                    }
                }
            }
        }
        completionHandler(nil)
    }

    private func clearNameIfNeeded(str: inout String) {
        if let index = str.firstIndex(of: "{") {
            str.remove(at: index)
        }
        if let index = str.firstIndex(of: "}") {
            str.remove(at: index)
        }
    }
}
