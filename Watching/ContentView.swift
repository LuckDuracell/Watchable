//
//  ContentView.swift
//  Watching
//
//  Created by Luke Drushell on 7/29/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var shows = Show.loadFromFile()
    @State var movies = Movie.loadFromFile()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    //Background
                    VStack {
                        ForEach(movies, id: \.self, content: { movie in
                            HStack {
                                Image(systemName: movie.icon)
                                    .foregroundColor(.pink)
                                    .font(.system(size: 20, weight: .medium))
                                Text(movie.name)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                Spacer()
                                Text("In 3 Days")
                            } .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                            .padding(.horizontal)
                        })
                        ForEach(shows, id: \.self, content: { show in
                            
                        })
                    }
                }
                .navigationBarItems(
                    leading:
                        Text("Watchable")
                        .font(.system(size: 33))
                        .bold(),
                    trailing:
                        Button {
                            movies.append(Movie(name: "Star Wars 10", icon: "tv", releaseDate: Date(), active: false, info: "", platform: "Theater"))
                        } label: {
                            Image(systemName: "tv")
                                .font(Font.title.weight(.medium))
                                .padding(5)
                                .foregroundColor(.pink)
                        }
                )
            }
        } .padding(.top, 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
