//
//  ContentView.swift
//  ContentView
//
//  Created by Luke Drushell on 7/29/21.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @State var shows = Show.loadFromFile()
    @State var showsV2 = ShowV2.loadFromFile()
    @State var movies = Movie.loadFromFile()

    @State var upcomingMovies: [Movie] = []
    @State var upcomingMoviesIndexs: [Int] = []
    @State var upcomingShows: [Show] = []
    @State var upcomingShowsIndexs: [Int] = []
    
    @State var activeMovies: [Movie] = []
    @State var activeMoviesIndexs: [Int] = []
    @State var activeShows: [Show] = []
    @State var activeShowsIndexs: [Int] = []
    
    @State var inactiveMovies: [Movie] = []
    @State var inactiveMoviesIndexs: [Int] = []
    @State var inactiveShows: [Show] = []
    @State var inactiveShowsIndexs: [Int] = []
    
    @State var showNewSheet = false
    @State var showTotalOverlay = false
    
    @State var selectedItemTheme = "Default"
    @State var selectedItemPlatform = "Youtube TV"
    
    @State var ytEasterEgg = false
    
    @State private var total = 0
    
    fileprivate func loadItems() {
        print("loading")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        movies = Movie.loadFromFile()
        shows = Show.loadFromFile()
        showsV2 = ShowV2.loadFromFile()
        inactiveMovies.removeAll()
        inactiveShows.removeAll()
        inactiveMoviesIndexs.removeAll()
        inactiveShowsIndexs.removeAll()
        activeMovies.removeAll()
        activeMoviesIndexs.removeAll()
        activeShows.removeAll()
        activeShowsIndexs.removeAll()
        upcomingMovies.removeAll()
        upcomingMoviesIndexs.removeAll()
        upcomingShows.removeAll()
        upcomingShowsIndexs.removeAll()
        
        showsV2.removeAll()
        print(showsV2.count)
        print(shows.count)
        
        for index in shows.indices {
            showsV2.append(ShowV2(name: shows[index].name, icon: shows[index].icon, releaseDate: shows[index].releaseDate, active: shows[index].active, info: shows[index].info, platform: shows[index].platform, reoccuring: shows[index].reoccuring, reoccuringDate: Date()))
        }
        ShowV2.saveToFile(showsV2)
        print(showsV2.count)
        
        for index in movies.indices {
            if movies[index].active {
                activeMovies.append(movies[index])
                activeMoviesIndexs.append(index)
            } else if checkUpcoming(date: movies[index].releaseDate) {
                upcomingMovies.append(movies[index])
                upcomingMoviesIndexs.append(index)
                scheduleNotification(title: "Watching", info: "\(movies[index].name) is out now!", date: movies[index].releaseDate)
            } else {
                inactiveMovies.append(movies[index])
                inactiveMoviesIndexs.append(index)
            }
        }
        for index in shows.indices {
            if shows[index].active {
                activeShows.append(shows[index])
                activeShowsIndexs.append(index)
            } else if checkUpcoming(date: shows[index].releaseDate) {
                upcomingShows.append(shows[index])
                upcomingShowsIndexs.append(index)
                scheduleNotification(title: "Watching", info: "\(shows[index].name) is out now!", date: shows[index].releaseDate)
            } else {
                inactiveShows.append(shows[index])
                inactiveShowsIndexs.append(index)
            }
        }
//        for index in showsV2.indices {
//            if showsV2[index].active {
//                activeShows.append(showsV2[index])
//                activeShowsIndexs.append(index)
//            } else if checkUpcoming(date: showsV2[index].releaseDate) {
//                upcomingShows.append(showsV2[index])
//                upcomingShowsIndexs.append(index)
//                scheduleNotification(title: "Watching", info: "\(showsV2[index].name) is out now!", date: showsV2[index].releaseDate)
//            } else {
//                inactiveShows.append(showsV2[index])
//                inactiveShowsIndexs.append(index)
//            }
//        }
        total = activeMovies.count + activeShows.count + inactiveMovies.count + inactiveShows.count
    }
    
    init() {
        if isFirstTimeOpening() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    //background object to reload page
                    if movies.count == 0 && shows.count == 0 {
                        Spacer()
                        Text("Hit the plus in the top right to add your first Movie/Show!")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    VStack {
                        if upcomingMovies.count != 0 || upcomingShows.count != 0 {
                            HStack {
                                Text("Upcoming:")
                                    .foregroundColor(.gray)
                                    .padding(.top, 25)
                                    .onTapGesture(count: 3, perform: {
                                        ytEasterEgg.toggle()
                                    })
                                Spacer()
                            } .padding(.horizontal)
                                .onAppear(perform: {
                                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                        loadItems()
                                    })
                                })
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                                ForEach(upcomingMovies.indices, id: \.self, content: { index in
                                    NavigationLink(destination: {
                                        editPage(movies: $movies, shows: $shows, upcomingMovies: $upcomingMovies, upcomingMoviesIndexs: $upcomingMoviesIndexs, upcomingShows: $upcomingShows, upcomingShowsIndexs: $upcomingShowsIndexs, activeMovies: $activeMovies, activeMoviesIndexs: $activeMoviesIndexs, activeShows: $activeShows, activeShowsIndexs: $activeShowsIndexs, inactiveMovies: $inactiveMovies, inactiveMoviesIndexs: $inactiveMoviesIndexs, inactiveShows: $inactiveShows, inactiveShowsIndexs: $inactiveShowsIndexs, iconTheme: selectedItemTheme, theTitle: upcomingMovies[index].name, theSelectedDate: upcomingMovies[index].releaseDate, theShowDate: true, theNotes: upcomingMovies[index].info, type: "Movie", theIconTheme: getTypeForImage(image: upcomingMovies[index].icon), thePlatform: upcomingMovies[index].platform, theActive: upcomingMovies[index].active, theReoccuring: false, ogType: 0, typeIndex: index)
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
                            }) .padding(.horizontal)
                            if upcomingMovies.count != 0 && upcomingShows.count != 0 {
                                Rectangle()
                                    .frame(height: 2, alignment: .center)
                                    .foregroundColor(.gray.opacity(0.3))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                                ForEach(upcomingShows.indices, id: \.self, content: { index in
                                    NavigationLink(destination: {
                                        editPage(movies: $movies, shows: $shows, upcomingMovies: $upcomingMovies, upcomingMoviesIndexs: $upcomingMoviesIndexs, upcomingShows: $upcomingShows, upcomingShowsIndexs: $upcomingShowsIndexs, activeMovies: $activeMovies, activeMoviesIndexs: $activeMoviesIndexs, activeShows: $activeShows, activeShowsIndexs: $activeShowsIndexs, inactiveMovies: $inactiveMovies, inactiveMoviesIndexs: $inactiveMoviesIndexs, inactiveShows: $inactiveShows, inactiveShowsIndexs: $inactiveShowsIndexs, iconTheme: selectedItemTheme, theTitle: upcomingShows[index].name, theSelectedDate: upcomingShows[index].releaseDate, theShowDate: true, theNotes: upcomingShows[index].info, type: "Show", theIconTheme: getTypeForImage(image: upcomingShows[index].icon), thePlatform: upcomingShows[index].platform, theActive: upcomingShows[index].active, theReoccuring: upcomingShows[index].reoccuring, ogType: 0, typeIndex: index)
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
                            }) .padding(.horizontal)
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
                                editPage(movies: $movies, shows: $shows, upcomingMovies: $upcomingMovies, upcomingMoviesIndexs: $upcomingMoviesIndexs, upcomingShows: $upcomingShows, upcomingShowsIndexs: $upcomingShowsIndexs, activeMovies: $activeMovies, activeMoviesIndexs: $activeMoviesIndexs, activeShows: $activeShows, activeShowsIndexs: $activeShowsIndexs, inactiveMovies: $inactiveMovies, inactiveMoviesIndexs: $inactiveMoviesIndexs, inactiveShows: $inactiveShows, inactiveShowsIndexs: $inactiveShowsIndexs, iconTheme: selectedItemTheme, theTitle: activeMovies[index].name, theSelectedDate: activeMovies[index].releaseDate, theShowDate: false, theNotes: activeMovies[index].info, type: "Movie", theIconTheme: getTypeForImage(image: activeMovies[index].icon), thePlatform: activeMovies[index].platform, theActive: activeMovies[index].active, theReoccuring: false, ogType: 1, typeIndex: index)
                            }, label: {
                                HStack {
                                    Image(systemName: activeMovies[index].icon)
                                        .foregroundColor(.pink)
                                        .font(.system(size: 20, weight: .medium))
                                    Text(activeMovies[index].name)
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                        .foregroundColor(.primary)
                                        .frame(height: 20)
                                        .truncationMode(.tail)
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
                        if activeMovies.count != 0 && activeShows.count != 0 {
                            Rectangle()
                                .frame(height: 2, alignment: .center)
                                .foregroundColor(.gray.opacity(0.3))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        ForEach(activeShows.indices, id: \.self, content: { index in
                            NavigationLink(destination: {
                                editPage(movies: $movies, shows: $shows, upcomingMovies: $upcomingMovies, upcomingMoviesIndexs: $upcomingMoviesIndexs, upcomingShows: $upcomingShows, upcomingShowsIndexs: $upcomingShowsIndexs, activeMovies: $activeMovies, activeMoviesIndexs: $activeMoviesIndexs, activeShows: $activeShows, activeShowsIndexs: $activeShowsIndexs, inactiveMovies: $inactiveMovies, inactiveMoviesIndexs: $inactiveMoviesIndexs, inactiveShows: $inactiveShows, inactiveShowsIndexs: $inactiveShowsIndexs, iconTheme: selectedItemTheme, theTitle: activeShows[index].name, theSelectedDate: activeShows[index].releaseDate, theShowDate: false, theNotes: activeShows[index].info, type: "Show", theIconTheme: getTypeForImage(image: activeShows[index].icon), thePlatform: activeShows[index].platform, theActive: activeShows[index].active, theReoccuring: activeShows[index].reoccuring, ogType: 1, typeIndex: index)
                            }, label: {
                                HStack {
                                    Image(systemName: activeShows[index].icon)
                                        .foregroundColor(.pink)
                                        .font(.system(size: 20, weight: .medium))
                                    Text(activeShows[index].name)
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                        .foregroundColor(.primary)
                                        .frame(height: 20)
                                        .truncationMode(.tail)
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
                                editPage(movies: $movies, shows: $shows, upcomingMovies: $upcomingMovies, upcomingMoviesIndexs: $upcomingMoviesIndexs, upcomingShows: $upcomingShows, upcomingShowsIndexs: $upcomingShowsIndexs, activeMovies: $activeMovies, activeMoviesIndexs: $activeMoviesIndexs, activeShows: $activeShows, activeShowsIndexs: $activeShowsIndexs, inactiveMovies: $inactiveMovies, inactiveMoviesIndexs: $inactiveMoviesIndexs, inactiveShows: $inactiveShows, inactiveShowsIndexs: $inactiveShowsIndexs, iconTheme: selectedItemTheme, theTitle: inactiveMovies[index].name, theSelectedDate: inactiveMovies[index].releaseDate, theShowDate: false, theNotes: inactiveMovies[index].info, type: "Movie", theIconTheme: getTypeForImage(image: inactiveMovies[index].icon), thePlatform: inactiveMovies[index].platform, theActive: inactiveMovies[index].active, theReoccuring: false, ogType: 2, typeIndex: index)
                            }, label: {
                                HStack {
                                    Image(systemName: inactiveMovies[index].icon)
                                        .foregroundColor(.pink)
                                        .font(.system(size: 20, weight: .medium))
                                    Text(inactiveMovies[index].name)
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                        .foregroundColor(.primary)
                                        .frame(height: 20)
                                        .truncationMode(.tail)
                                        
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
                        if inactiveMovies.count != 0 && inactiveShows.count != 0 {
                            Rectangle()
                                .frame(height: 2, alignment: .center)
                                .foregroundColor(.gray.opacity(0.3))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        ForEach(inactiveShows.indices, id: \.self, content: { index in
                            NavigationLink(destination: {
                                editPage(movies: $movies, shows: $shows, upcomingMovies: $upcomingMovies, upcomingMoviesIndexs: $upcomingMoviesIndexs, upcomingShows: $upcomingShows, upcomingShowsIndexs: $upcomingShowsIndexs, activeMovies: $activeMovies, activeMoviesIndexs: $activeMoviesIndexs, activeShows: $activeShows, activeShowsIndexs: $activeShowsIndexs, inactiveMovies: $inactiveMovies, inactiveMoviesIndexs: $inactiveMoviesIndexs, inactiveShows: $inactiveShows, inactiveShowsIndexs: $inactiveShowsIndexs, iconTheme: selectedItemTheme, theTitle: inactiveShows[index].name, theSelectedDate: inactiveShows[index].releaseDate, theShowDate: false, theNotes: inactiveShows[index].info, type: "Show", theIconTheme: getTypeForImage(image: inactiveShows[index].icon), thePlatform: inactiveShows[index].platform, theActive: inactiveShows[index].active, theReoccuring: inactiveShows[index].reoccuring, ogType: 2, typeIndex: index)
                            }, label: {
                                HStack {
                                    Image(systemName: inactiveShows[index].icon)
                                        .foregroundColor(.pink)
                                        .font(.system(size: 20, weight: .medium))
                                    Text(inactiveShows[index].name)
                                        .font(.system(size: 20, weight: .medium, design: .rounded))
                                        .foregroundColor(.primary)
                                        .frame(height: 20)
                                        .truncationMode(.tail)
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
               // .navigationBarTitle("Watchable", displayMode: showTotalOverlay ? .inline : .automatic)
                .navigationBarTitle("Watchable", displayMode: .inline)
                .navigationBarItems(
                    leading:
                        Button {
                            withAnimation {
                                showTotalOverlay.toggle()
                            }
                        } label: {
                            Text("\(total)")
                        },
                    trailing:
                        Button {
                            showNewSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                )
                
            }
            .onAppear(perform: { loadItems() })
            .sheet(isPresented: $showNewSheet, onDismiss: {
                loadItems()
            },content: {
                NewSheet(showSheet: $showNewSheet, movies: $movies, shows: $shows, showsV2: $showsV2)
                    .interactiveDismissDisabled(true)
                    .accentColor(.pink)
                    .toggleStyle(SwitchToggleStyle(tint: Color.pink))
            })
            .overlay(
                WatchableOverlay(activeMovies: activeMovies, activeShows: activeShows, inactiveMovies: inactiveMovies, inactiveShows: inactiveShows, upcomingMovies: upcomingMovies, upcomingShows: upcomingShows, showTotalOverlay: $showTotalOverlay)
                        .opacity(showTotalOverlay ? 1 : 0)
                        .animation(.easeIn, value: 3)
                        .transition(.move(edge: .leading))
            )
        } .accentColor(.pink)
        .alert(isPresented: $ytEasterEgg, content: {
            Alert(title: Text("Oh cool you found an easter egg!"), primaryButton: .destructive(Text(UIApplication.shared.alternateIconName == "AppIcon-1" ? "Give me the old icon back" : "Gimme my prize"), action: {
                if UIApplication.shared.alternateIconName == "AppIcon-1" {
                    UIApplication.shared.setAlternateIconName(nil)
                } else {
                    UIApplication.shared.setAlternateIconName("AppIcon-1")
                }
                ytEasterEgg = true
                print("toggling icon")
            }), secondaryButton: .cancel(Text("go away lmao")))
        })
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
    
    @Binding var movies: [Movie]
    @Binding var shows: [Show]
    @Binding var upcomingMovies: [Movie]
    @Binding var upcomingMoviesIndexs: [Int]
    @Binding var upcomingShows: [Show]
    @Binding var upcomingShowsIndexs: [Int]
    
    @Binding var activeMovies: [Movie]
    @Binding var activeMoviesIndexs: [Int]
    @Binding var activeShows: [Show]
    @Binding var activeShowsIndexs: [Int]
    
    @Binding var inactiveMovies: [Movie]
    @Binding var inactiveMoviesIndexs: [Int]
    @Binding var inactiveShows: [Show]
    @Binding var inactiveShowsIndexs: [Int]
    
    @State var showPickers = false
    
    @State private var selectedDate: Date = Date()
    @State private var showDate: Bool = false
    @State var title = ""
    @State private var notes = ""
    @State var iconTheme = "Default"
    @State var themeTypes = ["Default", "Action", "Fantasy", "Sci-Fi", "Drama", "Comedy", "Romance", "Horror", "Documentary", "Game Show"]
    @State var platformTypes = ["Theater", "Netflix", "Hulu", "HBO Max", "Prime Video", "Disney+", "Youtube TV", "Apple TV", "Peacock", "Other"]
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
    
    @State var loaded = false
    
    let ogType: Int
    let typeIndex: Int
    
    @State var showAlert = false
    
    @State var deleting = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .keyboardType(.alphabet)
                
                TextField("Notes", text: $notes)
            }
            
            if showPickers {
                Section {
                    Picker("Theme", selection: $iconTheme, content: {
                        ForEach(themeTypes, id: \.self, content: {
                            editPickerLabel(name: $0, image: getImageForType(type: $0))
                        })
                    })
                    Picker("Platform", selection: $platform, content: {
                        ForEach(platformTypes, id: \.self, content: {
                            Text($0)
                        })
                    })
                }
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Edit Item")
        .navigationBarItems(trailing:
            Button {
                print("disappear")
                if deleting != true {
                    if type == "Movie" {
                        switch ogType {
                            case 0:
                                print("0")
                                movies.remove(at: upcomingMoviesIndexs[typeIndex])
                            case 1:
                                print("1")
                                movies.remove(at: activeMoviesIndexs[typeIndex])
                            default:
                                print("2")
                                movies.remove(at: inactiveMoviesIndexs[typeIndex])
                        }
                    } else {
                        switch ogType {
                            case 0:
                                print("0")
                                shows.remove(at: upcomingShowsIndexs[typeIndex])
                            case 1:
                                print("1")
                                shows.remove(at: activeShowsIndexs[typeIndex])
                            default:
                                print("2")
                                shows.remove(at: inactiveShowsIndexs[typeIndex])
                        }
                    }
                    if type == "Movie" {
                        if title != "" {
                            if active {
                                selectedDate = Date()
                            }
                            movies.insert(Movie(name: title, icon: getImageForType(type: iconTheme), releaseDate: selectedDate, active: active, info: notes, platform: platform), at: 0)
                            Movie.saveToFile(movies)
                        }
                    } else {
                        if title != "" {
                            if active {
                                selectedDate = Date()
                            }
                            shows.insert(Show(name: title, icon: getImageForType(type: iconTheme), releaseDate: selectedDate, active: active, info: notes, platform: platform, reoccuring: reoccuring), at: 0)
                            Show.saveToFile(shows)
                        }
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Save")
            }
        )
        .alert("Delete \(type)?", isPresented: $showAlert, actions: {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if type == "Movie" {
                    switch ogType {
                        case 0:
                            print("0")
                            movies.remove(at: upcomingMoviesIndexs[typeIndex])
                        case 1:
                            print("1")
                            movies.remove(at: activeMoviesIndexs[typeIndex])
                        default:
                            print("2")
                            movies.remove(at: inactiveMoviesIndexs[typeIndex])
                    }
                } else {
                    switch ogType {
                        case 0:
                            print("0")
                            shows.remove(at: upcomingShowsIndexs[typeIndex])
                        case 1:
                            print("1")
                            shows.remove(at: activeShowsIndexs[typeIndex])
                        default:
                            print("2")
                            shows.remove(at: inactiveShowsIndexs[typeIndex])
                    }
                }
                Movie.saveToFile(movies)
                Show.saveToFile(shows)
                deleting = true
                self.presentationMode.wrappedValue.dismiss()
            }
        })
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
            if showPickers == false {
                iconTheme = theIconTheme
                platform = thePlatform
            }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                showPickers = true
            })
            active = theActive
            reoccuring = theReoccuring
        })
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showAlert.toggle()
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
                }
            }
        }
    }
}

struct editPage2: View {
    
    @Binding var movies: [Movie]
    @Binding var shows: [Show]
    @Binding var upcomingMovies: [Movie]
    @Binding var upcomingMoviesIndexs: [Int]
    @Binding var upcomingShows: [Show]
    @Binding var upcomingShowsIndexs: [Int]
    
    @Binding var activeMovies: [Movie]
    @Binding var activeMoviesIndexs: [Int]
    @Binding var activeShows: [Show]
    @Binding var activeShowsIndexs: [Int]
    
    @Binding var inactiveMovies: [Movie]
    @Binding var inactiveMoviesIndexs: [Int]
    @Binding var inactiveShows: [Show]
    @Binding var inactiveShowsIndexs: [Int]
    
    @State var showPickers = false
    
    @State private var selectedDate: Date = Date()
    @State private var showDate: Bool = false
    @State var title = ""
    @State private var notes = ""
    @State var iconTheme = "Default"
    @State var themeTypes = ["Default", "Action", "Fantasy", "Sci-Fi", "Drama", "Comedy", "Romance", "Horror", "Documentary", "Game Show"]
    @State var platformTypes = ["Theater", "Netflix", "Hulu", "HBO Max", "Prime Video", "Disney+", "Youtube TV", "Apple TV", "Peacock", "Other"]
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
    
    @State var loaded = false
    
    let ogType: Int
    let typeIndex: Int
    
    @State var showAlert = false
    
    @State var deleting = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .keyboardType(.alphabet)
                
                TextField("Notes", text: $notes)
            }
            
            if showPickers {
                Section {
                    Picker("Theme", selection: $iconTheme, content: {
                        ForEach(themeTypes, id: \.self, content: {
                            editPickerLabel(name: $0, image: getImageForType(type: $0))
                        })
                    })
                    Picker("Platform", selection: $platform, content: {
                        ForEach(platformTypes, id: \.self, content: {
                            Text($0)
                        })
                    })
                }
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Edit Item")
        .navigationBarItems(trailing:
            Button {
                print("disappear")
                if deleting != true {
                    if type == "Movie" {
                        switch ogType {
                            case 0:
                                print("0")
                                movies.remove(at: upcomingMoviesIndexs[typeIndex])
                            case 1:
                                print("1")
                                movies.remove(at: activeMoviesIndexs[typeIndex])
                            default:
                                print("2")
                                movies.remove(at: inactiveMoviesIndexs[typeIndex])
                        }
                    } else {
                        switch ogType {
                            case 0:
                                print("0")
                                shows.remove(at: upcomingShowsIndexs[typeIndex])
                            case 1:
                                print("1")
                                shows.remove(at: activeShowsIndexs[typeIndex])
                            default:
                                print("2")
                                shows.remove(at: inactiveShowsIndexs[typeIndex])
                        }
                    }
                    if type == "Movie" {
                        if title != "" {
                            if active {
                                selectedDate = Date()
                            }
                            movies.insert(Movie(name: title, icon: getImageForType(type: iconTheme), releaseDate: selectedDate, active: active, info: notes, platform: platform), at: 0)
                            Movie.saveToFile(movies)
                        }
                    } else {
                        if title != "" {
                            if active {
                                selectedDate = Date()
                            }
                            shows.insert(Show(name: title, icon: getImageForType(type: iconTheme), releaseDate: selectedDate, active: active, info: notes, platform: platform, reoccuring: reoccuring), at: 0)
                            Show.saveToFile(shows)
                        }
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Save")
            }
        )
        .alert("Delete \(type)?", isPresented: $showAlert, actions: {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if type == "Movie" {
                    switch ogType {
                        case 0:
                            print("0")
                            movies.remove(at: upcomingMoviesIndexs[typeIndex])
                        case 1:
                            print("1")
                            movies.remove(at: activeMoviesIndexs[typeIndex])
                        default:
                            print("2")
                            movies.remove(at: inactiveMoviesIndexs[typeIndex])
                    }
                } else {
                    switch ogType {
                        case 0:
                            print("0")
                            shows.remove(at: upcomingShowsIndexs[typeIndex])
                        case 1:
                            print("1")
                            shows.remove(at: activeShowsIndexs[typeIndex])
                        default:
                            print("2")
                            shows.remove(at: inactiveShowsIndexs[typeIndex])
                    }
                }
                Movie.saveToFile(movies)
                Show.saveToFile(shows)
                deleting = true
                self.presentationMode.wrappedValue.dismiss()
            }
        })
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
            if showPickers == false {
                iconTheme = theIconTheme
                platform = thePlatform
            }
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                showPickers = true
            })
            active = theActive
            reoccuring = theReoccuring
        })
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showAlert.toggle()
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
                }
            }
        }
    }
}

struct editPickerLabel: View {
    
    let name: String
    let image: String
    
    var body: some View {
        Label(name, systemImage: image)
    }
    
}

func scheduleNotification(title: String, info: String, date: Date) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = info
    
    // Configure the recurring date.
    var dateComponents = DateComponents()
    let calendar = Calendar.current
    dateComponents.calendar = Calendar.current
    dateComponents.month = calendar.component(.month, from: date)
    dateComponents.day = calendar.component(.day, from: date)
    dateComponents.year = calendar.component(.year, from: date)
    dateComponents.hour = 0
    dateComponents.minute = 1
    dateComponents.second = 0
    
    // Create the trigger as a repeating event.
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    // Create the request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
       if error != nil {
          // Handle any errors.
           print("NOTIFICATION ERROR HAS OCCURRED")
       }
    }
    
}

func scheduleNotificationTest(title: String, info: String, date: Date) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = info
    
    // Configure the recurring date.
    var dateComponents = DateComponents()
    let calendar = Calendar.current
    dateComponents.calendar = Calendar.current
    dateComponents.month = calendar.component(.month, from: date)
    dateComponents.day = calendar.component(.day, from: date)
    dateComponents.year = calendar.component(.year, from: date)
    dateComponents.hour = calendar.component(.hour, from: date)
    dateComponents.minute = calendar.component(.minute, from: date)
    dateComponents.second = calendar.component(.second, from: date)
    // Create the trigger as a repeating event.
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    // Create the request
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
       if error != nil {
          // Handle any errors.
           print("NOTIFICATION ERROR HAS OCCURRED")
       }
    }
    
}

func isFirstTimeOpening() -> Bool {
  let defaults = UserDefaults.standard

  if(defaults.integer(forKey: "hasRun") == 0) {
      defaults.set(1, forKey: "hasRun")
      return true
  }
  return false

}

func createDate(weekday: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.hour = 0
        components.minute = 1
        components.year = calendar.component(.year, from: Date())
        components.weekday = weekday // sunday = 1 ... saturday = 7
        components.weekdayOrdinal = 10
        components.timeZone = .current

        return calendar.date(from: components)!
    }

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
