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
    
    @State var showNewSheet = false
    
    @State var showPage = true
    
    fileprivate func loadItems() {
        movies = Movie.loadFromFile()
        shows = Show.loadFromFile()
        inactiveMovies.removeAll()
        inactiveShows.removeAll()
        activeMovies.removeAll()
        activeShows.removeAll()
        upcomingMovies.removeAll()
        upcomingShows.removeAll()
        for index in movies.indices {
            if movies[index].active {
                activeMovies.append(movies[index])
            } else if checkUpcoming(date: movies[index].releaseDate) {
                upcomingMovies.append(movies[index])
            } else {
                inactiveMovies.append(movies[index])
            }
        }
        for index in shows.indices {
            if shows[index].active {
                activeShows.append(shows[index])
            } else if checkUpcoming(date: shows[index].releaseDate) {
                upcomingShows.append(shows[index])
            } else {
                inactiveShows.append(shows[index])
            }
        }
    }
    
    var body: some View {
        if showPage {
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
                                    ForEach(upcomingMovies.indices, id: \.self, content: { index in
                                        NavigationLink(destination: {
                                            Spacer()
                                            Text("Releasing in \(dayDifference(date1: Date(), date2: upcomingMovies[index].releaseDate)) Days")
                                            Text(upcomingMovies[index].name)
                                                .font(.title)
                                                .bold()
                                            Spacer()
                                            Button {
                                                movies.remove(at: index)
                                                Movie.saveToFile(movies)
                                                showPage = false
                                            } label: {
                                                Text("Delete")
                                                    .foregroundColor(.white)
                                                    .frame(width: 300, height: 50, alignment: .center)
                                                    .background(.red)
                                                    .cornerRadius(15)
                                                    .padding()
                                            }
                                            Spacer()
                                        }, label: {
                                            VStack {
                                                HStack {
                                                    ZStack {
                                                        Circle()
                                                            .frame(width: 28, height: 28, alignment: .center)
                                                            .foregroundColor(.pink)
                                                        Image(systemName: upcomingMovies[index].icon)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 12, height: 12)
                                                            .foregroundColor(.white)
                                                    } .padding(-5)
                                                    Text("  Days: \(dayDifference(date1: Date(), date2: upcomingMovies[index].releaseDate))")
                                                        .frame(height: 20)
                                                        .truncationMode(.tail)
                                                    Spacer()
                                                }
                                                
                                                Text("\(upcomingMovies[index].name)")
                                                    .font(.system(size: 16, weight: .medium))
                                                    .frame(height: 20)
                                                    .truncationMode(.tail)
                                            }
                                            .foregroundColor(.primary)
                                            .padding()
                                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                                        })
                                    })
                                    ForEach(upcomingShows.indices, id: \.self, content: { index in
                                        NavigationLink(destination: {
                                            Spacer()
                                            Text("Releasing in \(dayDifference(date1: Date(), date2: upcomingShows[index].releaseDate)) Days")
                                            Text(upcomingShows[index].name)
                                                .font(.title)
                                                .bold()
                                            Spacer()
                                            Button {
                                                movies.remove(at: index)
                                                Movie.saveToFile(movies)
                                                showPage = false
                                            } label: {
                                                Text("Delete")
                                                    .foregroundColor(.white)
                                                    .frame(width: 300, height: 50, alignment: .center)
                                                    .background(.red)
                                                    .cornerRadius(15)
                                                    .padding()
                                            }
                                            Spacer()
                                        }, label: {
                                            VStack {
                                                HStack {
                                                    ZStack {
                                                        Circle()
                                                            .frame(width: 28, height: 28, alignment: .center)
                                                            .foregroundColor(.pink)
                                                        Image(systemName: upcomingShows[index].icon)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 12, height: 12)
                                                            .foregroundColor(.white)
                                                    } .padding(-5)
                                                    Text("  Days: \(dayDifference(date1: Date(), date2: upcomingShows[index].releaseDate))")
                                                        .frame(height: 20)
                                                        .truncationMode(.tail)
                                                    Spacer()
                                                }
                                                
                                                Text("\(upcomingShows[index].name)")
                                                    .font(.system(size: 16, weight: .medium))
                                                    .frame(height: 20)
                                                    .truncationMode(.tail)
                                            }
                                            .foregroundColor(.primary)
                                            .padding()
                                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                                        })
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
                            ForEach(activeMovies.indices, id: \.self, content: { index in
                                NavigationLink(destination: {
    //                                        var name: String
    //                                        var icon: String
    //                                        var releaseDate: Date
    //                                        var active: Bool
    //                                        var info: String
    //                                        var platform: String
                                    Text(activeMovies[index].name)
                                        .font(.title)
                                    Button {
                                        activeMovies.remove(at: index)
                                        let output = upcomingMovies + activeMovies + inactiveMovies
                                        Movie.saveToFile(output)
                                        showPage = false
                                    } label: {
                                        Text("Delete")
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 50, alignment: .center)
                                            .background(.red)
                                            .cornerRadius(15)
                                            .padding()
                                    }
                                }, label: {
                                    HStack {
                                        Image(systemName: activeMovies[index].icon)
                                            .foregroundColor(.pink)
                                            .font(.system(size: 20, weight: .medium))
                                        Text(activeMovies[index].name)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                                })
                            })
                            ForEach(activeShows.indices, id: \.self, content: { index in
                                NavigationLink(destination: {
    //                                        var name: String
    //                                        var icon: String
    //                                        var releaseDate: Date
    //                                        var active: Bool
    //                                        var info: String
    //                                        var platform: String
                                    Text(activeShows[index].name)
                                        .font(.title)
                                    Button {
                                        activeShows.remove(at: index)
                                        let output = upcomingShows + activeShows + inactiveShows
                                        Show.saveToFile(output)
                                        showPage = false
                                    } label: {
                                        Text("Delete")
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 50, alignment: .center)
                                            .background(.red)
                                            .cornerRadius(15)
                                            .padding()
                                    }
                                }, label: {
                                    HStack {
                                        Image(systemName: activeShows[index].icon)
                                            .foregroundColor(.pink)
                                            .font(.system(size: 20, weight: .medium))
                                        Text(activeShows[index].name)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                                })
                            })
                            if inactiveMovies.count != 0 || inactiveShows.count != 0 {
                                HStack {
                                    Text("Need to Watch:")
                                        .foregroundColor(.gray)
                                        .padding(.top, 25)
                                    Spacer()
                                } .padding(.horizontal)
                            }
                            ForEach(inactiveMovies.indices, id: \.self, content: { index in
                                NavigationLink(destination: {
    //                                        var name: String
    //                                        var icon: String
    //                                        var releaseDate: Date
    //                                        var active: Bool
    //                                        var info: String
    //                                        var platform: String
                                    Text(inactiveMovies[index].name)
                                        .font(.title)
                                    Button {
                                        inactiveMovies.remove(at: index)
                                        let output = upcomingMovies + activeMovies + inactiveMovies
                                        Movie.saveToFile(output)
                                        showPage = false
                                    } label: {
                                        Text("Delete")
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 50, alignment: .center)
                                            .background(.red)
                                            .cornerRadius(15)
                                            .padding()
                                    }
                                }, label: {
                                    HStack {
                                        Image(systemName: inactiveMovies[index].icon)
                                            .foregroundColor(.pink)
                                            .font(.system(size: 20, weight: .medium))
                                        Text(inactiveMovies[index].name)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                                })
                            })
                            ForEach(inactiveShows.indices, id: \.self, content: { index in
                                NavigationLink(destination: {
    //                                        var name: String
    //                                        var icon: String
    //                                        var releaseDate: Date
    //                                        var active: Bool
    //                                        var info: String
    //                                        var platform: String
                                    Text(inactiveShows[index].name)
                                        .font(.title)
                                    Button {
                                        inactiveShows.remove(at: index)
                                        let output = upcomingShows + activeShows + inactiveShows
                                        Show.saveToFile(output)
                                        showPage = false
                                    } label: {
                                        Text("Delete")
                                            .foregroundColor(.white)
                                            .frame(width: 300, height: 50, alignment: .center)
                                            .background(.red)
                                            .cornerRadius(15)
                                            .padding()
                                    }
                                }, label: {
                                    HStack {
                                        Image(systemName: inactiveShows[index].icon)
                                            .foregroundColor(.pink)
                                            .font(.system(size: 20, weight: .medium))
                                        Text(inactiveShows[index].name)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(15)
                                    .padding(.horizontal)
                                })
                            })
                        }
                    }
                    .navigationTitle("Watching")
                    .navigationBarItems(trailing:
                        Button {
                            showNewSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    )
                }
                .onAppear(perform: {
                    loadItems()
                })
                .sheet(isPresented: $showNewSheet, onDismiss: {
                    loadItems()},content: {
                    NewSheet(showSheet: $showNewSheet, movies: $movies, shows: $shows)
                        .interactiveDismissDisabled(true)
                        .accentColor(.pink)
                        .toggleStyle(SwitchToggleStyle(tint: Color.pink))
                })
            }
            .accentColor(.pink)
        } else {
            ZStack {
                
            } .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    showPage = true
                })
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func checkUpcoming(date: Date) -> Bool {
    if date > Date() {
        return true
    } else {
        return false
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}


func dayDifference(date1: Date, date2: Date) -> Int {
    let diffs = Calendar.current.dateComponents([.day], from: date1, to: date2)
    return diffs.day! + 1
}

