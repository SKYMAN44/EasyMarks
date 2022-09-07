//
//  SortImportsCommand.swift
//  EasyMarks
//
//  Created by Дмитрий Соколов on 28.08.2022.
//

import Foundation
import XcodeKit


class SourceImportsCommand: NSObject, XCSourceEditorCommand {

    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Swift.Error?) -> Void ) -> Void {
        defer { completionHandler(nil) }

        let lines = invocation.buffer.lines

        var imports: [String] = []
        var isFirst: Bool = true
        var startIndex: Int?
        var endIndex: Int?
        for i in 0..<lines.count {
            guard let line = lines[i] as? String else {
                continue
            }
            if line.contains("import") {
                imports.append(line)
                if isFirst {
                    isFirst = false
                    startIndex = i
                }
            } else if !isFirst {
                endIndex = i - 1
                break
            }
        }
        guard let start = startIndex,
              let end = endIndex
        else {
            return
        }

        imports = imports.sorted(by: <)
        for j in start...end {
            lines[j] = imports[j-start]
        }
    }
}
