//
//  GridScene.swift
//  AnimationProject
//
//  Created by iPHTech 40 on 02/09/26.
//

import SpriteKit


class GridScene:SKScene {
    
    private var fieldNode: SKNode!
    private let offBoundayX: Int = -1000
    private let offBoundaryY: Int = -1000
    private var listDotBodies: [SKPhysicsBody] = []
    private let affectRange: CGFloat = 50
    private let fieldStrength: CGFloat = 100
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        createRepulsionNode()
        createDotMatrix()
    }
    
    private func createRepulsionNode() {
        fieldNode = SKNode()
        fieldNode.position = CGPoint(x: offBoundayX, y: offBoundaryY)
        addChild(fieldNode)
    }
    private func createDotMatrix() {
        let spacing:CGFloat = 20
        let cols = Int(size.width/spacing)
        let rows = Int(size.height/spacing)
        
        for row in 0..<rows {
            for col in 0..<cols {
                let x = (CGFloat(col) * spacing) + (spacing / 2)
                let y = (CGFloat(row) * spacing) + (spacing / 2)
                let dotRadius = CGFloat.random(in: 0.5...1.5)
                let dot = SKShapeNode(circleOfRadius: dotRadius)
                dot.fillColor = .systemCyan
                dot.strokeColor = .clear
                dot.position = CGPoint(x: x, y: y)
                
                let body = SKPhysicsBody(circleOfRadius: 1.5)
                body.isDynamic = true
                body.affectedByGravity = false
                body.linearDamping = 3.5
                dot.physicsBody = body
                addChild(dot)
                listDotBodies.append(body)
                
                let anchorNode = SKNode()
                anchorNode.position = dot.position
                let anchorBody = SKPhysicsBody(circleOfRadius: 3)
                anchorBody.isDynamic = false
                anchorNode.physicsBody = anchorBody
                addChild(anchorNode)
                
                // Spring code
                let joint = SKPhysicsJointSpring.joint(withBodyA: body, bodyB: anchorBody, anchorA: dot.position, anchorB: dot.position)
                joint.frequency = 2.5
                joint.damping = 5
                physicsWorld.add(joint)
            }
        }
    }
    
    private func repulsionLogic() {
        for dotBody in listDotBodies {
            guard let dotPosition = dotBody.node?.position else { continue }
            let disX = dotPosition.x - fieldNode.position.x
            let disY = dotPosition.y - fieldNode.position.y
            let actualDis = sqrt((disX * disX) + (disY * disY))
            
            if actualDis <= affectRange && actualDis > 0{
                let fieldStrengthAffect = 1.0 - ((actualDis / affectRange).sigmodFunc())
                let forceMagnitude = fieldStrengthAffect * fieldStrength
                
                let forceVector = CGVector(
                    dx: (disX/actualDis) * forceMagnitude ,
                    dy: (disY/actualDis) * forceMagnitude
                )
                dotBody.applyForce(forceVector)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        repulsionLogic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateFieldPosition(touches)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateFieldPosition(touches)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fieldNode.position = CGPoint(x: offBoundayX, y: offBoundaryY)
    }
    
    private func updateFieldPosition(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            fieldNode.position = touch.location(in: self)
        }
    }
}
