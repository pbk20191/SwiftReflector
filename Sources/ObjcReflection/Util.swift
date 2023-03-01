import Foundation

internal enum Util {
    static func valueForType(type: String) -> String {
        switch type {
        case "c" : return "Int8"
        case "s" : return "Int16"
        case "i" : return "Int32"
        case "q" : return "Int"
        case "S" : return "UInt16"
        case "I" : return "UInt32"
        case "Q" : return "UInt"
        case "B" : return "Bool"
        case "d" : return "Double"
        case "f" : return "Float"
        case "{" : return "Decimal"
        default: return type
        }
    }
    
    static func resolveType(for type: String) -> String {
        if type.hasPrefix("@\"") {
            
        }
        switch type {
        case "c" : return "Int8"
        case "s" : return "Int16"
        case "i" : return "Int32"
        case "q" : return "Int"
        case "S" : return "UInt16"
        case "I" : return "UInt32"
        case "Q" : return "UInt"
        case "B" : return "Bool"
        case "d" : return "Double"
        case "f" : return "Float"
        case "{" : return "Decimal"
        case "v" : return "void"
        case "?" : return "unknown"
        case ":" : return "Selector"
        default: return type
        }
        
        
    }
    
}
