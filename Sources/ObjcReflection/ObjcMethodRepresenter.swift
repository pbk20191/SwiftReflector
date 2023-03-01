//
//  ObjcMethodRepresenter.swift
//  
//
//  Created by pbk on 2023/02/23.
//

import Foundation

public struct ObjcMethodRepresenter {
    
    public let owner:AnyClass
    public let pointer:ObjectiveC.Method
    
    @usableFromInline
    internal init(owner: AnyClass, pointer: ObjectiveC.Method) {
        self.owner = owner
        self.pointer = pointer
    }
    
    
}

extension ObjcMethodRepresenter: Hashable, CustomStringConvertible {
    
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.owner == rhs.owner && lhs.pointer == rhs.pointer
    }
    
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(owner))
        hasher.combine(pointer)
    }
    
    @inlinable
    public var description: String {
        """
ObjcMethodRepresenter(owner: \(owner), selector: \(selector), name: \(name), encoding: \(encoding ?? "null"), numberOfArguments:\(numberOfArguments), isInstance: \(isInstance), isClass: \(isClass), arguments: \(getEncodedArgumentTypes().map{ $0 ?? "null" }), returns: \(returnType))
"""
        
    }
    
}

public extension ObjcMethodRepresenter {
    
    @inlinable
    var selector:Selector {
        method_getName(pointer)
    }
    
    @inlinable
    var name:String {
        String(cString: sel_getName(selector))
    }
    
    @inlinable
    var implementation:ObjectiveC.IMP {
        method_getImplementation(pointer)
    }
    
    @inlinable
    var encoding:String? {
        guard let encoding = method_getTypeEncoding(pointer) else { return nil }
        return String(cString: encoding)
    }
    
    @inlinable
    var numberOfArguments:Int {
        Int(method_getNumberOfArguments(pointer))
    }
    
    @inlinable
    var isInstance:Bool {
        class_getInstanceMethod(owner, selector) == pointer
    }
    
    @inlinable
    var isClass:Bool {
        class_getClassMethod(owner, selector) == pointer
    }
    
    @inlinable
    var returnType:String {
        String(cString: method_copyReturnType(pointer))
    }

    @inlinable
    func getEncodedArgumentTypes() -> [String?] {
        
        (0..<method_getNumberOfArguments(pointer))
            .map{ index -> String? in
                guard let type = method_copyArgumentType(pointer, index)
                else { return nil }
                defer { free(type) }
                return String(cString: type)
            }
        
    }
    
}
