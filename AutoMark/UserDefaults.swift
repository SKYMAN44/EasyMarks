//
//  UserDefaults.swift
//  AutoMarkExt
//
//  Created by Дмитрий Соколов on 02.08.2022.
//

import Foundation

public extension UserDefaults {
    enum ValueKeys {
        static let spaces = "number_of_spaces"
        static let isFix = "is_fixing_marks"
    }

    var numberOfSpaces: Int {
        get {
            return integer(forKey: ValueKeys.spaces)
        }
        set(value) {
            setValue(value, forKey: ValueKeys.spaces)
        }
    }

    var fixExistingMarks: Bool {
        get {
            return bool(forKey: ValueKeys.isFix)
        }
        set(value) {
            setValue(value, forKey: ValueKeys.isFix)
        }
    }
}

class MarkSuit {
    static public let APP_GROUP_ID = "group.com.skyman44.EasyMarks"
}
