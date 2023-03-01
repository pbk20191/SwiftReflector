//
//  ObjcPropertyAttribute.swift
//  
//
//  Created by pbk on 2023/02/23.
//

import Foundation

public struct ObjcPropertyAttribute {
    
    
    public let name:String
    public let value:String?
    
    @usableFromInline
    internal init(rawStruct: objc_property_attribute_t) {
        self.name = String(cString: rawStruct.name)
        let inner = String(cString: rawStruct.value)
        if inner.isEmpty {
            self.value = nil
        } else {
            self.value = inner
        }
    }
    
}

extension ObjcPropertyAttribute: Hashable {}


public extension ObjcPropertyAttribute {
    
    @inlinable
    var readableName:String {
        let symbol = name
        switch symbol {
        case "R": return "readOnly"
        case "N": return "nonAtomic"
        case "D": return "dynamic"
        case "W": return "weak"
        case "C": return "copy"
        case "&": return "retain"
        case "G": return "getterSelector"
        case "S": return "selector"
        case "T": return "typeEncoding"
        case "V": return "variableName"
        default: return symbol
            
        }
    }
    
}


