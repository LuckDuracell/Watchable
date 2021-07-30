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
    
    @State var activeMovies: [Movie] = []
    @State var activeShows: [Show] = []
    
    @State var inactiveMovies: [Movie] = []
    @State var inactiveShows: [Show] = []
    
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
                                                    .foregroundColor(.white)
                                            } .padding(-5)
                                            Text(movie.name)
                                                .fontWeight(.medium)
                                                .frame(height: 30)
                                                .truncationMode(.tail)
                                            Spacer()
                                        }
                                        Text("Release: 5 Days")
                                    }
                                    .padding()
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                                })
                                ForEach(upcomingShows, id: \.self, content: { show in
                                    VStack {
                                        HStack {
                                            ZStack {
                                                Circle()
                                                    .frame(width: 28, height: 28, alignment: .center)
                                                    .foregroundColor(.pink)
                                                Image(systemName: show.icon)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 12, height: 12)
                                                    .foregroundColor(.white)
                                            } .padding(-5)
                                            Text(show.name)
                                                .fontWeight(.medium)
                                                .frame(height: 30)
                                                .truncationMode(.tail)
                                            Spacer()
                                        }
                                        Text("Release: 5 Days")
                                    }
                                    .padding()
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                                })
                            }) .padding()
                        }
                        if activeMovies.count != 0 || activeShows.count != 0 {
                            HStack {
                                Text("Watching:")
                                    .foregroundColor(.gray)
                                    .padding(.top, 25)
                                Spacer()
                            } .padding(.horizontal)
                        }
                        ForEach(activeMovies, id: \.self, content: { movie in
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
                        ForEach(activeShows, id: \.self, content: { show in
                            HStack {
                                Image(systemName: show.icon)
                                    .foregroundColor(.pink)
                                    .font(.system(size: 20, weight: .medium))
                                Text(show.name)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                Spacer()
                                NavigationLink(destination: {
    //                                        var name: String
    //                                        var icon: String
    //                                        var releaseDate: Date
    //                                        var active: Bool
    //                                        var info: String
    //                                        var platform: String
                                    Text(show.name)
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
                        if inactiveMovies.count != 0 || inactiveShows.count != 0 {
                            HStack {
                                Text("Need to Watch:")
                                    .foregroundColor(.gray)
                                    .padding(.top, 25)
                                Spacer()
                            } .padding(.horizontal)
                        }
                        ForEach(inactiveMovies, id: \.self, content: { movie in
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
                        ForEach(inactiveShows, id: \.self, content: { show in
                            HStack {
                                Image(systemName: show.icon)
                                    .foregroundColor(.pink)
                                    .font(.system(size: 20, weight: .medium))
                                Text(show.name)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                Spacer()
                                NavigationLink(destination: {
    //                                        var name: String
    //                                        var icon: String
    //                                        var releaseDate: Date
    //                                        var active: Bool
    //                                        var info: String
    //                                        var platform: String
                                    Text(show.name)
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
                }
                .navigationTitle("Watching")
                .navigationBarItems(
                    leading:
                        Button {
                            let toDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
                            activeMovies.append(Movie(name: "Iron Man", icon: "tv", releaseDate: Date(), active: false, info: "", platform: "Theater"))
                            upcomingMovies.append(Movie(name: "Suicide Squad", icon: "tv", releaseDate: toDate, active: false, info: "", platform: "Theater"))
                        } label: {
                            Image(systemName: "tv")
                                .padding(5)
                                .foregroundColor(.pink)
                        },
                    trailing:
                        Button {
                            inactiveMovies.append(Movie(name: "Fight Club", icon: "tv", releaseDate: Date(), active: false, info: "", platform: "Theater"))
                            upcomingShows.append(Show(name: "The Flash S8", icon: "tv", releaseDate: Date(), active: false, info: "", platform: "YT TV", reoccuring: true))
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
