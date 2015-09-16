//
//  BitBufferTests.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 03/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import XCTest

class BitBufferTests: XCTestCase {
    
    func testGetBitInteger()
    {
        let number = 2
        
        XCTAssertEqual(getBit(62, number: number), Bit.One)
        
        debugPrint(String(UInt(bitPattern: number), radix:2, paddedToSize: sizeof(Int) * 8))
        
        for index in 0..<(sizeof(Int) * 8)
        {
            XCTAssertEqual(getBit(index, number: number), number[index], "index: \(index)")
        }
    }
    
    func testWriteAndExtend()
    {
        let buffer = BitBuffer(capacity: 8)
        
        let bits : [Bit] = [.One, .One, .Zero, .One, .Zero, .Zero, .One]

        for bit in bits
        {
            buffer.writeBit(bit)
        }

        XCTAssertEqual(buffer.available, bits.count)
        XCTAssertEqual(buffer.free, 1)
        
        for bit in bits
        {
            XCTAssertEqual(try! buffer.readBit(), bit)
            buffer.writeBit(bit)
        }
        
        XCTAssertEqual(buffer.available, bits.count)
        XCTAssertEqual(buffer.free, bits.count + 2)
        
    }
    
    func testReadThrows()
    {
        let buffer = BitBuffer(capacity: 8)
        
        buffer.writeBit(.One)
        do
        {
            let bit = try buffer.readBit()
            
            XCTAssertEqual(bit, Bit.One)

            try buffer.readBit()
            XCTFail("No throw")
        }
        catch let e
        {
            XCTAssertEqual(buffer.available, 0)
            XCTAssertEqual(buffer.free, 8)

            switch e
            {
            case BitBuffer.Error.OutOfBounds(let needed, let got):
                XCTAssertEqual(got, 0)
                XCTAssertEqual(needed, 1)
            default:
                XCTFail("wrong error: \(e)")
            }
        }
    }
    
    func testWriteBool()
    {
        let buffer = BitBuffer(capacity: 4)
        
        buffer.writeInt(5, bits:4)
        
        XCTAssert(try! !buffer.readBool())
        XCTAssert(try! buffer.readBool())
        XCTAssert(try! !buffer.readBool())
        XCTAssert(try! buffer.readBool())
    }
    
    func testWriteInt()
    {
        let buffer = BitBuffer(capacity: 8)
        
        buffer.writeInt(255, bits:10)

        XCTAssertEqual(buffer.free, 6)

        let readNumber = try! buffer.readInt(9)
        
        XCTAssertEqual(readNumber, 127)
        
    }
    
    func testWriteIntSigned()
    {
        let buffer = BitBuffer(capacity: 8)
        
        buffer.writeInt(-2, bits: 5, signed: true)
        
        let readNumber = try! buffer.readInt(5, signed: true)
        
        XCTAssertEqual(readNumber, -2)
        
        buffer.writeInt(-231, signed: true)

        let minus231 = try! buffer.readInt(signed:true)
        
        XCTAssertEqual(minus231, -231)
        
        buffer.writeInt(231, signed: true)
        
        let _231 = try! buffer.readInt(signed:true)
        
        XCTAssertEqual(_231, 231)
        

    }
    
    func testWriteString()
    {
        let buffer = BitBuffer()
        
        buffer.writeString("test")
        buffer.writeInt(-20, bits: 10, signed: true)
        buffer.writeString("hello you little 👿!")
        do
        {
            let test = try buffer.readString()
            XCTAssertEqual(test, "test")
            
            let integer = try buffer.readInt(10, signed:true)
            XCTAssertEqual(integer, -20)
            
            let hello = try buffer.readString()
            XCTAssertEqual(hello, "hello you little 👿!")
            
        }
        catch let e
        {
            switch e
            {
            case BitBuffer.Error.OutOfBounds(let needed, let got):
                XCTFail("needed \(needed), got \(got)")
            default:
                XCTFail("wrong error: \(e)")
            }
        }
        
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
