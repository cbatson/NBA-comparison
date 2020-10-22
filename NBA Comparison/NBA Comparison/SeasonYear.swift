//
//  SeasonYear.swift
//  NBA Comparison
//
//  Created by chuck on 8/4/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI
import Combine

class SeasonYear : ObservableObject {
    @Published var year = Util.getCurrentSeasonYear()

    private var sink: AnyCancellable?
    
    init(seasonAverages: SeasonAverages) {
        sink = seasonAverages.objectWillChange.sink {
            if seasonAverages.seasonYears.count > 0 {
                let year = seasonAverages.seasonYears[0]
                if self.year != year {
                    self.year = year
                    // Only need to set the year once.
                    // Then we can stop paying attention.
                    self.sink = nil
                }
            }
        }
    }
    
    class func getDisplayString(year: Int) -> String {
        return String(year) + "-" + String(year + 1)
    }
}
