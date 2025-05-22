//
//  ContentView.swift
//  NeuroSpace
//
//  Created by TEC on 2025/5/22.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(AppModel.self) private var appModel
    @State private var selectedSpaceID: String? = nil
    @State private var showCreateNewSpace: Bool = false
    @State private var showJoinSpace: Bool = false
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        ZStack {
            // 背景层 - 使用整体毛玻璃效果
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
                .glassBackgroundEffect()
            
            // 内容层
            VStack {
                // 顶部标题
                Text("聚思星球")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                Text("NeuroSpace")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)
                
                // 主内容区域 - 协作空间卡片
                ScrollView {
                    VStack(spacing: 30) {
                        // 已创建的空间卡片
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 280, maximum: 350), spacing: 30)], spacing: 30) {
                            ForEach(sampleSpaces) { space in
                                SpaceCard(space: space, isSelected: selectedSpaceID == space.id)
                                    .onTapGesture {
                                        selectedSpaceID = space.id
                                    }
                                    // 添加额外的padding，确保卡片有足够的空间
                                    .padding(4)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
                .scrollIndicators(.hidden)
                
                // 底部操作区域
                HStack(spacing: 20) {
                    // 创建新空间按钮
                    Button {
                        showCreateNewSpace = true
                    } label: {
                        Label("创建新空间", systemImage: "plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    
                    // 加入空间按钮
                    Button {
                        showJoinSpace = true
                    } label: {
                        Label("加入空间", systemImage: "person.badge.plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding()
            
            // 使用覆盖层代替sheet - 创建新空间
            if showCreateNewSpace {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        // 允许通过点击背景关闭视图
                        showCreateNewSpace = false
                    }
                
                CreateNewSpaceView(onDismiss: {
                    showCreateNewSpace = false
                })
                    
                    .zIndex(1)
            }
            
            // 使用覆盖层代替sheet - 加入空间
            if showJoinSpace {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        showJoinSpace = false
                    }
                
                JoinSpaceView(onDismiss: {
                    showJoinSpace = false
                })
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.spring, value: showCreateNewSpace)
        .animation(.spring, value: showJoinSpace)
    }
}

// 模拟的协作空间数据
struct CollaborationSpace: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var description: String
    var members: Int
    var lastModified: Date
    var previewImage: String
}

let sampleSpaces = [
    CollaborationSpace(name: "移动创新大赛方案", description: "参赛项目总体规划与目标设定", members: 5, lastModified: Date(), previewImage: "project_planning"),
    CollaborationSpace(name: "NeuroSpace创意构思", description: "3D思维导图创新功能与用户体验设计", members: 8, lastModified: Date().addingTimeInterval(-86400*2), previewImage: "brainstorming"),
    CollaborationSpace(name: "VisionOS架构方案", description: "基于苹果空间计算平台的技术架构与组件关系", members: 4, lastModified: Date().addingTimeInterval(-86400*4), previewImage: "system_architecture"),
    CollaborationSpace(name: "比赛路线与演示", description: "评审演示准备与答辩重点规划", members: 6, lastModified: Date().addingTimeInterval(-86400*7), previewImage: "roadmap")
]

#Preview {
    ContentView()
        .environment(AppModel())
}
