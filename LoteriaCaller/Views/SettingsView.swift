//
//  SettingsView.swift
//  LoteriaCaller
//
//  Created by Ruben Reyes on 4/15/24.
//

import SwiftUI

// Enum to represent language options
enum LanguageOption: String {
    case spanish = "Spanish"
    case english = "English"
    case both = "Both"
}

// SettingsViewModel to manage the selected language preference
class SettingsViewModel: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguage: String = LanguageOption.spanish.rawValue
}

// SettingsView to display language options and save selected preference
struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    
    var body: some View {
        let backGradient = LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
      
            // lang choice
        Form {
            Section(header: Text("Language")) {
                Picker("Language", selection: $viewModel.selectedLanguage) {
                    Text(LanguageOption.spanish.rawValue).tag(LanguageOption.spanish.rawValue)
                    Text(LanguageOption.english.rawValue).tag(LanguageOption.english.rawValue)
                    Text(LanguageOption.both.rawValue).tag(LanguageOption.both.rawValue)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .background(backGradient)
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    SettingsView()
}
