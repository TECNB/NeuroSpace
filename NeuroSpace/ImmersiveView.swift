//
//  ImmersiveView.swift
//  NeuroSpace
//
//  Created by TEC on 2025/5/22.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    
    @State private var showControlPanel: Bool = true
    @State private var selectedNodeID: UUID?
    @State private var isEditing: Bool = false
    @State private var newNodeText: String = ""
    
    var body: some View {
        ZStack {
            // 3D思维导图内容
            RealityView { content in
                // 添加初始的RealityKit内容
                if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                    content.add(immersiveContentEntity)
                    
                    // 添加思维导图核心节点
                    addMindMapNodes(to: content)
                }
            }
//            .environment(www\.backgroundMaterial, .hidden) // 设置背景为透明
            
            // 浮动控制面板
            if showControlPanel {
                VStack {
                    // 顶部操作栏
                    VStack(spacing: 20) {
                        Text("3D思维导图")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 30) {
                            // 工具按钮
                            ControlButton(title: "添加节点", icon: "plus.circle") {
                                addNewNode()
                            }
                            
                            ControlButton(title: "连接节点", icon: "arrow.triangle.2.circlepath") {
                                connectNodes()
                            }
                            
                            ControlButton(title: "删除节点", icon: "trash") {
                                deleteSelectedNode()
                            }
                            
                            ControlButton(title: "重新布局", icon: "arrow.triangle.swap") {
                                rearrangeLayout()
                            }
                        }
                        
                        // 颜色调色板
                        HStack(spacing: 15) {
                            ForEach([Color.blue, Color.green, Color.orange, Color.purple, Color.red], id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                                    .onTapGesture {
                                        changeNodeColor(to: color)
                                    }
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .glassBackgroundEffect()
                    
                    Spacer()
                    
                    // 编辑节点文本的输入框 (仅在编辑时显示)
                    if isEditing {
                        HStack {
                            TextField("输入节点内容", text: $newNodeText)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                            
                            Button {
                                saveNodeText()
                            } label: {
                                Text("保存")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .glassBackgroundEffect()
                    }
                }
                .frame(maxWidth: 500)
                .padding()
            }
            
            // 切换控制面板的按钮
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showControlPanel.toggle()
                    } label: {
                        Image(systemName: showControlPanel ? "chevron.right.circle.fill" : "chevron.left.circle.fill")
                            .font(.system(size: 30))
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    // 添加思维导图节点
    private func addMindMapNodes(to content: RealityViewContent) {
        // 创建中心节点
        let centerNodeMesh = MeshResource.generateSphere(radius: 0.2)
        let centerNodeMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        let centerNode = ModelEntity(mesh: centerNodeMesh, materials: [centerNodeMaterial])
        centerNode.position = [0, 1.2, 0] // 将中心节点位置提高
        
        // 添加节点文本
        let textMesh = MeshResource.generateText("NeuroSpace",
                                               extrusionDepth: 0.01,
                                               font: .systemFont(ofSize: 0.1),
                                               containerFrame: .zero,
                                               alignment: .center,
                                               lineBreakMode: .byTruncatingTail)
        let textMaterial = SimpleMaterial(color: .white, isMetallic: false)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.position = [0, 0.3, 0]
        
        // 添加子节点
        let childNodeCount = 5
        for i in 0..<childNodeCount {
            let angle = Float(i) * (2 * Float.pi / Float(childNodeCount))
            let radius: Float = 1.0
            
            let x = radius * cos(angle)
            let z = radius * sin(angle)
            
            let childNodeMesh = MeshResource.generateSphere(radius: 0.15)
            let childNodeMaterial = SimpleMaterial(color: [.green, .orange, .purple, .yellow, .red][i % 5], isMetallic: true)
            let childNode = ModelEntity(mesh: childNodeMesh, materials: [childNodeMaterial])
            childNode.position = [x, 0, z]
            
            // 连接线
            let lineMesh = createLineMesh(from: [0, 0, 0], to: [x, 0, z], thickness: 0.02)
            let lineMaterial = SimpleMaterial(color: .white.withAlphaComponent(0.7), isMetallic: false)
            let lineEntity = ModelEntity(mesh: lineMesh, materials: [lineMaterial])
            
            // 添加子节点文本
            let topics = ["创意思考", "项目规划", "系统设计", "市场分析", "研发路线"]
            let childTextMesh = MeshResource.generateText(topics[i % topics.count],
                                                      extrusionDepth: 0.01,
                                                      font: .systemFont(ofSize: 0.08),
                                                      containerFrame: .zero,
                                                      alignment: .center,
                                                      lineBreakMode: .byTruncatingTail)
            let childTextEntity = ModelEntity(mesh: childTextMesh, materials: [textMaterial])
            childTextEntity.position = [0, 0.25, 0]
            
            childNode.addChild(childTextEntity)
            centerNode.addChild(lineEntity)
            centerNode.addChild(childNode)
        }
        
        centerNode.addChild(textEntity)
        content.add(centerNode)
    }
    
    // 创建连接线的网格
    private func createLineMesh(from start: SIMD3<Float>, to end: SIMD3<Float>, thickness: Float) -> MeshResource {
        let length = simd_distance(start, end)
        let direction = simd_normalize(end - start)
        
        let cylinderMesh = MeshResource.generateCylinder(height: length, radius: thickness)
        
        // 计算旋转
        let defaultDirection = SIMD3<Float>(0, 1, 0) // 默认圆柱体方向是Y轴向上
        let rotationAxis = simd_cross(defaultDirection, direction)
        let rotationAngle = acos(simd_dot(defaultDirection, direction))
        
        var transform = Transform.identity
        if simd_length(rotationAxis) > 0.001 { // 避免旋转轴太小导致的数值问题
            transform.rotation = simd_quatf(angle: rotationAngle, axis: simd_normalize(rotationAxis))
        }
        
        // 移动到起点和终点的中间
        let midPoint = (start + end) * 0.5
        transform.translation = midPoint
        
        return cylinderMesh
    }
    
    // 添加新节点
    private func addNewNode() {
        isEditing = true
        newNodeText = "新节点"
    }
    
    // 连接节点
    private func connectNodes() {
        // 实现节点连接逻辑
    }
    
    // 删除选中的节点
    private func deleteSelectedNode() {
        // 实现删除节点逻辑
    }
    
    // 重新布局
    private func rearrangeLayout() {
        // 实现重新布局逻辑
    }
    
    // 更改节点颜色
    private func changeNodeColor(to color: Color) {
        // 实现更改颜色逻辑
    }
    
    // 保存节点文本
    private func saveNodeText() {
        // 保存节点文本逻辑
        isEditing = false
    }
}

// 控制按钮组件
struct ControlButton: View {
    var title: String
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .padding(.bottom, 4)
                
                Text(title)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .glassBackgroundEffect()
    }
}

#Preview(immersionStyle: .progressive) {
    ImmersiveView()
        .environment(AppModel())
}
