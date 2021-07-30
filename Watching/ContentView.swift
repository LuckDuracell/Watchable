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
    
    @State var upcomingMovies: [Movie] = []
    @State var upcomingShows: [Show] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    //Background
                    VStack {
                        if upcomingMovies.count != 0 || upcomingShows.count != 0 {
                            HStack {
                                Text("Upcoming:")
                                    .foregroundColor(.gray)
                                    .padding(.top, 25)
                                Spacer()
                            } .padding(.horizontal)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                                ForEach(upcomingMovies, id: \.self, content: { movie in
                                    VStack {
                                        HStack {
                                            ZStack {
                                                Circle()
                                                    .frame(width: 28, height: 28, alignment: .center)
                                                    .foregroundColor(.pink)
                                                Image(systemName: movie.icon)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 12, height: 12)
                                            } .padding(-5)
                                            Text(movie.name)
                                                .fontWeight(.medium)
                                            Spacer()
                                        }
                                        Text("Release: 5 Days")
                                    }
                                    .padding()
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                                })
                                ForEach(upcomingShows, id: \.self, content: { show in
                                    Text(show.name)
                                        .bold()
                                })
                            }) .padding()
                        }
                        if movies.count != 0 {
                            HStack {
                                Text("Watching:")
                                    .foregroundColor(.gray)
                                    .padding(.top, 25)
                                Spacer()
                            } .padding(.horizontal)
                            ForEach(movies, id: \.self, content: { movie in
                                HStack {
                                    Image(systemName: movie.icon)
                                        .foregroundColor(.pink)
                                        .font(.system(size: 20, weight: .medium))
                                    Text(movie.name)
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                    Spacer()
                                    NavigationLink(destination: {
//                                        var name: String
//                                        var icon: String
//                                        var releaseDate: Date
//                                        var active: Bool
//                                        var info: String
//                                        var platform: String
                                        Text(movie.name)
                                            .font(.title)
                                    }, label: {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    })
                                } .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                                .padding(.horizontal)
                            })
                        }
                        if shows.count != 0 {
                            HStack {
                                Text("Watching:")
                                    .foregroundColor(.gray)
                                    .padding(.top, 25)
                                Spacer()
                            } .padding(.horizontal)
                            ForEach(shows, id: \.self, content: { show in
                                
                            })
                        }
                    }
                }
                .navigationTitle("Watchable")
                .navigationBarItems(
                    leading:
                        Button {
                            let toDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
                            movies.append(Movie(name: "Iron Man", icon: "tv", releaseDate: Date(), active: false, info: "", platform: "Theater"))
                            upcomingMovies.append(Movie(name: "Iron Man", icon: "tv", releaseDate: toDate, active: false, info: "", platform: "Theater"))
                        } label: {
                            Image(systemName: "tv")
                                .padding(5)
                                .foregroundColor(.pink)
                        },
                    trailing:
                        Button {
                            movies.append(Movie(name: "Iron Man", icon: "tv", releaseDate: Date(), active: false, info: "", platform: "Theater"))
                            upcomingMovies.append(Movie(name: "Iron Man", icon: "tv", releaseDate: Date(), active: false, info: "", platform: "Theater"))
                        } label: {
                            Image(systemName: "tv")
                                .padding(5)
                                .foregroundColor(.pink)
                        }
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
