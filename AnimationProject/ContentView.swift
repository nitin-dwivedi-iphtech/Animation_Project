//
//  ContentView.swift
//  AnimationProject
//
//  Created by iPHTech 40 on 02/09/26.
//
import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var sceneHolder = SceneHolder()

    var body: some View {
        GeometryReader { proxy in
            SpriteView(scene: sceneHolder.getScene(size: proxy.size))
                .ignoresSafeArea()
        }
        .background(Color.black)
    }
}
