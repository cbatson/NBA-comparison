//
//  RemoteEntity.swift
//  NBA Comparison
//
//  Created by chuck on 7/29/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

// Base representation of a remotely-defined (i.e. external database) object
class RemoteEntity : Equatable, Hashable, Identifiable {
    let id = UUID()
    let remoteId: Int

    init(remoteId: Int) {
        self.remoteId = remoteId
    }
    
    static func == (lhs: RemoteEntity, rhs: RemoteEntity) -> Bool {
        return lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
