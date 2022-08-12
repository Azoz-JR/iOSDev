//
//  AddNewActivity.swift
//  HabitTracking
//
//  Created by Azoz Salah on 08/08/2022.
//

import SwiftUI

struct AddNewActivity: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var activities: Activities
    @State private var showingAlert = false
    
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Section {
                        TextField("Activity name", text: $name)
                        
                    }
                }
            }
            .navigationTitle("Add New Activity")
            .navigationBarBackButtonHidden(true)
            
            .toolbar() {
                Button() {
                    if (name.trimmingCharacters(in: .whitespaces)).count != 0 {
                        saveActivity(name: name)
                        dismiss()
                    }else {
                        showingAlert = true
                    }
                    //self.presentationMode.wrappedValue.dismiss()
                }label: {
                    Text("Save")
                        .font(.headline.bold())
                }
            }
            
            .alert("Please write a suitable name", isPresented: $showingAlert) {
                Button("Continue") {
                    showingAlert = false
                }
            }
        }
    }
    func saveActivity(name: String, count: Int = 0) {
        let activity = Activity(name: name, count: count, description: "")
        activities.activities.append(activity)
    }
}

struct AddNewActivity_Previews: PreviewProvider {
    static var previews: some View {
        AddNewActivity(activities: Activities())
            .preferredColorScheme(.dark)
    }
}
