//
//  ActivityView.swift
//  HabitTracking
//
//  Created by Azoz Salah on 08/08/2022.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var activities: Activities
    var activity: Activity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                Text(activity.name)
                    .font(.largeTitle.bold())
                    .padding([.top])
                    
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.lightBackground)
                    .padding(.vertical)
                HStack {
                    Text("Counter:  \(activity.count)")
                        .font(.headline.bold())
                    
                    Spacer()
                    
                    Button() {
                        let act = activities
                        if let index = act.activities.firstIndex(where: {$0.name == activity.name}) {
                            let temp = activities.activities[index]
                            activities.activities[index] = Activity(id: temp.id, name: temp.name, count: temp.count + 1, description: temp.description)
                        }
                    }label: {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                    
                }
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.lightBackground)
                    .padding(.vertical)
                
                HStack {
                    Text("Description")
                        .font(.title.bold())
                        .padding(.bottom, 10)
                    
                    Spacer()
                    
                    Button("Edit") {
                        
                    }
                }
                
                Text(activity.description)
                
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(activities: Activities(), activity: Activity(name: "ActivityName", count: 0, description: "Hello World"))
            .preferredColorScheme(.dark)
    }
}
