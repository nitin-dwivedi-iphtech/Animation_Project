//
//  LampView.swift
//  AnimationProject
//
//  Created by iPHTech 40 on 18/09/26.
//
import SwiftUI

struct LampView: View {
    @State var progress: CGFloat = 0.0
    @Binding var previousProgress: CGFloat
    @Binding var stage2Progress: CGFloat
    @State var lightShowProgress: CGFloat = 0.0
    
    @Binding var stage: Int
    @State private var waveAngle: Double = 0.0
    @State private var isWaving: Bool = false
    
    var lightOpacity: Double {
        switch lightShowProgress {
        case 1.0:
            return 1.0
        default:
            return 0.0
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color("DarkBrown"))
                .frame(width: 10, height: 110)
            
            HStack(spacing: 0) {
                UnevenRoundedRectangle(topLeadingRadius: 35)
                    .fill(Color("DarkRed").opacity(0.89))
                    .frame(width: 70, height: 40)
                
                UnevenRoundedRectangle(topTrailingRadius: 35)
                    .fill(Color.orange)
                    .frame(width: 70, height: 40)
            }
            .zIndex(1)
            .background(alignment: .bottom) {
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                    .offset(y: 10)
            }
            .background {
                HStack(spacing: 0) {
                    LeftTraingle()
                        .fill(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 80, height: 100)
                    
                    RightTraingle()
                        .fill(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 80, height: 100)
                }
                .opacity(lightOpacity)
                .offset(y: 30)
                .zIndex(0)
            }
        }
        .rotationEffect(
            isWaving ? .degrees(waveAngle) : .degrees(Double(1.0 - progress) * -90.0),
            anchor: .top
        )
        .scaleEffect(progress == 0 ? 0.0 : 1.0)
        .onChange(of: stage2Progress) { _, newValue in
            Task { @MainActor in
                if newValue == 1.0 {
                    progress = 0.0
                    lightShowProgress = 0.0
                    isWaving = false
                    waveAngle = 0.0
                    
                    withAnimation(.easeInOut(duration: 1.0)) {
                        progress = 1.0
                    }
                    
                    try? await Task.sleep(for: .seconds(0.7))
                    
                    await waveLamp()
                    
                    try? await Task.sleep(for: .seconds(0.3))
                    
                    withAnimation(.easeInOut(duration: 0.4)) {
                        lightShowProgress = 1.0
                    }
                    try? await Task.sleep(for: .seconds(0.5))
                    withAnimation(.easeInOut(duration: 0.4)) {
                        lightShowProgress = 0.0
                    }
                    try? await Task.sleep(for: .seconds(0.5))
                    
                    withAnimation(.easeInOut(duration: 0.4)) {
                        lightShowProgress = 1.0
                    }
                    
                    try? await Task.sleep(for: .seconds(1.5))
                    await reset()
                }
            }
        }
    }
    
    func waveLamp() async {
        isWaving = true
        
        withAnimation(.easeInOut(duration: 0.6)) {
            waveAngle = -18.0
        }
        try? await Task.sleep(for: .seconds(0.6))
        
        withAnimation(.easeInOut(duration: 0.9)) {
            waveAngle = 18.0
        }
        try? await Task.sleep(for: .seconds(0.9))
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            waveAngle = 0.0
        }
        try? await Task.sleep(for: .seconds(0.8))
        
        isWaving = false
    }
    
    func reset() async {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            previousProgress = 0.0
            stage = 0
            progress = 0.0
            stage2Progress = 0.0
            lightShowProgress = 0.0
            waveAngle = 0.0
            isWaving = false
        }
        try? await Task.sleep(for: .seconds(0.4))
        withAnimation(.spring(response: 1.8, dampingFraction: 0.75)) {
            previousProgress = 1.0
        }
    }
}

struct RightTraingle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct LeftTraingle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LampView(
            previousProgress: .constant(1.0),
            stage2Progress: .constant(1.0),
            stage: .constant(1)
        )
    }
}
