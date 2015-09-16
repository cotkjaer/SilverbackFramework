//
//  Queue.swift
//  SilverbackFramework
//
//  Created by Christian Otkjær on 01/06/15.
//  Copyright (c) 2015 Christian Otkjær. All rights reserved.
//

import Foundation

// private, as users of Queue never use this directly
private class QueueNode<T>
{
    // note, not optional – every node has a value
    var value: T
    
    // but the last node doesn't have a next
    var next: QueueNode<T>? = nil
    
    init(value: T)
    {
        self.value = value
    }
}

public struct Queue<T>
{
    private var firstNode: QueueNode<T>? = nil
    private var lastNode: QueueNode<T>? = nil
    
    public init() { }
}

extension Queue
{
    mutating public func append(newElement: T)
    {
        let newNode = QueueNode(value:newElement)

        if firstNode == nil
        {
            firstNode = newNode
        }

        lastNode?.next = newNode

        lastNode = newNode
    }

    mutating public func enqueue(newElement: T)
    {
        append(newElement)
    }
    
    mutating public func dequeue() -> T?
    {
        if let _ = firstNode?.value
        {
            firstNode = firstNode?.next
            
            if firstNode == nil
            {
                lastNode = nil
            }
        }
        
        return nil
    }
}

public struct QueueIndex<T>: ForwardIndexType
{
    private let node: QueueNode<T>?
    
    public func successor() -> QueueIndex<T>
    {
        return QueueIndex(node: node?.next)
    }
}

public func ==<T>(lhs: QueueIndex<T>, rhs: QueueIndex<T>) -> Bool
{
    if let lhsNode = lhs.node, let rhsNode = rhs.node
    {
        return lhsNode === rhsNode
    }
    
    return false
}

extension Queue: MutableCollectionType
{
    public typealias Index = QueueIndex<T>
    
    public var startIndex: Index
        { return Index(node: firstNode) }

    public var endIndex: Index
        { return Index(node: nil) }
    
    public subscript(idx: Index) -> T
        {
        get
        {
            if let node = idx.node
            {
                return node.value
            }
            else
            {
                preconditionFailure("Attempt to subscript out of bounds")
            }
        }
        
        set
        {
            if let node = idx.node
            {
                node.value = newValue
            }
            else
            {
                preconditionFailure("Attempt to subscript out of bounds")
            }
        }
    }
    
    public typealias Generator = IndexingGenerator<Queue>
    public func generate() -> Generator
    {
        return Generator(self)
    }
}

// init() and append() requirements are already covered
extension Queue: RangeReplaceableCollectionType
{
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Queue.Index>, with newElements: C) {
        preconditionFailure("TODO: implement")
    }
    
    public func reserveCapacity(n: Index.Distance)
    {
        // do nothing
    }
    
    mutating public func extend<S : SequenceType where S.Generator.Element == T>
        (newElements: S)
    {
        for x in newElements
        {
            append(x)
        }
    }
}

extension Queue: ArrayLiteralConvertible
{
    public init(arrayLiteral elements: T...)
    {
        self.init()
        // conformance to ExtensibleCollectionType makes this easy
        self.extend(elements)
    }
}

extension Queue: CustomStringConvertible
{
    // pretty easy given conformance to CollectionType
    public var description: String
        {
           return String( map { (t) -> String in
                if t is CustomStringConvertible
                {
                    return (t as! CustomStringConvertible).description
                }
                
                return "."
            })
            
//            return "[" + ", ".join(self.map(String.init)) + "]"
    }
}