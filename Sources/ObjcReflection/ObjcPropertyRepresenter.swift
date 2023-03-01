//
//  ObjcPropertyRepresenter.swift
//  
//
//  Created by pbk on 2023/02/23.
//

import Foundation

public struct ObjcPropertyRepresenter {
    
    public let pointer: objc_property_t
    
    @usableFromInline
    internal init(propertyPointer: objc_property_t) {
        self.pointer = propertyPointer
    }
    
}

extension ObjcPropertyRepresenter: Hashable, CustomStringConvertible {
    
    @inlinable
    public var description: String {
        "ObjcPropertyRepresenter(name: \(name), attributes: \(attributes))"
    }
    
}

public extension ObjcPropertyRepresenter {
    
    @inlinable
    var name:String {
        String(cString: property_getName(pointer))
    }
    
    @inlinable
    var attributes:[ObjcPropertyAttribute] {
        var count: UInt32 = 0
        guard let ref = property_copyAttributeList(pointer, &count) else { return [] }
        defer { free(ref) }
        let buffer = UnsafeBufferPointer(start: ref, count: Int(count))
        let list = buffer.map{ ObjcPropertyAttribute(rawStruct: $0) }
        return list
    }
    
}
