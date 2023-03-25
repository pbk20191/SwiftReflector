//
//  ObjcMethodSignature.swift
//  
//
//  Created by pbk on 2023/03/25.
//

import Foundation

public struct ObjcMethodSignature {
    
    public let nsMethodSignature:NSObject
    
    public let owner:ObjcMethodRepresenter
    
    @usableFromInline
    internal init(nsMethodSignature: NSObject, owner: ObjcMethodRepresenter) {
        self.nsMethodSignature = nsMethodSignature
        self.owner = owner
    }
    
    public func createInvocation() -> NSObject {
        let invocationType = NSClassFromString("NSInvocation") as! NSObject.Type
        let nsInvocation = invocationType.perform(NSSelectorFromString("invocationWithMethodSignature:"), with: nsMethodSignature)?.takeUnretainedValue() as! NSObject
        nsInvocation.perform(Selector(("setSelector:")), with: owner.selector)
        return nsInvocation
    }
    
}
