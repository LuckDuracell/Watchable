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
                .background(.ultraThickMaterial)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.85)
                .onTapGesture(perform: {
                    withAnimation {
                        showTotalOverlay = false
                    }
                })
            VStack {
                HStack {
                    Text("Watchable:")
                        .bold()
                        .padding(.vertical, 2)
                    Spacer()
                }
                HStack {
                    Text("  Movies: \(activeMovies.count + inactiveMovies.count)")
                    Spacer()
                }
                HStack {
                    Text("  Shows: \(activeShows.count + inactiveShows.count)")
                    Spacer()
                }
                HStack {
                    Text("Upcoming:")
                        .bold()
                        .padding(.vertical, 2)
                    Spacer()
                }
                HStack {
                    Text("  Movies: \(upcomingMovies.count)")
                    Spacer()
                }
                HStack {
                    Text("  Shows: \(upcomingShows.count)")
                    Spacer()
                }
            }
                .padding()
                .frame(width: UIScreen.main.bounds.width*0.38, height: UIScreen.main.bounds.height*0.25, alignment: .center)
                .background(.regularMaterial)
                .cornerRadius(radius: 8, corners: [.bottomLeft, .bottomRight, .topRight])
                .scaleEffect(showTotalOverlay ? 1 : 0.5)
                .position(x: showTotalOverlay ? 120 : 40, y: showTotalOverlay ? 170 : 60)
        }

    }
}
