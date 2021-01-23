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

    var lastUpdateTimeInterval: CFTimeInterval = 0

    override init(size: CGSize) {

        super.init(size: size)

        self.configureNodes()
        self.drawScreenLimits()
    }

    override func update(_ currentTime: TimeInterval) {

        var delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if delta > 1.0 {
            delta = 0
        }
        self.backgroundScroll?.update(deltaTime: delta)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainScene {

	private func configureNodes() {

		let nodes = createNodes()
		self.backgroundScroll = BackgroundScroll(sprites: nodes, scene: self, implementation: .linkedlist)
	}

    private func createNodes() -> [SKSpriteNode] {

        var nodes = [SKSpriteNode]()
        let background1 = SKSpriteNode(imageNamed: "background_1")
        let background2 = SKSpriteNode(imageNamed: "background_2")
        let background3 = SKSpriteNode(imageNamed: "background_3")
        let background4 = SKSpriteNode(imageNamed: "background_4")
		let background5 = SKSpriteNode(imageNamed: "background_2")
		let background6 = SKSpriteNode(imageNamed: "background_3")
		let background7 = SKSpriteNode(imageNamed: "background_1")
		let background8 = SKSpriteNode(imageNamed: "background_4")

        nodes.append(background1)
        nodes.append(background2)
        nodes.append(background3)
        nodes.append(background4)
		nodes.append(background5)
		nodes.append(background6)
		nodes.append(background7)
		nodes.append(background8)

        return nodes
    }
}

extension MainScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let position = touch.location(in: self)

            if position.x < self.frame.width/2 {
                self.backgroundScroll?.changeDirection(direction: .left)
            } else {
                self.backgroundScroll?.changeDirection(direction: .right)
            }
        }
    }
}

extension MainScene {

	private func drawScreenLimits() {

		let fakeScreenWidth: CGFloat = self.backgroundScroll!.fakeScreenBoundRight

		drawLine(start: CGPoint(x: 0, y: self.frame.height/2), end: CGPoint(x: self.frame.width, y: self.frame.height/2), color: SKColor.blue)
		drawLine(start: CGPoint(x: self.frame.width/2, y: 0), end: CGPoint(x: self.frame.width/2, y: self.frame.height), color: SKColor.red)
		drawLine(start: CGPoint(x: fakeScreenWidth, y: 0), end: CGPoint(x: fakeScreenWidth, y: self.frame.height), color: SKColor.green)
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
}
