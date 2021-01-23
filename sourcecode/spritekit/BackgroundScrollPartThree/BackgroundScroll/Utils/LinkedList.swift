//
//  LinkedList.swift
//  BackgroundScroll
//
//  Created by Pablo on 05/05/2019.
//  Copyright © 2019 Pablo Garcia. All rights reserved.
//

public final class LinkedList<T> {

    public class Node<T> {
        var value: T
        var next: Node<T>?
        weak var previous: Node<T>?

        init(value: T) {
            self.value = value
        }
    }

    fileprivate var head: Node<T>?
    private var tail: Node<T>?

    public var isEmpty: Bool {
        return head == nil
    }

    public var first: Node<T>? {
        return head
    }

    public var last: Node<T>? {
        return tail
    }

    public func append(value: T) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }

    public func appendInit(value: T) {
        let newNode = Node(value: value)
        if let headNode = head {
            headNode.previous = newNode
            newNode.next = headNode
            head = newNode
            if tail == nil {
                tail = headNode
            }
        } else {
            append(value: value)
        }
    }
    public func nodeAt(index: Int) -> Node<T>? {
        if index >= 0 {
            var node = head
            var i = index
            while node != nil {
                if i == 0 { return node }
                i -= 1
                node = node!.next
            }
        }
        return nil
    }

    public func removeAll() {
        head = nil
        tail = nil
    }

    public func remove(node: Node<T>) -> T {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev

        if next == nil {
            tail = prev
        }

        node.previous = nil
        node.next = nil

        return node.value
    }
}
