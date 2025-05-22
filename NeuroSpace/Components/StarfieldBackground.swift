//
//  StarfieldBackground.swift
//  NeuroSpace
//
//  Created by TEC on 2025/5/22.
//

import SwiftUI
import RealityKit

struct StarfieldBackground: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // 深空背景
            Color.black.opacity(0.8)
            
            // 星空层
            GeometryReader { geometry in
                ZStack {
                    // 远距离星星层
                    ForEach(0..<80, id: \.self) { _ in
                        Circle()
                            .fill(.white.opacity(Double.random(in: 0.2...0.5)))
                            .frame(width: Double.random(in: 1...2), height: Double.random(in: 1...2))
                            .position(
                                x: Double.random(in: 0...geometry.size.width),
                                y: Double.random(in: 0...geometry.size.height)
                            )
                            .blur(radius: Double.random(in: 0...0.3))
                    }
                    
                    // 中距离星星层
                    ForEach(0..<50, id: \.self) { _ in
                        Circle()
                            .fill(.white.opacity(Double.random(in: 0.5...0.8)))
                            .frame(width: Double.random(in: 2...3), height: Double.random(in: 2...3))
                            .position(
                                x: Double.random(in: 0...geometry.size.width),
                                y: Double.random(in: 0...geometry.size.height)
                            )
                            .blur(radius: Double.random(in: 0...0.2))
                    }
                    
                    // 近距离星星层
                    ForEach(0..<30, id: \.self) { _ in
                        Circle()
                            .fill(.white.opacity(Double.random(in: 0.8...1.0)))
                            .frame(width: Double.random(in: 2...4), height: Double.random(in: 2...4))
                            .position(
                                x: Double.random(in: 0...geometry.size.width),
                                y: Double.random(in: 0...geometry.size.height)
                            )
                    }
                    
                    // 彩色星云效果
                    ForEach(0..<5, id: \.self) { _ in
                        Nebula(
                            color: [Color.blue, Color.purple, Color.indigo, Color.teal].randomElement()!,
                            width: Double.random(in: geometry.size.width * 0.3...geometry.size.width * 0.6),
                            height: Double.random(in: geometry.size.height * 0.2...geometry.size.height * 0.5)
                        )
                        .position(
                            x: Double.random(in: 0...geometry.size.width),
                            y: Double.random(in: 0...geometry.size.height)
                        )
                        .opacity(Double.random(in: 0.1...0.3))
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .blendMode(.screen)
                    }
                }
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(.linear(duration: 180).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
            }
        }
    }
}

struct Nebula: View {
    var color: Color
    var width: Double
    var height: Double
    
    var body: some View {
        ZStack {
            Ellipse()
                .fill(color)
                .frame(width: width, height: height)
                .blur(radius: 50)
        }
    }
}

#Preview {
    StarfieldBackground()
} 