//
//  BackgroundScroll.swift
//  BackgroundScroll
//
//  Created by Pablo on 24/04/2019.
//  Copyright © 2019 Pablo Garcia. All rights reserved.
//

import SpriteKit

enum Implementation {
    case actions
    case linkedlist
}

class BackgroundScroll {
    
    private let backgrounds: [SKSpriteNode]
    private var linkedBackgrounds = LinkedList<SKSpriteNode>()
    
    private unowned let scene: SKScene
    private let speed: CGFloat = 25
    private var totalWidth: CGFloat = 0

    init?(sprites: [SKSpriteNode], scene: SKScene, implementation: Implementation){
        guard sprites.count > 1 else {
            print("You have to include at least two backgrounds")
            return nil
        }
        self.scene = scene
        self.backgrounds = sprites
        switch implementation {
        case .actions:
            addBackgroundsToSceneAndCalculateTotalWidth()
        case .linkedlist:
            createLinkedList()
        }
    }

    private func addBackgroundsToSceneAndCalculateTotalWidth() {
        
        for background in backgrounds {
            self.scene.addChild(background)
            totalWidth+=background.frame.width
        }
    }
    
    private func createLinkedList() {
        var offset: CGFloat = 0
        let xOrigin = self.scene.frame.width/2
        
        for sprite in backgrounds {
            sprite.position = CGPoint(x: xOrigin+offset+sprite.frame.width/2, y: self.scene.frame.height/2)
            linkedBackgrounds.append(value: sprite)
            self.scene.addChild(sprite)
            offset += sprite.size.width
        }
    }

    public func scrollRight() {
        var offset: CGFloat = 0
        var spaceToBeOutsideScene: CGFloat = 0
        let xOrigin = self.scene.frame.width/2

        for node in backgrounds {
            spaceToBeOutsideScene += node.frame.width
            node.position = CGPoint(x: xOrigin+offset+node.frame.width/2, y: self.scene.frame.height/2)
            let actionMoveOutsideScene = SKAction.moveTo(x: xOrigin-node.frame.width/2, duration: TimeInterval(spaceToBeOutsideScene/speed))
            let actionMoveRightToLeft = SKAction.moveTo(x: xOrigin-node.frame.width/2, duration: TimeInterval((totalWidth)/speed))
            let actionMoveToLastPosition = SKAction.moveTo(x: xOrigin+totalWidth-node.frame.width/2, duration: 0)
            offset += node.size.width
            node.run(SKAction.sequence([actionMoveOutsideScene, SKAction.repeatForever(SKAction.sequence([actionMoveToLastPosition,actionMoveRightToLeft]))]))
        }
    }
    
    public func update(deltaTime: TimeInterval) {
        

        guard !linkedBackgrounds.isEmpty else {
            return
        }
        let v: CGFloat = 10

        if let head = linkedBackgrounds.first {
            let headSprite = head.value
            headSprite.position = CGPoint(x: headSprite.position.x-CGFloat(deltaTime)*v, y: headSprite.position.y)
            var node = linkedBackgrounds.first
            while node?.next != nil {
                
                let previous = node
                node = node?.next
                node?.value.position = CGPoint(x: (previous?.value.position.x)!+(previous?.value.frame.width)!, y: (previous?.value.position.y)!)
            }
        }

    }

//    private func spriteIsOutOfBounds(sprite: SKSpriteNode) -> Bool {
//
//    }
    
}
