//
//  ObjcVariableDescriptor.swift
//  
//
//  Created by pbk on 2023/03/01.
//

import Foundation

public struct ObjcVariableDescriptor {
    
    public let ivar: ObjectiveC.Ivar
    public let declared:DeclaredRegion
    
    @usableFromInline
    internal init(ivar: ObjectiveC.Ivar, declared:DeclaredRegion) {
        self.ivar = ivar
        self.declared = declared
    }
    
}

extension ObjcVariableDescriptor: Hashable, CustomStringConvertible {
    
    @inlinable
    public var description: String {
        "ObjcVariableDescriptor(name: \(name ?? "nil"), offSet: \(offSet), typeEncoding: \(typeEncoding ?? "nil"), declared: \(declared))"
    }
    
}


public extension ObjcVariableDescriptor {
    
    @inlinable
    var name:String? {
        guard let pointer = ivar_getName(ivar) else { return nil }
        return String(cString: pointer)
    }
    
    @inlinable
    var offSet:Int {
        ivar_getOffset(ivar)
    }
    
    @inlinable
    var typeEncoding:String? {
        guard let pointer = ivar_getTypeEncoding(ivar) else { return nil }
        return String(cString: pointer)
    }
    
}
