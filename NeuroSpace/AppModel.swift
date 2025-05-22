//
//  AppModel.swift
//  NeuroSpace
//
//  Created by TEC on 2025/5/22.
//

import SwiftUI

/// 维护应用范围的状态
@MainActor
@Observable
class AppModel {
    // 沉浸式空间ID
    let immersiveSpaceID = "ImmersiveSpace"
    
    // 沉浸式空间状态
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    // 用户协作空间
    var userSpaces: [CollaborationSpace] = sampleSpaces
    
    // 当前选中的空间
    var currentSpace: CollaborationSpace?
    
    // 创建新的协作空间
    func createSpace(name: String, description: String, templateType: String, isPublic: Bool) -> CollaborationSpace {
        let newSpace = CollaborationSpace(
            name: name,
            description: description,
            members: 1,
            lastModified: Date(),
            previewImage: templateType
        )
        userSpaces.append(newSpace)
        return newSpace
    }
    
    // 加入协作空间
    func joinSpace(space: CollaborationSpace) {
        if !userSpaces.contains(where: { $0.id == space.id }) {
            userSpaces.append(space)
        }
    }
    
    // 使用邀请码加入空间
    func joinWithCode(code: String) -> Bool {
        // 在实际应用中，这里会验证邀请码并连接到服务器
        // 模拟加入成功
        let newSpace = CollaborationSpace(
            name: "通过邀请加入的空间",
            description: "使用邀请码 \(code) 加入的协作空间",
            members: Int.random(in: 3...12),
            lastModified: Date(),
            previewImage: ["project_planning", "brainstorming", "system_architecture", "roadmap"].randomElement()!
        )
        userSpaces.append(newSpace)
        return true
    }
    
    // 删除协作空间
    func deleteSpace(id: String) {
        userSpaces.removeAll(where: { $0.id == id })
        if currentSpace?.id == id {
            currentSpace = nil
        }
    }
}
