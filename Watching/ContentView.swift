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
                                            editPage(showPage: $showPage, movies: $movies, shows: $shows, theTitle: upcomingMovies[index].name, theSelectedDate: upcomingMovies[index].releaseDate, theShowDate: true, theNotes: upcomingMovies[index].info, type: "Movie", theIconTheme: getTypeForImage(image: upcomingMovies[index].icon), thePlatform: upcomingMovies[index].platform, theActive: upcomingMovies[index].active, theReoccuring: false)
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
                                            editPage(showPage: $showPage, movies: $movies, shows: $shows, theTitle: upcomingShows[index].name, theSelectedDate: upcomingShows[index].releaseDate, theShowDate: true, theNotes: upcomingShows[index].info, type: "Show", theIconTheme: getTypeForImage(image: upcomingShows[index].icon), thePlatform: upcomingShows[index].platform, theActive: upcomingShows[index].active, theReoccuring: false)
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


func dayDifference(date1: Date, date2: Date) -> Int {
    let diffs = Calendar.current.dateComponents([.day], from: date1, to: date2)
    return diffs.day! + 1
}

struct editPage: View {
    
    @Binding var showPage: Bool
    @Binding var movies: [Movie]
    @Binding var shows: [Show]
    @State private var selectedDate: Date = Date()
    @State private var showDate: Bool = false
    @State var title = ""
    @State private var notes = ""
    @State var iconTheme = "Default"
    @State var themeTypes = ["Default", "Action", "Medieval", "Sci-Fi", "Drama", "Comedy", "Romance", "Documentary", "Game Show"]
    @State var platformTypes = ["Theater", "Netflix", "Hulu", "HBO Max", "Prime Video", "Disney+", "Youtube TV", "Apple TV", "Peacock", "Other"]
    @State var platformTypesShow = ["Netflix", "Hulu", "HBO Max", "Prime Video", "Disney+", "Youtube TV", "Apple TV", "Peacock", "Other"]
    @State var platform = "Theater"
    @State var active = false
    @State var reoccuring = false
    
    let theTitle: String
    let theSelectedDate: Date
    let theShowDate: Bool
    let theNotes: String
    let type: String
    let theIconTheme: String
    let thePlatform: String
    let theActive: Bool
    let theReoccuring: Bool
    
    var body: some View {
            Form {
                if selectedDate > Date() {
                    Text("\(type) releases in \(dayDifference(date1: Date(), date2: selectedDate)) Days")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.pink)
                } else {
                    Text(type)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.pink)
                }
                
                Section {
                    TextField("Title", text: $title)
                    
                    TextField("Notes", text: $notes)
                }
                
                Section {
                    Picker("Theme", selection: $iconTheme, content: {
                        ForEach(themeTypes, id: \.self, content: {
                            pickerLabel(name: $0, image: getImageForType(type: $0))
                        })
                    })
                    Picker("Platform", selection: $platform, content: {
                        ForEach(type == "Movie" ? platformTypes : platformTypesShow, id: \.self, content: {
                            Text($0)
                        })
                    })
                }
                
                Section {
                    if active != true {
                        Toggle("Upcoming", isOn: $showDate)
                            
                        if showDate {
                            DatePicker("Release Date", selection: $selectedDate, in: Date()...,displayedComponents: .date)
                                .datePickerStyle(.automatic)
                                .animation(.default, value: 1)
                        }
                    }
                }
                
                Section {
                    Toggle("Currently Watching", isOn: $active)
                    if type == "Show" {
                        Toggle("Reoccuring", isOn: $reoccuring)
                    }
                }

            }
            .padding(.top, -30)
            .edgesIgnoringSafeArea(.all)
            .background(Color(.systemGroupedBackground))
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    title = theTitle
                    notes = theNotes
                })
                selectedDate = theSelectedDate
                showDate = theShowDate
                iconTheme = theIconTheme
                platform = thePlatform
                active = theActive
                reoccuring = theReoccuring
            })
            .overlay(
                Button {
//                    if type == "Movie" {
//                        if title != "" {
//                            if active {
//                                selectedDate = Date()
//                            }
//                            movies.insert(Movie(name: title, icon: getImageForType(type: iconTheme), releaseDate: selectedDate, active: active, info: notes, platform: platform), at: 0)
//                            Movie.saveToFile(movies)
//                        }
//                    } else {
//                        if title != "" {
//                            if active {
//                                selectedDate = Date()
//                            }
//                            shows.insert(Show(name: title, icon: getImageForType(type: iconTheme), releaseDate: selectedDate, active: active, info: notes, platform: platform, reoccuring: reoccuring), at: 0)
//                            Show.saveToFile(shows)
//                        }
//                    }
                    
                    showPage.toggle()
                } label: {
                    Text("Delete")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(Color.red)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.4), radius: 15)
                        .padding()
                        .padding(.bottom, 30)
                }, alignment: .bottom)
        
    }
}
