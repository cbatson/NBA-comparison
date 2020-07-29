//
//  PlayerHeadshotMap.swift
//  NBA Comparison
//
//  Created by chuck on 7/28/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct PlayerHeadshotMap {
    static let balldontlieIdToHeadshotURL = [
        1: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/203518.png",
        14: "https://ak-static.cms.nba.com/wp-content/uploads/headshots/dleague/1628387.png",           // Ike Anigbogu
    ]
    
    static let defaultHeadshotURL = "https://lirp-cdn.multiscreensite.com/a0839893/dms3rep/multi/opt/CEBL_playerHeadshot_placeholder-640w.png"
    
    static let placeholderImage = Image(systemName: "person.circle.fill")
    
    static var cache : ImageCache = TemporaryImageCache()
    
    static var placeholderLoader = ImageLoader(url: URL(string: defaultHeadshotURL)!, cache: cache).startLoad()
    
    static func getHeadshotFromId(id: Int) -> AnyView {
        guard let url = Self.balldontlieIdToHeadshotURL[id] else {
            return AnyView(getPlaceholderHeadshotView())
        }
        return AnyView(AsyncImage(
            url: URL(string: url)!,
            cache: self.cache,
            placeholder: getPlaceholderHeadshotView(),
            configuration: {
                configureImage(image: $0)
            }
        ))
    }
    
    static private func getPlaceholderHeadshotView() -> some View {
        if placeholderLoader.image != nil {
            return configureImage(image: Image(uiImage: placeholderLoader.image!))
        }
        return configureImage(image: placeholderImage)
    }
    
    static private func configureImage(image: Image) -> some View {
        return image
            .resizable()
            .aspectRatio(contentMode: .fit)
            //.border(Color.red)
    }
}
