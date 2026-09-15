//
//  SceneHolder.swift
//  AnimationProject
//
//  Created by iPHTech 40 on 02/09/26.
//
import Combine
import SpriteKit
import SwiftUI

class SceneHolder:ObservableObject {
    private var scene: GridScene?
    
    func getScene(size: CGSize) -> SKScene {
        if let existingScene = scene {
            if existingScene.size != size {
                existingScene.size = size
            }
            return existingScene
        }
        
        let newScene = GridScene()
        newScene.size = size
        newScene.scaleMode = .resizeFill
        self.scene = newScene
        return newScene
    }
}
