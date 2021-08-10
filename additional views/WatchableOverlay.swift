//
//  WatchableOverlay.swift
//  WatchableOverlay
//
//  Created by Luke Drushell on 8/7/21.
//

import SwiftUI

struct WatchableOverlay: View {
    
    let activeMovies: [Movie]
    let activeShows: [Show]
    let inactiveMovies: [Movie]
    let inactiveShows: [Show]
    let upcomingMovies: [Movie]
    let upcomingShows: [Show]
    @Binding var showTotalOverlay: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                .background(.black)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.35)
                .onTapGesture(perform: {
                    withAnimation {
                        showTotalOverlay = false
                    }
                })
            VStack {
                Text("Watchable")
                    .bold()
                    .padding(.vertical, 2)
                Text("Movies: \(activeMovies.count + inactiveMovies.count)")
                Text("Shows: \(activeShows.count + inactiveShows.count)")
                Text("Upcoming")
                    .bold()
                    .padding(.vertical, 2)
                Text("Movies: \(upcomingMovies.count)")
                Text("Shows: \(upcomingShows.count)")
            }
                .padding()
                .frame(width: UIScreen.main.bounds.width*0.38, height: UIScreen.main.bounds.height*0.25, alignment: .center)
                .background(.regularMaterial)
                .cornerRadius(radius: 14, corners: [.bottomLeft, .bottomRight, .topRight])
                .scaleEffect(showTotalOverlay ? 1 : 0.5)
                .position(x: showTotalOverlay ? 120 : 40, y: showTotalOverlay ? 170 : 60)
        }

    }
}
