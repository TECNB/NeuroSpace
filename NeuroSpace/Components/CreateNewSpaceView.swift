//
//  CreateNewSpaceView.swift
//  NeuroSpace
//
//  Created by TEC on 2025/5/22.
//

import SwiftUI

struct CreateNewSpaceView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var spaceName: String = ""
    @State private var spaceDescription: String = ""
    @State private var selectedTemplate: String = "empty"
    @State private var isPublic: Bool = false
    
    var body: some View {
        VStack {
            // 标题
            Text("创建新思维空间")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // 表单
            Form {
                Section {
                    TextField("空间名称", text: $spaceName)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    
                    TextField("空间描述", text: $spaceDescription)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .frame(height: 80)
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("模板选择").foregroundStyle(.secondary)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(templateOptions, id: \.id) { template in
                                TemplateOption(
                                    template: template, 
                                    isSelected: selectedTemplate == template.id
                                )
                                .onTapGesture {
                                    selectedTemplate = template.id
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section {
                    Toggle("公开空间", isOn: $isPublic)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            
            // 按钮
            HStack(spacing: 20) {
                Button("取消") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                .tint(.secondary)
                
                Button {
                    // 创建空间逻辑
                    createSpace()
                    dismiss()
                } label: {
                    Text("创建空间")
                        .frame(minWidth: 120)
                }
                .buttonStyle(.borderedProminent)
                .disabled(spaceName.isEmpty)
            }
            .padding(.bottom, 30)
        }
        .padding()
        .frame(width: 600, height: 700)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .glassBackgroundEffect()
    }
    
    // 创建空间
    private func createSpace() {
        // 这里实现创建空间的逻辑
        // 在实际应用中会将数据保存到模型中
        print("创建空间: \(spaceName)")
    }
}

// 模板选项组件
struct TemplateOption: View {
    var template: SpaceTemplate
    var isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                // 预览
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(white: 1, opacity: 0.2) : Color(white: 0.9, opacity: 0.1))
                    .frame(width: 120, height: 120)
                    .overlay {
                        // 模板图标
                        Image(systemName: template.iconName)
                            .font(.system(size: 40))
                            .foregroundStyle(template.color)
                    }
                    .glassBackgroundEffect()
                    .shadow(color: isSelected ? template.color.opacity(0.3) : Color.clear, radius: 5)
            }
            
            Text(template.name)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundStyle(isSelected ? template.color : .secondary)
        }
    }
}

// 模板数据模型
struct SpaceTemplate: Identifiable {
    var id: String
    var name: String
    var iconName: String
    var color: Color
}

// 模板选项数据
let templateOptions = [
    SpaceTemplate(id: "empty", name: "空白", iconName: "square.dashed", color: .gray),
    SpaceTemplate(id: "mindmap", name: "思维导图", iconName: "brain", color: .blue),
    SpaceTemplate(id: "project", name: "项目规划", iconName: "calendar", color: .green),
    SpaceTemplate(id: "brainstorm", name: "头脑风暴", iconName: "lightbulb.fill", color: .yellow),
    SpaceTemplate(id: "architecture", name: "系统架构", iconName: "rectangle.3.group", color: .purple)
]

// 视觉效果视图
struct VisualEffectView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#Preview {
    CreateNewSpaceView()
} 