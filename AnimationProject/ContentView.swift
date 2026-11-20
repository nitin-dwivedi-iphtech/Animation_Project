//
//  ContentView.swift
//  AnimationProject
//
//  Created by iPHTech 40 on 02/09/26.
//
import SwiftUI

protocol CustomAnimations {
    var progress: CGFloat { get }
    func lerp(from: CGFloat, to:CGFloat) -> CGFloat
}

extension CustomAnimations {
    func lerp(from: CGFloat, to:CGFloat) -> CGFloat {
        return from + (to-from) * progress
    }
}

struct ContentView: View {
   
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            AnimationView()
        }
    }
}

//struct RepulsionAnimation:View {
//    @StateObject private var sceneHolder = SceneHolder()
//
//    var body: some View {
//        GeometryReader { proxy in
//            SpriteView(scene: sceneHolder.getScene(size: proxy.size))
//                .ignoresSafeArea()
//        }
//        .background(Color.black)
//    }
//}

#Preview {
    ContentView()
}
