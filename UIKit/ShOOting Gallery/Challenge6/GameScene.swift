//
//  GameScene.swift
//  Challenge6
//
//  Created by Azoz Salah on 23/09/2022.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var gameTimer: Timer!
    var gameDuration: Timer!
    var bulletsLabelNode: SKLabelNode!
    var bulletsIcon: SKSpriteNode!
    var reloadLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    
    var secondsRemaining = 60 {
        didSet {
            timeLabel.text = "Time left: \(secondsRemaining)"
            if secondsRemaining < 5 {
                timeLabel.fontColor = .red
                if secondsRemaining == 0 {
                    gameOver()
                }
            }
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var row = 0 {
        didSet {
            if row == 3 {
                row = 0
            }
        }
    }
    
    var bullets = 6 {
        didSet {
            bulletsLabelNode.text = "\(bullets)"
            if bullets == 0 {
                reload()
            }
        }
    }
    
    var allDucks = ["brownDuck_bad" : +10, "brownDuckGood": -10, "yellowDuck_bad": +50, "yellowDuck_good": -50]
    var rowPositions = [CGPoint(x: 0, y: 100), CGPoint(x: 0, y: 300), CGPoint(x: 0, y: 500)]

    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = frame.size
        background.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        scoreLabel.fontSize = 48
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 1024, y: 718)
        scoreLabel.zPosition = 3
        addChild(scoreLabel)
        
        score = 0
        
        bulletsIcon = SKSpriteNode(imageNamed: "icon_bullet")
        bulletsIcon.size = CGSize(width: 48, height: 48)
        bulletsIcon.position = CGPoint(x: 32, y: 32)
        bulletsIcon.xScale = bulletsIcon.xScale * -1
        bulletsIcon.zPosition = 3
        addChild(bulletsIcon)
        
        bulletsLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        bulletsLabelNode.fontSize = 48
        bulletsLabelNode.text = "6"
        bulletsLabelNode.horizontalAlignmentMode = .left
        bulletsLabelNode.position = CGPoint(x: 80, y: 16)
        bulletsLabelNode.zPosition = 4
        addChild(bulletsLabelNode)
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.fontSize = 35
        timeLabel.text = "Time left: 60"
        timeLabel.position = CGPoint(x: 0, y: 718)
        timeLabel.zPosition = 3
        timeLabel.horizontalAlignmentMode = .left
        addChild(timeLabel)
        
        let curtainTop = SKSpriteNode(imageNamed: "curtain_straight")
        curtainTop.size = CGSize(width: frame.width, height: 100)
        curtainTop.position = CGPoint(x: frame.width / 2, y: 718)
        curtainTop.zPosition = 2
        addChild(curtainTop)
        
        let curtainLeft = SKSpriteNode(imageNamed: "curtain-left")
        curtainLeft.position = CGPoint(x: 50, y: frame.height / 2)
        curtainLeft.size = CGSize(width: 150, height: frame.height)
        curtainLeft.zPosition = 2
        addChild(curtainLeft)
        
        let curtainRight = SKSpriteNode(imageNamed: "curtain-left")
        curtainRight.xScale = curtainRight.xScale * -1
        curtainRight.position = CGPoint(x: 974, y: frame.height / 2)
        curtainRight.size = CGSize(width: 150, height: frame.height)
        curtainRight.zPosition = 2
        addChild(curtainRight)
        
        let info = SKSpriteNode(imageNamed: "info")
        info.size = CGSize(width: 44, height: 44)
        info.position = CGPoint(x: 300, y: 730)
        info.name = "info"
        info.zPosition = 4
        addChild(info)
        
        createRows(rowSize: CGSize(width: 3000, height: 87), rowPosition: rowPositions[0])
        createRows(rowSize: CGSize(width: 3000, height: 87), rowPosition: rowPositions[1])
        createRows(rowSize: CGSize(width: 3000, height: 87), rowPosition: rowPositions[2])
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        setTimers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let nodeName = node.name else { return }
            
            if allDucks.keys.contains(nodeName) {
                if bullets > 0 {
                    score += allDucks[nodeName] ?? 0
                    bullets -= 1
                    
                    showEffect(location: location)
                    node.removeFromParent()
                }
                
            } else if nodeName == "reload" {
                bullets = 6
                node.removeFromParent()
                if let bulletsLabelNode = childNode(withName: "reloadLabel") as? SKLabelNode {
                    bulletsLabelNode.removeFromParent()
                }
                
            } else if nodeName == "reset" {
                resetGameScene()
            } else if nodeName == "info" {
                showInfo()
            } else if nodeName == "back" {
                goBack()
            } else {
                if bullets > 0 {
                    score -= 10
                    bullets -= 1
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in children {
            if node.position.x < 0 || node.position.x > 1024 {
                node.removeFromParent()
            }
        }
    }
    
    func setTimers() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createDuck), userInfo: nil, repeats: true)
        
        gameDuration?.invalidate()
        gameDuration = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: { [weak self] _ in
            self?.secondsRemaining -= 1
        })
    }
    
    func createRows(rowSize: CGSize, rowPosition: CGPoint) {
        let row = SKShapeNode(rectOf: rowSize)
        row.fillColor = hexStringToUIColor(hex: "#3FA5E0")
        row.strokeColor = hexStringToUIColor(hex: "#A16D38")
        row.lineWidth = 3
        row.position = rowPosition
        row.zPosition = 1
        addChild(row)
    }
    
    @objc func createDuck() {
        var nodeName = "brownDuckGood"
        let sprite = SKSpriteNode(imageNamed: nodeName)
        
        if Int.random(in: 0...5) == 0 {
            // yellow duck
            if Int.random(in: 0...1) == 0 {
                // yellow duck good
                nodeName = "yellowDuck_good"
            } else {
                //yellow duck bad
                nodeName = "yellowDuck_bad"
            }
        } else {
            // brown duck
            if Int.random(in: 0...5) == 0 {
                // brown duck bad
                nodeName = "brownDuck_bad"
            } else {
                // brown duck good
                nodeName = "brownDuckGood"
            }
        }
        
        sprite.texture = SKTexture(imageNamed: nodeName)
        sprite.name = nodeName
        
        row += 1
        if row == 0 {
            //middleRow(right to left)
            sprite.xScale *= -1
            sprite.position = CGPoint(x: 1024, y: 390)
            sprite.run(SKAction.repeatForever(SKAction.moveBy(x: CGFloat(Int.random(in: 150...400) * -1), y: 0, duration: 0.5)))
        } else {
            if row == 1 {
                //topRow (left to right)
                sprite.position = CGPoint(x: 0, y: 590)
            }else {
                //bottomRow ( left to right)
                sprite.position = CGPoint(x: 0, y: 190)
            }
            sprite.run(SKAction.repeatForever(SKAction.moveBy(x: CGFloat(Int.random(in: 150...400)), y: 0, duration: 0.5)))
        }
        sprite.zPosition = 0
        addChild(sprite)
    }
    
    func showHudBackground() {
        for child in children {
            child.isPaused = true
        }
        
        for timer in [gameDuration, gameTimer] {
            timer?.invalidate()
        }
        
        let hudBackground = SKSpriteNode(imageNamed: "bg_wood")
        hudBackground.size = CGSize(width: frame.size.width / 2, height: frame.size.width / 2)
        hudBackground.position = CGPoint(x: 512, y: 368)
        hudBackground.zPosition = 5
        hudBackground.name = "hudBackground"
        addChild(hudBackground)
        
    }
    
    func gameOver() {
        
        showHudBackground()
        
        let gameOver = SKSpriteNode(imageNamed: "gameover")
        gameOver.size = CGSize(width: 349, height: 72)
        gameOver.position = CGPoint(x: 512, y: 536)
        gameOver.zPosition = 6
        addChild(gameOver)
        
        let finalScoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        finalScoreLabel.fontColor = .green
        finalScoreLabel.text = scoreLabel.text
        finalScoreLabel.fontSize = 64
        finalScoreLabel.position = CGPoint(x: 512, y: 380)
        finalScoreLabel.zPosition = 6
        addChild(finalScoreLabel)
        
        let resetLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        resetLabel.text = "RESET"
        resetLabel.name = "reset"
        resetLabel.fontColor = .red
        resetLabel.fontSize = 64
        resetLabel.position = CGPoint(x: 512, y: 264)
        resetLabel.zPosition = 6
        addChild(resetLabel)
        
    }
    
    func showEffect(location: CGPoint) {
        let remove = SKAction.removeFromParent()
        
        if let particleNode = SKEmitterNode(fileNamed: "Particle") {
            particleNode.position = location
            particleNode.zPosition = 4
            addChild(particleNode)
            
            let duaration = SKAction.wait(forDuration: 0.5)
            particleNode.run(SKAction.sequence([duaration, remove]))
        }
    }
    
    func resetGameScene(){
        let gameScene:GameScene = GameScene(size: frame.size) // create your new scene
        let transition = SKTransition.fade(withDuration: 1.0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    
    func showInfo() {
        showHudBackground()
        
        var height = 245
        var count = 0
        
        for duck in allDucks {
            let nodeImg = SKSpriteNode(imageNamed: duck.key)
            nodeImg.size = CGSize(width: 64, height: 64)
            nodeImg.position = CGPoint(x: 360, y: height)
            nodeImg.zPosition = 6
            nodeImg.name = "nodeImg\(count)"
            addChild(nodeImg)
            
            let nodeLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
            nodeLabel.fontSize = 48
            nodeLabel.text = " -> \(duck.value) Points"
            nodeLabel.position = CGPoint(x: 540, y: height)
            nodeLabel.zPosition = 6
            nodeLabel.name = "nodeLabel\(count)"
            addChild(nodeLabel)
            
            height += 100
            count += 1
        }
        
        let backLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        backLabel.fontSize = 64
        backLabel.fontColor = .red
        backLabel.position = CGPoint(x: 512, y: 150)
        backLabel.zPosition = 6
        backLabel.text = "BACK"
        backLabel.name = "back"
        addChild(backLabel)
    }
    
    func reload() {
        reloadLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        reloadLabel.fontSize = 48
        reloadLabel.name = "reload"
        reloadLabel.text = "RELOAD"
        reloadLabel.horizontalAlignmentMode = .right
        reloadLabel.position = CGPoint(x: 1024, y: 16)
        reloadLabel.zPosition = 4
        addChild(reloadLabel)
    }
    
    func goBack() {
        for child in children {
            child.isPaused = false
        }
        setTimers()
        
        for nodeName in ["nodeImg0", "nodeLabel0","nodeImg1", "nodeLabel1","nodeImg2", "nodeLabel2","nodeImg3", "nodeLabel3", "back", "hudBackground"] {
            if let node = self.childNode(withName: nodeName) {
                node.removeFromParent()
            }
        }
    }
}
