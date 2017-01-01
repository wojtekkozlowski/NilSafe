//
//  NilSafe.swift
//  NilSafe
//
//  Created by Wojtek Kozlowski on 01/01/2017.
//  Copyright © 2017 Wojtek Kozlowski. All rights reserved.
//

import Foundation

public protocol NilSafe {
    func isNilSafe() -> Bool
}

public extension NilSafe {
    public func isNilSafe() -> Bool {
        let children = Mirror(reflecting: self).children

        return children.reduce(true) { acc, child -> Bool in
            let result: Bool

            switch OptionalType(child.value) {
            case .array(let value):
                result = checkArray(value)
            case .optional:
                result = checkOptionalValueOrSucceed(child.value)
            case .implicitlyUnwrappedOptional:
                if hasValue(child.value) {
                    result = checkOptionalValueOrSucceed(child.value)
                } else {
                    NSLog("NilSafe error: property '\(self).\(child.label!)' cannot be nil")
                    result = false
                }
            case .other:
                result = true
            }

            return acc && result
        }
    }
}

extension NilSafe {
    fileprivate func checkArray(_ array: Array<Any>) -> Bool {
        return array.reduce(true) { acc, child -> Bool in
            if let nilSafeChild = child as? NilSafe {
                return acc && nilSafeChild.isNilSafe()
            } else {
                return acc && true
            }
        }
    }

    fileprivate func checkOptionalValueOrSucceed(_ childValue: Any) -> Bool {
        if let value = getValue(childValue), let nilSafeValue = value as? NilSafe {
            return nilSafeValue.isNilSafe()
        } else {
            return true
        }
    }

    fileprivate func getValue(_ value: Any) -> Any? {
        if let first = Mirror(reflecting: value).children.first {
            print(first.value)
            print(type(of: first.value))
            return first.value
        } else {
            return nil
        }
    }

    fileprivate func hasValue(_ value: Any) -> Bool {
        return getValue(value) != nil
    }
}

enum OptionalType {
    case implicitlyUnwrappedOptional
    case optional
    case array([Any])
    case other

    init(_ value: Any) {
        let typeDescription = "\(type(of: value))"
        if let array = value as? Array<Any> {
            self = .array(array)
        } else if typeDescription.hasPrefix("ImplicitlyUnwrappedOptional<") {
            self = .implicitlyUnwrappedOptional
        } else if typeDescription.hasPrefix("Optional<") {
            self = .optional
        } else {
            self = .optional
        }
    }
}
