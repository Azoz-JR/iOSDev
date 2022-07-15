//
//  ContentView.swift
//  Unit_Conversions
//
//  Created by Azoz Salah on 15/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var input: Double = 0
    @State private var inputUnit = ""
    @State private var outputUnit = ""
    @FocusState private var inputIsFocused: Bool

    
    let units = ["Seconds", "Minutes", "Hours", "Days"]
    
    func conversion(_ inputValue: Double, _ inputUnit: String, _ outputUnit: String, _ function: (Double) -> Double) -> Double {
        function(input)
    }
    
    var output: Double {
        
       let x = conversion(input, inputUnit, outputUnit) {
            if inputUnit.hasPrefix("Days") {
                switch outputUnit {
                case "Days":
                    return $0
                    
                case "Hours" :
                    return $0 * 24
                    
                case "Minutes" :
                    return $0 * 24 * 60
                    
                case "Seconds" :
                    return $0 * 24 * 60 * 60
                    
                default:
                    return 0
            }
        }
            if inputUnit.hasPrefix("Hours") {
                switch outputUnit {
                case "Days":
                    return $0 / 24
                    
                case "Hours" :
                    return $0
                    
                case "Minutes" :
                    return $0 * 60
                    
                case "Seconds" :
                    return $0 * 60 * 60
                    
                default:
                    return 0
            
                }
            }
            if inputUnit.hasPrefix("Minutes") {
                switch outputUnit {
                case "Days":
                    return $0 / (24 * 60)
                    
                case "Hours" :
                    return $0 / 60
                    
                case "Minutes" :
                    return $0
                    
                case "Seconds" :
                    return $0 * 60
                    
                default:
                    return 0
            
                }
            }
            if inputUnit.hasPrefix("Seconds") {
                switch outputUnit {
                case "Days":
                    return $0 / (24 * 60 * 60)
                    
                case "Hours" :
                    return $0 / (60 * 60)
                    
                case "Minutes" :
                    return $0 / 60
                    
                case "Seconds" :
                    return $0
                    
                default:
                    return 0
            
                }
            }
           return 0
        }
        return x
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Input Value", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                }
                Section {
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Enter input unit")
                }
                Section {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                } header: {
                    Text("Enter output unit")
                }
                Section {
                    Text(output, format: .number)
                } header: {
                    Text("Output Unit")
                }
                
            }
            .navigationTitle("Time Conversion")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
