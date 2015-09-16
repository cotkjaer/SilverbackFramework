//
//  Foundation.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 20/04/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public func delay(delay:Double, closure:()->())
{
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))),
        dispatch_get_main_queue(),
        closure)
}


public func debugPrintIf<T>(condition: Bool?,  value: T, terminator: String = "\n")
{
    if condition == true { debugPrint(value, terminator:terminator) }
}

public func hash(seed seed: Int = 11, hashValues: Int...) -> Int
{
    return hashValues.reduce(0, combine: { (combinedHashValue, hashValue) -> Int in
        
        return seed &* combinedHashValue &+ hashValue
    })
}

public extension Dictionary
{
    init(_ pairs: [Element])
    {
        self.init()
        
        for (k, v) in pairs
        {
            self[k] = v
        }
    }
}

public extension Dictionary
{
    func map<OutKey: Hashable, OutValue>(transform: Element -> (OutKey, OutValue)) -> [OutKey: OutValue]
    {
        return Dictionary<OutKey, OutValue>(map(transform))
    }
    
    func filter(includeElement: Element -> Bool) -> [Key: Value]
    {
        return Dictionary(filter(includeElement))
    }
}

public extension NSComparisonResult
{
    init(integer: Int)
    {
        if integer > 0
        {
            self = .OrderedDescending
        }
        else if integer < 0
        {
            self = .OrderedAscending
        }
        
        self = .OrderedSame
    }
}

//public protocol VariableBytesCountConvertible : BytesConvertible
//{
//    static func bytesToReadInData(data: NSData, inout atLocation location: Int) -> Int
//}

public extension NSMutableData
{
//    func appendBytesConvertible<B:BytesConvertible>(bc: B)
//    {
//        var bytes = bc.bytes
//        
//        switch B.bytesCount
//        {
//        case .Fixed(let count):
//            if count != bytes.count { debugPrint("strange mismatch in bytes produced vs. bytes to write") }
//                
//        case .VariableInt:
//            appendInt(bc.bytes.count)
//            
//        case .VariableByte:
//            appendByte(UInt8(bc.bytes.count & 0xFF))
//        }
//        
//        appendBytes(&bytes, length: bytes.count)
//    }
    
    func appendString(string: String)
    {
        var buf = [UInt8](string.utf8)
        
        appendInt(buf.count)
        appendBytes(&buf, length: buf.count)
    }
    
    func appendInt(var int: Int)
    {
        appendBytes(&int, length: sizeof(Int))
    }
    
    func appendByte(var b:UInt8)
    {
        appendBytes(&b, length: sizeof(UInt8))
    }
}

private let lengthOfInt = sizeof(Int)

private let lengthOfByte = sizeof(UInt8)

public enum BytesError : ErrorType
{
    case OutOfBoundsError
    case MalformedBytes
}


public extension NSData
{
//
//    func readBytesConvertible<B:BytesConvertible>(inout location: Int) throws -> B
//    {
//        let cachedLocation = location
//        
//        do
//        {
//            var bytesToRead:Int = 0
//            
//            switch B.bytesCount
//            {
//            case .Fixed(let count):
//                bytesToRead = count
//            case .VariableInt:
//                bytesToRead = try readInt(&location)
//            case .VariableByte:
//                bytesToRead = Int(try readByte(&location))
//            }
//            
//            let bytes = try readBytes(&location, count: bytesToRead)
//            
//            if let b = B(bytes: bytes)
//            {
//                return b
//            }
//            else
//            {
//                throw BytesError.MalformedBytes
//            }
//        }
//        catch let e
//        {
//            location = cachedLocation
//            throw e
//        }
//    }
    
    func bytesFromIndex(index: Int, length: Int) throws -> [UInt8]
    {
        return try bytesInRange(Range<Int>(start: index, end: index + length))
    }
    
    func bytesInRange(range: Range<Int>) throws -> [UInt8]
    {
        guard range.endIndex <= length else { throw BytesError.OutOfBoundsError }
        
        let size = range.endIndex - range.startIndex
        
        var buffer = Array<UInt8>(count: size, repeatedValue: 0x00)
        
        getBytes(&buffer, range: NSMakeRange(range.startIndex, size))
        
        return buffer
    }
    
    func readBytes(inout location: Int, count: Int) throws -> [UInt8]
    {
        if location + count > length { throw BytesError.OutOfBoundsError }
        
        var buffer = Array<UInt8>(count: count, repeatedValue: 0x00)
        
        getBytes(&buffer, range: NSMakeRange(location, count))
        location += count
        
        return buffer
    }
    
    func readByte(inout location: Int) throws -> UInt8
    {
        if lengthOfByte + location > length { throw BytesError.OutOfBoundsError }
        
        var byte: UInt8 = 0
        
        getBytes(&byte, range: NSMakeRange(location, lengthOfByte))
        
        location += lengthOfByte
        
        return byte
    }
    
    func readInt(inout location: Int) throws -> Int
    {
        if lengthOfInt + location > length { throw BytesError.OutOfBoundsError }

        var int = 0
        
        getBytes(&int, length: lengthOfInt)
        location += lengthOfInt

        
        return int
    }
    
    func readString(inout location: Int) throws -> String
    {
        let markedLocation = location

        do
        {
            let lengthOfString = try readInt(&location)
            
            let bytes = try readBytes(&location, count: lengthOfString)
            
            if let string = String(bytes: bytes, encoding: NSUTF8StringEncoding)
            {
                return string
            }
            else
            {
                throw BytesError.MalformedBytes
            }
        }
        catch let e
        {
            location = markedLocation
            throw e
        }
    }
}


//public extension SequenceType where Generator.Element == String
//{
//    public func joined(separator: String = "") -> String
//    {
//        return separator.join(self)
//    }
//}



