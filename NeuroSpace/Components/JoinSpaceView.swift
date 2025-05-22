//
//  JoinSpaceView.swift
//  NeuroSpace
//
//  Created by TEC on 2025/5/22.
//

import SwiftUI

struct JoinSpaceView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var inviteCode: String = ""
    @State private var isSearching: Bool = false
    @State private var searchQuery: String = ""
    @State private var selectedPublicSpace: PublicSpace? = nil
    
    // 选项卡选择
    enum JoinTab: String, CaseIterable {
        case inviteCode = "邀请码"
        case browse = "浏览公开空间"
    }
    
    @State private var selectedTab: JoinTab = .inviteCode
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("加入思维空间")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // 选项卡
            Picker("加入方式", selection: $selectedTab) {
                ForEach(JoinTab.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // 内容区域
            ZStack {
                // 邀请码视图
                if selectedTab == .inviteCode {
                    VStack(spacing: 30) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 80))
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 20)
                        
                        TextField("输入邀请码", text: $inviteCode)
                            .textFieldStyle(.plain)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: 300)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        
                        Text("或扫描二维码加入")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Button("加入空间") {
                            joinWithCode()
                        }
                        .disabled(inviteCode.isEmpty)
                        .buttonStyle(.borderedProminent)
                        .frame(width: 200)
                    }
                    .padding()
                }
                
                // 浏览公开空间视图
                if selectedTab == .browse {
                    VStack {
                        // 搜索栏
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            
                            TextField("搜索公开空间", text: $searchQuery)
                                .textFieldStyle(.plain)
                            
                            if !searchQuery.isEmpty {
                                Button {
                                    searchQuery = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .glassBackgroundEffect()
                        .padding(.horizontal)
                        
                        // 公开空间列表
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredPublicSpaces) { space in
                                    PublicSpaceRow(space: space, isSelected: selectedPublicSpace?.id == space.id)
                                        .onTapGesture {
                                            selectedPublicSpace = space
                                        }
                                }
                            }
                            .padding()
                        }
                        
                        // 加入按钮
                        Button("加入所选空间") {
                            joinPublicSpace()
                        }
                        .disabled(selectedPublicSpace == nil)
                        .buttonStyle(.borderedProminent)
                        .frame(width: 200)
                        .padding(.bottom)
                    }
                }
            }
            
            // 底部按钮
            Button("取消") {
                dismiss()
            }
            .buttonStyle(.bordered)
            .tint(.secondary)
            .padding(.bottom, 20)
        }
        .padding()
        .frame(width: 600, height: 700)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .glassBackgroundEffect()
    }
    
    // 过滤后的公开空间列表
    private var filteredPublicSpaces: [PublicSpace] {
        if searchQuery.isEmpty {
            return samplePublicSpaces
        } else {
            return samplePublicSpaces.filter { space in
                space.name.lowercased().contains(searchQuery.lowercased()) ||
                space.creator.lowercased().contains(searchQuery.lowercased()) ||
                space.tags.contains(where: { $0.lowercased().contains(searchQuery.lowercased()) })
            }
        }
    }
    
    // 使用邀请码加入
    private func joinWithCode() {
        // 实现加入空间的逻辑
        print("使用邀请码加入: \(inviteCode)")
        dismiss()
    }
    
    // 加入公开空间
    private func joinPublicSpace() {
        if let space = selectedPublicSpace {
            // 实现加入公开空间的逻辑
            print("加入公开空间: \(space.name)")
            dismiss()
        }
    }
}

// 公开空间行组件
struct PublicSpaceRow: View {
    var space: PublicSpace
    var isSelected: Bool
    
    var body: some View {
        HStack {
            // 空间图标
            ZStack {
                Circle()
                    .fill(space.color)
                    .frame(width: 50, height: 50)
                
                Image(systemName: space.iconName)
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
            }
            .padding(.trailing, 8)
            
            // 空间信息
            VStack(alignment: .leading, spacing: 4) {
                Text(space.name)
                    .font(.headline)
                
                Text("创建者: \(space.creator) · \(space.members)人")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                // 标签
                HStack {
                    ForEach(space.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
            
            // 选中状态
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.accentColor)
                    .font(.title2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
        .glassBackgroundEffect()
    }
}

// 公开空间数据模型
struct PublicSpace: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var creator: String
    var members: Int
    var tags: [String]
    var iconName: String
    var color: Color
}

// 示例公开空间数据
let samplePublicSpaces = [
    PublicSpace(
        name: "AI产品规划",
        creator: "张三",
        members: 12,
        tags: ["AI", "产品"],
        iconName: "brain.head.profile",
        color: .purple
    ),
    PublicSpace(
        name: "2025市场策略",
        creator: "李四",
        members: 8,
        tags: ["市场", "策略"],
        iconName: "chart.line.uptrend.xyaxis",
        color: .blue
    ),
    PublicSpace(
        name: "用户体验设计",
        creator: "王五",
        members: 15,
        tags: ["设计", "UX"],
        iconName: "person.2.fill",
        color: .green
    ),
    PublicSpace(
        name: "软件架构研讨",
        creator: "赵六",
        members: 9,
        tags: ["技术", "架构"],
        iconName: "rectangle.3.group",
        color: .orange
    ),
    PublicSpace(
        name: "创意头脑风暴",
        creator: "钱七",
        members: 21,
        tags: ["创意", "协作"],
        iconName: "lightbulb.fill",
        color: .yellow
    )
]

#Preview {
    JoinSpaceView()
} 
