//
//  BackgroundScroll.swift
//  BackgroundScroll
//
//  Created by Pablo on 24/04/2019.
//  Copyright © 2019 Pablo Garcia. All rights reserved.
//

import SpriteKit

class BackgroundScroll {
    
    private let backgrounds: [SKSpriteNode]
    private unowned let scene: SKScene
    private let speed: CGFloat = 25
    private var totalWidth: CGFloat = 0

    init?(backgrounds: [SKSpriteNode], scene: SKScene){
        guard backgrounds.count > 1 else {
            print("You have to include at least two backgrounds")
            return nil
        }
        self.scene = scene
        self.backgrounds = backgrounds
        addBackgroundsToSceneAndCalculateTotalWidth()

    }

    private func addBackgroundsToSceneAndCalculateTotalWidth() {
        
        for background in backgrounds {
            self.scene.addChild(background)
            totalWidth+=background.frame.width
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
    
}
