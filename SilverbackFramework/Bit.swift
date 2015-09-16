//
//  Bit.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 03/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public enum BytesCount
{
    case Fixed(Int)
    case VariableInt
    case VariableByte
}

public protocol BytesConvertible
{
    var bytes: [UInt8] { get }
    
    static var bytesCount: BytesCount { get }
    
    init?(bytes: [UInt8])
}

public extension NSMutableData
{
    func appendBytesConvertible<B:BytesConvertible>(bytesConvertible: B)
    {
        var bytes = bytesConvertible.bytes
        
        switch B.bytesCount
        {
        case .Fixed(let count):
            if count != bytes.count { debugPrint("strange mismatch in bytes produced vs. bytes to write") }
            
        case .VariableInt:
            appendInt(bytesConvertible.bytes.count)
            
        case .VariableByte:
            appendByte(UInt8(bytesConvertible.bytes.count & 0xFF))
        }
        
        appendBytes(&bytes, length: bytes.count)
    }
}

public extension NSData
{
    func readBytesConvertible<B:BytesConvertible>(inout location: Int) throws -> B
    {
        let cachedLocation = location
        
        do
        {
            var bytesToRead:Int = 0
            
            switch B.bytesCount
            {
            case .Fixed(let count):
                bytesToRead = count
                
            case .VariableInt:
                bytesToRead = try readInt(&location)
                
            case .VariableByte:
                bytesToRead = Int(try readByte(&location))
            }
            
            let bytes = try readBytes(&location, count: bytesToRead)
            
            if let b = B(bytes: bytes)
            {
                return b
            }
            else
            {
                throw BytesError.MalformedBytes
            }
        }
        catch let e
        {
            location = cachedLocation
            throw e
        }
    }
}


func bitsizeof<T>(_: T.Type) -> Int { return sizeof(T) * 8 }


private let BitSizeOfInt = bitsizeof(Int)
private let BitSizeOfByte = bitsizeof(UInt8)

let UInt8BitOneMasks = Array<UInt8>(arrayLiteral: 0b10000000, 0b01000000, 0b00100000, 0b00010000, 0b00001000, 0b00000100, 0b00000010, 0b00000001)
//let UInt8BitZeroMasks = Array<UInt8>(arrayLiteral: 0b01111111, 0b10111111, 0b11011111, 0b11101111, 0b11110111, 0b11111011, 0b11111101, 0b11111110)

extension UInt8
{
    func indexIsValid(index: Int) -> Bool
    {
        return index >= 0 && index < BitSizeOfByte
    }
    
    subscript(index: Int) -> Bit
        {
        
        get
        {
            guard indexIsValid(index) else { return .Zero }
            return ( self & UInt8BitOneMasks[index] ) > 0 ? .One : .Zero
        }
        
        set(bit)
        {
            guard indexIsValid(index) else { return }
            
            switch (self[index], bit)
            {
                //            case (.One, .One) :
                //                debugPrint("already sat")
                //            case (.Zero, .Zero):
                //                debugPrint("already unsat")
            case (.Zero, .One):
                self |= UInt8BitOneMasks[index]
            case (.One, .Zero):
                self &= ~UInt8BitOneMasks[index]
            case (_, _):
                break
            }
        }
    }
    
    mutating func setBit(index: Int, _ bit: Bit)
    {
        self[index] = bit
    }
    
    func getBit(index: Int) -> Bit
    {
        return self[index]
    }
    
    //
    //    func indexIsValid(index: Int) -> Bool
    //    {
    //        return index >= 0 && index < BitSizeOfByte
    //    }
    //
    //    subscript(index: Int) -> Bit
    //        {
    //
    //        get
    //        {
    //            assert(indexIsValid(index), "Index out of range")
    //            return getBit(index)
    //        }
    //
    //        set
    //        {
    //            assert(indexIsValid(index), "Index out of range")
    //            setBit(index, newValue)
    //        }
    //    }
    //
    //    mutating func setBit(index: Int, _ bit: Bit)
    //    {
    //        switch bit
    //        {
    //        case .One:
    //            self |= UInt8BitOneMasks[index]
    //
    //        case .Zero:
    //            self &= UInt8BitZeroMasks[index]
    //        }
    //    }
    //
    //    func getBit(index: Int) -> Bit
    //    {
    //        return ( self & UInt8BitOneMasks[index] ) > 0 ? .One : .Zero
    //    }
}


//let IntBitZeroMasks = Array<UInt8>(arrayLiteral: 0b01111111, 0b10111111, 0b11011111, 0b11101111, 0b11110111, 0b11111011, 0b11111101, 0b11111110)

public extension Int
{
    init(bits:[Bit])
    {
        var int = 0
        for var i = 0; i < bits.count; i++
        {
            int[BitSizeOfInt - (1 + i)] = bits[i]
        }
        
        self = int
        
    }
    
    func bits(count: Int) -> [Bit]
    {
        var bits = Array<Bit>(count: count, repeatedValue: .Zero)
        
        for var i = 0; i < count; i++
        {
            bits[i] = self[BitSizeOfInt - (1 + i)]
        }
        
        return bits
    }
}

let IntBitOneMasks = Array(0..<BitSizeOfInt).reverse().map({ Int(1) << $0 })

public extension Int
{
    private func indexIsValid(index: Int) -> Bool
    {
        return index >= 0 && index < BitSizeOfInt
    }
    
    subscript(index: Int) -> Bit
        {
        
        get
        {
            guard indexIsValid(index) else { return .Zero }
            return ( self & IntBitOneMasks[index] ) > 0 ? .One : .Zero
        }
        
        set(bit)
        {
            guard indexIsValid(index) else { return }
            
            switch (self[index], bit)
            {
                //            case (.One, .One) :
                //                debugPrint("already sat")
                //            case (.Zero, .Zero):
                //                debugPrint("already unsat")
            case (.Zero, .One):
                self |= IntBitOneMasks[index]
            case (.One, .Zero):
                self &= ~IntBitOneMasks[index]
            case (_, _):
                break
            }
        }
    }
    
    internal mutating func setBit(index: Int, _ bit: Bit)
    {
        self[index] = bit
    }
    
    internal func getBit(index: Int) -> Bit
    {
        return self[index]
    }
}

public func getBit(index: Int, number: Int) -> Bit
{
    let size = sizeof(Int) * 8
    
    guard index >= 0 && index < size else { return .Zero }
    
    var mask : Int = 1
    
    mask <<= (size - 1) - index
    
    return (number & mask) > 0 ? .One : .Zero
}

/// Protocol for objects that know how to read and write themselves to a BitBuffer
public protocol Bitable
{
    //    static func read() throws -> Self
    
    init(buffer:BitBuffer) throws
    
    func write(buffer: BitBuffer)
}

public enum BitsConvertibleBitsCount
{
    case Static(Int)
    case Variable(Int)
}

public protocol BitsConvertible
{
    static var bitsCount: BitsConvertibleBitsCount { get }
    
    init?(bits:[Bit])
    
    var bits: [Bit] { get }
}

public extension BitBuffer
{
//    private func doRead<B:BitsConvertible>(type: B.Type) throws -> B
//    {
//        let bitsCount : Int
//        
//        switch B.bitsCount
//        {
//        case .Static(let count): bitsCount = count
//        case .Variable(let count): bitsCount = try readInt(count)
//        }
//        
//        if let b = B(bits: try readBits(bitsCount))
//        {
//            return b
//        }
//        
//        throw BitBuffer.Error.MalformedBits(B)
//    }
    
    public func read<B:BitsConvertible>(type: B.Type? = nil) throws -> B
    {
        let bitsCount : Int
        
        switch B.bitsCount
        {
        case .Static(let count): bitsCount = count
        case .Variable(let count): bitsCount = try readInt(count)
        }
        
        if let b = B(bits: try readBits(bitsCount))
        {
            return b
        }
        
        throw BitBuffer.Error.MalformedBits(B)
    }
    
    public func readOptional<B:BitsConvertible>(type: B.Type? = nil) throws -> B?
    {
        if try readBool()
        {
            return try read(B)
        }
        
        return nil
    }
    
    public func write(bitable: BitsConvertible)
    {
        write(bitable.bits)
    }
    
    public func writeOptional(bitable: BitsConvertible?)
    {
        write(bitable != nil)
        if let b = bitable
        {
            write(b)
        }
    }
}

public class BitBuffer
{
    public enum Error: ErrorType
    {
        case OutOfBounds(Int, Int)
        case MalformedBits(Any.Type)
    }
    
    private var bitsAsBytes : Array<UInt8>
    
    private var writeIndex : Int = 0
    private var writeByteIndex : Int { return writeIndex / BitSizeOfByte }
    private var writeBitIndex : Int { return writeIndex % BitSizeOfByte }
    
    private var readIndex : Int = 0
    private var readByteIndex : Int { return readIndex / BitSizeOfByte }
    private var readBitIndex : Int { return readIndex % BitSizeOfByte }
    
    var available : Int { return writeIndex - readIndex }
    
    var free : Int { return bitsAsBytes.count * 8 - available }
    
    public init(capacity: Int = BitSizeOfInt)
    {
        bitsAsBytes = Array<UInt8>(count: max(1, capacity / 8), repeatedValue: 0)
    }
    
    
    
    func extend()
    {
        bitsAsBytes += Array<UInt8>(count: max(1, bitsAsBytes.count), repeatedValue: 0)
    }
    
    func reset()
    {
        writeIndex = 0
        readIndex = 0
    }
    
    public func write(bit: Bit)
    {
        writeBit(bit)
    }
    
    public func writeBit(bit: Bit)
    {
        let byteIndex = writeByteIndex
        let bitIndex = writeBitIndex
        
        writeIndex++
        
        while byteIndex >= bitsAsBytes.count
        {
            extend()
        }
        
        bitsAsBytes[byteIndex].setBit(bitIndex, bit)
    }
    
    public func write(bits: [Bit])
    {
        for bit in bits
        {
            write(bit)
        }
    }
    
    func peekBit() throws -> Bit
    {
        guard available > 0 else { throw Error.OutOfBounds(1, available) }
        
        return bitsAsBytes[readByteIndex][readBitIndex]
    }
    
    public func readBit() throws -> Bit
    {
        defer { readIndex++ ; if readIndex >= writeIndex { reset() } }
        
        return try peekBit()
    }
    
    public func readBits(count: Int) throws -> [Bit]
    {
        guard count > 0 else { return [] }
        
        var bits = Array<Bit>(count: count, repeatedValue: Bit.Zero)
        
        for var i = 0; i < count; i++
        {
            bits[i] = try readBit()
        }
        
        return bits
    }
    
    func peekByteAt(peekIndex: Int) -> UInt8
    {
        var byte : UInt8 = 0
        
        for var offset = 0;
            offset < BitSizeOfByte && peekIndex + offset < writeIndex;
            offset++
        {
            let peekByteIndex = (peekIndex + offset) / BitSizeOfByte
            let peekBitIndex = (peekIndex + offset) % BitSizeOfByte
            
            byte[offset] = bitsAsBytes[peekByteIndex][peekBitIndex]
        }
        
        return byte
    }
    
    public var bytes : [UInt8]
        {
            var bytes = Array<UInt8>()
            
            for var index = readIndex;
                index < writeIndex;
                index += BitSizeOfByte
            {
                bytes.append(peekByteAt(index))
            }
            
            return bytes
    }
    
    public func readBool() throws -> Bool
    {
        return try readBit() == .One
    }
    
    public func writeBool(bool: Bool)
    {
        writeBit(bool ? .One : .Zero)
    }
    
    public func write(bool: Bool)
    {
        writeBool(bool)
    }
    
    public func writeInt(integer: Int, bits: Int = BitSizeOfInt, signed: Bool = false)
    {
        guard bits > 0 else { return }
        
        if signed
        {
            writeBit(integer < 0 ? .One : .Zero)
        }
        
        let indexMax = BitSizeOfInt
        
        for index in (indexMax - bits).stride(to: indexMax, by: 1)
        {
            writeBit(integer[index])
        }
    }
    
    public func writeOptionalInt(integer: Int?, bits: Int = BitSizeOfInt, signed: Bool = false)
    {
        if let i = integer
        {
            write(true)
            writeInt(i, bits: bits, signed: signed)
        }
        else
        {
            write(false)
        }
    }
    
    public func readInt(bits: Int = BitSizeOfInt, signed: Bool = false) throws -> Int
    {
        guard bits <= available else { throw Error.OutOfBounds(bits, bits - available) }
        
        var workingInteger = Int(0)
        
        if signed
        {
            if try readBit() == .One
            {
                workingInteger = -1
            }
        }
        
        for index in (BitSizeOfInt - bits).stride(to: BitSizeOfInt, by: 1) //stride(from: BitSizeOfInt - bits, to: BitSizeOfInt, by: 1)
        {
            workingInteger[index] = try readBit()
        }
        
        return workingInteger
    }

    public func readOptionalInt(bits: Int = BitSizeOfInt, signed: Bool = false) throws -> Int?
    {
        if try readBool()
        {
            return try readInt(bits, signed: signed)
        }
        
        return nil
    }
    
    public func writeString(string: String)
    {
        let stringBytes = Array<UInt8>(string.utf8)
        
        writeInt(stringBytes.count * BitSizeOfByte) // Write bits count, NOT bytes-count
        
        for byte in stringBytes
        {
            for index in 0 ..< BitSizeOfByte
            {
                writeBit(byte[index])
            }
        }
    }
    
    public func readString() throws -> String
    {
        let length = try readInt(BitSizeOfInt)
        
        guard length <= available else { throw Error.OutOfBounds(length, length - available) }
        
        var stringBytes = Array<UInt8>(count: length / BitSizeOfByte, repeatedValue: 0)
        
        for var index = 0; index < length; index++
        {
            stringBytes[index / BitSizeOfByte][index % BitSizeOfByte] = try readBit()
        }
        
        if let string = String(bytes: stringBytes, encoding: NSUTF8StringEncoding)
        {
            return string
        }
        
        throw Error.MalformedBits(String)
    }
    
    public func readDouble() throws -> Double
    {
        let doubleString = try readString()
        
        if let double = Double(doubleString)
        {
            return double
        }
        
        throw Error.MalformedBits(Double)
    }
    
    public func writeDouble(double: Double)
    {
        writeString("\(double)")
    }
    
    public func writeDate(date: NSDate)
    {
        writeDouble(date.timeIntervalSinceReferenceDate)
    }
    
    public func readDate() throws -> NSDate
    {
        let timeintervalSinceRefereceDate = try readDouble()
        
        return NSDate(timeIntervalSinceReferenceDate: timeintervalSinceRefereceDate)
    }
    
    public func read<B:Bitable>(type: B.Type) throws -> B
    {
        return try B(buffer: self)
    }
    
    public func readOptional<B:Bitable>(type: B.Type) throws -> B?
    {
        if try readBool()
        {
            return try B(buffer: self)
        }
        return nil
    }
    
    public func write(bitable: Bitable)
    {
        bitable.write(self)
    }
    
    public func writeOptional(bitable: Bitable?)
    {
        writeBool(bitable != nil)
        bitable?.write(self)
    }
}

extension BitBuffer: CustomDebugStringConvertible
{
    public var debugDescription : String
        {
            //            let readIndexString = "".join(Array<String>(count: readIndex, repeatedValue: "-")) + "^"
            
            let bitStrings = bitsAsBytes[readByteIndex...writeByteIndex].map { String($0, radix: 2, paddedToSize: 8) }
            
            let bitsString = bitStrings.joinWithSeparator("")
            
            let range = Range(start: readBitIndex, end:(bitsString.characters.count - (BitSizeOfByte - writeBitIndex)))

//            bitsString[range]
            
            //            let writeIndexString = "".join(Array<String>(count: writeIndex, repeatedValue: "-")) + "v"
            
            return "(a:\(available), r:\(self.readBitIndex) [\(bitsString[range])]  w:\(writeBitIndex)"
    }
}

//MARK: (NS)Data

extension BitBuffer
{
    public convenience init(data: NSData)
    {
        let byteCount = data.length
        self.init(capacity: byteCount * BitSizeOfByte)
        
        data.getBytes(&bitsAsBytes, length: byteCount)
        
        writeIndex = byteCount * BitSizeOfByte
    }
    
    var data: NSData
        {
            return NSData(bytes: bytes)
    }
}

extension NSData
{
    public convenience init(var bytes: [UInt8])
    {
        self.init(bytes:&bytes, length:bytes.count)
    }
}
