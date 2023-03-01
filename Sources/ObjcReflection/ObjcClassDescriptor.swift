//
//  ObjcClassDescriptor.swift
//  
//
//  Created by pbk on 2023/02/23.
//

import Foundation

public struct ObjcClassDescriptor {
    
    public let classType: AnyClass
    
    @inlinable
    public init(object: AnyObject) {
        self.classType = type(of: object)
        assert(object is NSObject, "Objective-C reflection is only available on NSObject")
    }
    
    @inlinable
    public init(class _class: AnyClass) {
        self.classType = _class
        assert(classType is NSObject.Type, "Objective-C reflection is only available on NSObject")
    }
    
    /// Wrapper for: func class_respondsToSelector(AnyClass?, Selector) -> Bool
    @inlinable
    public func respondsToSelector(selector: Selector) -> Bool {
        return class_respondsToSelector(classType, selector)
    }
    
    @inlinable
    public func respondsToSelector(selectorString: String) -> Bool {
        let selector = Selector(selectorString)
        return respondsToSelector(selector: selector)
    }
    
    
    /// Wrapper for: func class_conformsToProtocol(AnyClass?, Protocol?) -> Bool
    @inlinable
    public func conformsToProtocol(_ protocol: Protocol) -> Bool {
        return class_conformsToProtocol(classType, `protocol`)
    }
    
}


// MARK: Getter Functions
public extension ObjcClassDescriptor {
    
    @inlinable
    var isMetaClass:Bool {
        class_isMetaClass(classType)
    }
    
    @inlinable
    var name:String? {
        let className = String(cString: class_getName(classType))
        guard className.count > 0 else { return nil }
        return className
    }
    
    @inlinable
    var superClass: AnyClass? {
        class_getSuperclass(classType)
    }
    
    @inlinable
    var instanceSize:Int {
        class_getInstanceSize(classType)
    }
    
    @inlinable
    var stringVariablesLayout:String? {
        guard let layout = class_getIvarLayout(classType) else { return nil }
        return String(cString: layout)
    }

    @inlinable
    var weakVariablesLayout:String? {
        guard let layout = class_getWeakIvarLayout(classType) else { return nil }
        return String(cString: layout)
    }
    
    @inlinable
    var classHierarchy: some Sequence<AnyClass> {
        sequence(first: classType) {
            class_getSuperclass($0)
        }
    }
    


}


public extension ObjcClassDescriptor {
    
    @inlinable
    func listProperties() -> [ObjcPropertyRepresenter] {
        var count:Int32 = 0
        guard let propertyRef = class_copyPropertyList(classType, &count) else { return [] }
        defer { free(propertyRef) }
        let buffer = UnsafeBufferPointer(start: propertyRef, count: Int(count))
        let list = buffer.map{
            
            ObjcPropertyRepresenter(propertyPointer: $0)
        }
        return list
    }
    
    @inlinable
    func listMethods() -> [ObjcMethodRepresenter] {
        var count:UInt32 = 0
        guard let pointer = class_copyMethodList(classType, &count)
        else { return [] }
        defer { free(pointer) }
        let buffer = UnsafeBufferPointer(start: pointer, count: Int(count))
        return buffer.map {
            ObjcMethodRepresenter(owner: classType, pointer: $0)
        }
        
    }
    
    @inlinable
    func getInstanceMethod(selector:Selector) -> ObjcMethodRepresenter? {
        guard let pointer = class_getInstanceMethod(classType, selector) else { return nil }
        return ObjcMethodRepresenter(owner: classType, pointer: pointer)
    }
    
    @inlinable
    func getClassMethod(selector:Selector) -> ObjcMethodRepresenter? {
        guard let pointer = class_getClassMethod(classType, selector) else { return nil }
        return ObjcMethodRepresenter(owner: classType, pointer: pointer)
    }
    
    @inlinable
    func findInstanceVariable(withName name: String) -> ObjcVariableDescriptor? {
        guard let ivar = class_getInstanceVariable(classType, name) else { return nil }
        return ObjcVariableDescriptor(ivar: ivar, declared: .instance)
    }
    
    @inlinable
    func findClassVariable(withName name: String) -> ObjcVariableDescriptor? {
        guard let ivar = class_getClassVariable(classType, name) else { return nil }
        return ObjcVariableDescriptor(ivar: ivar, declared: .class)
    }
    
    @inlinable
    func listInstanceVariables() -> [ObjcVariableDescriptor] {
        var count:UInt32 = 0
        guard let pointer = class_copyIvarList(classType, &count) else { return [] }
        defer { free(pointer) }
        let buffer = UnsafeBufferPointer(start: pointer, count: Int(count))
        let list = buffer.map{
            ObjcVariableDescriptor(ivar: $0, declared: .instance)
        }
        return list
    }
    
}
