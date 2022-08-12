//
//  ContentView.swift
//  HabitTracking
//
//  Created by Azoz Salah on 08/08/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var activities = Activities()
    @State private var showingAddNewActivity = false
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.pink,.yellow]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                List {
                    Section {
                        ForEach(activities.activities) { activity in
                            NavigationLink {
                                ActivityView(activities: activities, activity: activity)
                            }label: {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(activity.name)
                                        .font(.headline)
                                    Text("Count: \(activity.count)")
                                }
                            }
                        }
                        .onDelete(perform: removeActivity)
                    }
                }
            }
            .navigationTitle("Habit-Tracking")
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingAddNewActivity)
            {
                AddNewActivity(activities: activities)
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button() {
                        showingAddNewActivity = true
                    }label: {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    func removeActivity(at offset: IndexSet) {
        activities.activities.remove(atOffsets: offset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
