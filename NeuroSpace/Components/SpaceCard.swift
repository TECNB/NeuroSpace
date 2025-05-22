//
//  SpaceCard.swift
//  NeuroSpace
//
//  Created by TEC on 2025/5/22.
//

import SwiftUI

struct SpaceCard: View {
    var space: CollaborationSpace
    var isSelected: Bool = false
    
    
    @State private var isHovering: Bool = false
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 顶部预览图
            ZStack(alignment: .topTrailing) {
                // 预览背景和内容
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hue: colorFromString(space.previewImage).0, 
                               saturation: colorFromString(space.previewImage).1, 
                               brightness: colorFromString(space.previewImage).2)
                          .opacity(0.2))
                    .overlay {
                        // 根据空间名称生成不同的3D预览
                        ZStack {
                            switch space.previewImage {
                            case "project_planning":
                                project3DPreview
                            case "brainstorming":
                                brainstorm3DPreview
                            case "system_architecture":
                                architecture3DPreview
                            case "roadmap":
                                roadmap3DPreview
                            default:
                                defaultPreview
                            }
                        }
                        .padding(12)
                    }
                    .overlay(
                        // 渐变遮罩效果
                        LinearGradient(
                            colors: [
                                .clear,
                                Color(hue: colorFromString(space.previewImage).0, 
                                     saturation: colorFromString(space.previewImage).1, 
                                     brightness: colorFromString(space.previewImage).2).opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // 成员人数指示
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.caption2)
                    
                    Text("\(space.members)")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(12)
            }
            .frame(height: 180)
            
            // 空间信息
            VStack(alignment: .leading, spacing: 10) {
                Text(space.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(space.description)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                // 分隔线
                Rectangle()
                    .fill(.quaternary)
                    .frame(height: 0.5)
                    .padding(.vertical, 4)
                
                // 底部信息区
                HStack {
                    // 最后修改时间
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        
                        Text(formatDate(space.lastModified))
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    
                    Spacer()
                    
                    // 进入按钮
                    Button {
                        // 进入空间操作
                        Task {
                            await openImmersiveSpace(id: "ImmersiveSpace")
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text("进入")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            Image(systemName: "arrow.right")
                                .font(.caption)
                        }
                        .foregroundStyle(isSelected ? .white : .accentColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isSelected ? Color.accentColor : Color.accentColor.opacity(0.1))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color(.black).opacity(0.08), 
                radius: 3, 
                x: 0, 
                y: 1)
        .glassBackgroundEffect()
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .onHover { hovering in
            isHovering = hovering
        }
    }
    
    // 从字符串生成一致的颜色值
    private func colorFromString(_ string: String) -> (Double, Double, Double) {
        var hash = 0
        for char in string.unicodeScalars {
            hash = Int(char.value) &+ ((hash << 5) &- hash)
        }
        
        let hue = Double(abs(hash) % 360) / 360.0
        return (hue, 0.7, 0.8) // 固定的饱和度和亮度
    }
    
    // 格式化日期
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // 3D预览样式 - 项目规划
    private var project3DPreview: some View {
        GanttChartPreview()
    }
    
    // 3D预览样式 - 创意风暴
    private var brainstorm3DPreview: some View {
        BrainstormingPreview()
    }
    
    // 3D预览样式 - 系统架构
    private var architecture3DPreview: some View {
        ArchitecturePreview()
    }
    
    // 3D预览样式 - 路线图
    private var roadmap3DPreview: some View {
        RoadmapPreview()
    }
    
    // 默认预览
    private var defaultPreview: some View {
        ZStack {
            Image(systemName: "square.on.square.dashed")
                .font(.system(size: 50))
                .foregroundStyle(.quaternary)
        }
    }
}

// 简单的甘特图预览
struct GanttChartPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<5) { index in
                HStack(spacing: 6) {
                    // 标签
                    Text("任务\(index+1)")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .frame(width: 40, alignment: .leading)
                    
                    // 进度条
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 12)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: index % 2 == 0 ? 
                                        [Color.blue, Color.blue.opacity(0.7)] : 
                                        [Color.green, Color.green.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: CGFloat.random(in: 60...140), height: 12)
                            .offset(x: CGFloat.random(in: 0...30))
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
    }
}

// 简单的头脑风暴预览
struct BrainstormingPreview: View {
    var body: some View {
        ZStack {
            // 连线
            Path { path in
                path.move(to: CGPoint(x: 100, y: 80))
                path.addLine(to: CGPoint(x: 50, y: 50))
                path.move(to: CGPoint(x: 100, y: 80))
                path.addLine(to: CGPoint(x: 150, y: 50))
                path.move(to: CGPoint(x: 100, y: 80))
                path.addLine(to: CGPoint(x: 150, y: 120))
                path.move(to: CGPoint(x: 100, y: 80))
                path.addLine(to: CGPoint(x: 50, y: 120))
                path.move(to: CGPoint(x: 50, y: 50))
                path.addLine(to: CGPoint(x: 20, y: 30))
                path.move(to: CGPoint(x: 150, y: 50))
                path.addLine(to: CGPoint(x: 180, y: 30))
            }
            .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
            
            // 节点
            ForEach(0..<6) { index in
                let colors: [Color] = [.blue, .purple, .teal, .orange, .green, .pink]
                let positions: [CGPoint] = [
                    CGPoint(x: 100, y: 80), // 中心
                    CGPoint(x: 50, y: 50),  // 左上
                    CGPoint(x: 150, y: 50), // 右上
                    CGPoint(x: 150, y: 120), // 右下
                    CGPoint(x: 50, y: 120),  // 左下
                    CGPoint(x: 20, y: 30),   // 远左上
                    CGPoint(x: 180, y: 30)   // 远右上
                ]
                
                // 只使用前6个位置和颜色
                if index < positions.count && index < colors.count {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [colors[index], colors[index].opacity(0.7)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 20
                                )
                            )
                            .frame(width: index == 0 ? 40 : 30, height: index == 0 ? 40 : 30)
                        
                        if index == 0 {
                            Text("主题")
                                .font(.system(size: 10))
                                .foregroundStyle(.white)
                        } else {
                            Text("想法\(index)")
                                .font(.system(size: 8))
                                .foregroundStyle(.white)
                        }
                    }
                    .position(positions[index])
                    .shadow(color: colors[index].opacity(0.5), radius: 5)
                }
            }
        }
    }
}

// 简单的架构预览
struct ArchitecturePreview: View {
    var body: some View {
        ZStack {
            // 连接线
            Path { path in
                // 顶部到中间的连线
                path.move(to: CGPoint(x: 100, y: 45))
                path.addLine(to: CGPoint(x: 100, y: 55))
                path.move(to: CGPoint(x: 100, y: 55))
                path.addLine(to: CGPoint(x: 70, y: 75))
                path.move(to: CGPoint(x: 100, y: 55))
                path.addLine(to: CGPoint(x: 130, y: 75))
                
                // 中间层到底部的连线
                path.move(to: CGPoint(x: 70, y: 100))
                path.addLine(to: CGPoint(x: 70, y: 110))
                path.move(to: CGPoint(x: 70, y: 110))
                path.addLine(to: CGPoint(x: 50, y: 125))
                path.move(to: CGPoint(x: 70, y: 110))
                path.addLine(to: CGPoint(x: 90, y: 125))
                
                path.move(to: CGPoint(x: 130, y: 100))
                path.addLine(to: CGPoint(x: 130, y: 110))
                path.move(to: CGPoint(x: 130, y: 110))
                path.addLine(to: CGPoint(x: 110, y: 125))
                path.move(to: CGPoint(x: 130, y: 110))
                path.addLine(to: CGPoint(x: 150, y: 125))
            }
            .stroke(Color.white.opacity(0.7), lineWidth: 1.5)
            
            // 架构组件
            VStack(spacing: 15) {
                // 顶层组件
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 30)
                    
                    Text("前端")
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                }
                
                // 中层组件
                HStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Color.green.opacity(0.8), Color.green.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 70, height: 25)
                        
                        Text("服务层")
                            .font(.system(size: 10))
                            .foregroundStyle(.white)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [Color.green.opacity(0.8), Color.green.opacity(0.5)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 70, height: 25)
                        
                        Text("数据层")
                            .font(.system(size: 10))
                            .foregroundStyle(.white)
                    }
                }
                
                // 底层组件
                HStack(spacing: 10) {
                    ForEach(0..<4) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.5)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 20)
                            
                            Text("模块\(index+1)")
                                .font(.system(size: 8))
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
    }
}

// 简单的路线图预览
struct RoadmapPreview: View {
    var body: some View {
        ZStack {
            // 背景图形
            Rectangle()
                .fill(Color.white.opacity(0.05))
                .frame(height: 40)
                .offset(y: 80)
            
            // 主轴线
            Path { path in
                path.move(to: CGPoint(x: 30, y: 80))
                path.addLine(to: CGPoint(x: 170, y: 80))
            }
            .stroke(
                LinearGradient(
                    colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 3
            )
            
            // 里程碑点
            ForEach(0..<4) { index in
                let position = 30 + 140 / 3 * index
                let colors: [Color] = [.blue, .green, .purple, .orange]
                
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [colors[index], colors[index].opacity(0.7)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 15
                            )
                        )
                        .frame(width: 24, height: 24)
                        .shadow(color: colors[index].opacity(0.5), radius: 4)
                    
                    Text("\(index + 1)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
                .position(x: CGFloat(position), y: 80)
                
                // 上方文本
                VStack {
                    Text("阶段\(index + 1)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white)
                    
                    Text("Q\(index + 1)")
                        .font(.system(size: 8))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .position(x: CGFloat(position), y: 40)
                
                // 下方小线条
                Rectangle()
                    .fill(colors[index].opacity(0.7))
                    .frame(width: 1, height: 20)
                    .position(x: CGFloat(position), y: 100)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        SpaceCard(space: sampleSpaces[0], isSelected: true)
        SpaceCard(space: sampleSpaces[1], isSelected: false)
    }
    .padding(30)
    .background(Color(.systemGray6))
} 
