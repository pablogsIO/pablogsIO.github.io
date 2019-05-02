//
//  MainScene.swift
//  BackgroundScroll
//
//  Created by Pablo on 24/04/2019.
//  Copyright © 2019 Pablo Garcia. All rights reserved.
//


import SpriteKit
import GameplayKit

class MainScene: SKScene {

    var backgroundScroll: BackgroundScroll?
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        var nodes = [SKSpriteNode]()
        let background1 = SKSpriteNode(imageNamed: "background_1")
        let background2 = SKSpriteNode(imageNamed: "background_2")
        let background3 = SKSpriteNode(imageNamed: "background_3")
        let background4 = SKSpriteNode(imageNamed: "background_4")
        
        nodes.append(background1)
        nodes.append(background2)
        nodes.append(background3)
        nodes.append(background4)
        
        self.backgroundScroll = BackgroundScroll(backgrounds: nodes, scene: self)!
        backgroundScroll?.scrollRight()
        
        let fakeScreenWidth = background1.frame.width+background2.frame.width+background3.frame.width
        
        drawLine(start: CGPoint(x: 0, y: self.frame.height/2), end: CGPoint(x: self.frame.width, y: self.frame.height/2),color: SKColor.blue)
        drawLine(start: CGPoint(x: self.frame.width/2, y: 0), end: CGPoint(x: self.frame.width/2, y: self.frame.height),color: SKColor.red)
        drawLine(start: CGPoint(x: self.frame.width/2+fakeScreenWidth, y: 0), end: CGPoint(x: self.frame.width/2+fakeScreenWidth, y: self.frame.height),color: SKColor.red)

    }
    
    private func drawLine(start: CGPoint, end: CGPoint, color: SKColor) {
        
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: start.x, y: start.y))
        path.addLine(to: CGPoint(x: end.x, y: end.y))
        line.path = path
        line.strokeColor = color
        line.lineWidth = 2
        addChild(line)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        print("pablogsio: \(#function)")
    }

}
