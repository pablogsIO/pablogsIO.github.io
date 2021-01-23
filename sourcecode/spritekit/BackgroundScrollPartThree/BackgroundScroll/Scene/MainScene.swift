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

    private var speedLabel: SKLabelNode!

    private var haveToIncreaseSpeed = false

    override init(size: CGSize) {

        super.init(size: size)

        self.setUp()
    }

    override func didMove(to view: SKView) {

        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        longPressGR.delegate = self
        longPressGR.minimumPressDuration = 0.1
        self.view?.addGestureRecognizer(longPressGR)

        speedLabel = SKLabelNode(fontNamed: "Chalkduster")
        speedLabel.fontSize = 50
        speedLabel.text = "0.0"
        speedLabel.horizontalAlignmentMode = .right
        speedLabel.position = CGPoint(x: 400, y: 700)
        addChild(speedLabel)
    }

    @objc func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("LongPress BEGAN detected")
            self.haveToIncreaseSpeed = true
        }
        if sender.state == .ended {
            self.haveToIncreaseSpeed = false
            print("LongPress ENDED detected")
        }
    }

    override func update(_ currentTime: TimeInterval) {

        var delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if delta > 1.0 {
            delta = 0
        }
        self.backgroundScroll?.update(deltaTime: delta, increaseVelocity: self.haveToIncreaseSpeed)
        self.speedLabel.text = String(format: "%.f", self.backgroundScroll!.speed)
        print("pablgosio: \(self.backgroundScroll!.speed.description)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainScene {

    private func createNodes() -> [SKSpriteNode] {

        var nodes = [SKSpriteNode]()
        let background1 = SKSpriteNode(imageNamed: "background_1")
        let background2 = SKSpriteNode(imageNamed: "background_2")
        let background3 = SKSpriteNode(imageNamed: "background_3")
        let background4 = SKSpriteNode(imageNamed: "background_4")

        nodes.append(background1)
        nodes.append(background2)
        nodes.append(background3)
        nodes.append(background4)

        return nodes
    }

    private func setUp() {

        let nodes = createNodes()
        self.backgroundScroll = BackgroundScroll(sprites: nodes, scene: self, implementation: .linkedlist)
        self.drawScreenLimits()
    }

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

extension MainScene: UIGestureRecognizerDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            let position = touch.location(in: self)
            if position.x < self.frame.width/2 && self.backgroundScroll?.direction == Direction.right {
                self.backgroundScroll?.changeDirection()
            } else if self.backgroundScroll?.direction == Direction.left {
                self.backgroundScroll?.changeDirection()
            }
        }
    }
}
