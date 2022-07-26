//
//  SourceEditorCommand.swift
//  EasyMarks
//
//  Created by Дмитрий Соколов on 26.07.2022.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
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
            if let l = line as? String {
                let matches = regex.matches(
                    in: l,
                    options: [],
                    range: NSRange(location: 0, length: l.utf8.count)
                )
                if let match = matches.first {
                    let range = match.range(at: 1)
                    if let swiftRange = Range(range, in: l) {
                        let name = l[swiftRange]
                        let index = lines.index(of: line)
                        lines.insert("// MARK: - \(name)", at: index)
                    }
                }
            }
        }
        completionHandler(nil)
    }
}
