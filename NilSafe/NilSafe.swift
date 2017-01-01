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

enum OptionalType {
    case implicitlyUnwrappedOptional
    case optional
    case other
    
    init(_ value: Any){
        let typeDescription = "\(type(of: value))"
        if typeDescription.hasPrefix("ImplicitlyUnwrappedOptional<") {
            self = .implicitlyUnwrappedOptional
        } else if typeDescription.hasPrefix("Optional<"){
            self = .optional
        } else {
            self = .optional
        }
    }
}

public extension NilSafe {
    public func isNilSafe() -> Bool {
        let children = Mirror(reflecting: self).children
        var messages = [String]()
        return children.reduce(true) { acc, child -> Bool in
            let res: Bool
            
            switch OptionalType(child.value) {
            case .optional:
                res = checkOptionalValueOrSucceed(child.value)
            case .implicitlyUnwrappedOptional:
                let valid = hasValue(child.value)
                if valid {
                    res = checkOptionalValueOrSucceed(child.value)
                } else {
                    messages.append("property '\(self).\(child.label!)' cannot be nil")
                    res = false
                }
            case .other:
                res = true
            }
            return acc && res
        }
    }
}

extension NilSafe {
    fileprivate func checkOptionalValueOrSucceed(_ childValue: Any) -> Bool {
        if let value = getValue(childValue), let nilSafeValue = value as? NilSafe {
            return nilSafeValue.isNilSafe()
        } else {
            return true
        }
    }
    
    fileprivate func getValue(_ value: Any) -> Any? {
        if let first = Mirror(reflecting: value).children.first {
            return first.value
        } else {
            return nil
        }
    }
    
    fileprivate func hasValue(_ value: Any) -> Bool {
        return getValue(value) != nil
    }
}

