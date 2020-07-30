//
//  PlayerHeadshotMap.swift
//  NBA Comparison
//
//  Created by chuck on 7/28/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

// TODO: This depends on the player IDs from the balldontlie.io API
struct PlayerHeadshotMap {
    static let balldontlieIdToHeadshotURL = [
        1: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/203518.png",
        14: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/dleague/1628387.png",           // Ike Anigbogu
    ]
    
    static let defaultHeadshotURL = "https://lirp-cdn.multiscreensite.com/a0839893/dms3rep/multi/opt/CEBL_playerHeadshot_placeholder-640w.png"
    
    static let placeholderImage = Image(systemName: "person.circle.fill")
    
    static var cache : ImageCache = TemporaryImageCache()
    
    static var placeholderView = AnyView(AsyncImage(
        url: URL(string: defaultHeadshotURL)!,
        cache: cache,
        placeholder: placeholderImage,
        configuration: {
            configureImage(image: $0)
        }
    ))
    
    static func getHeadshotFromId(id: Int) -> AnyView {
        guard let url = Self.balldontlieIdToHeadshotURL[id] else {
            return placeholderView
        }
        return AnyView(AsyncImage(
            url: URL(string: url)!,
            cache: self.cache,
            placeholder: placeholderView,
            configuration: {
                configureImage(image: $0)
            }
        ))
    }
    
    static private func configureImage(image: Image) -> some View {
        return image
            .resizable()
            .aspectRatio(contentMode: .fit)
            //.border(Color.red)
    }
}
