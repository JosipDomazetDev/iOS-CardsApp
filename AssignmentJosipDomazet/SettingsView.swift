//
//  SettingsView.swift
//  AssignmentJosipDomazet
//
//  Created by user on 26.09.23.
//

import Foundation

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ItemViewModel
    @AppStorage("apiURL") private var apiURL = AppConstants.apiURL
    @AppStorage("showImages") private var showImages = true
    var body: some View {
        Form {
            Section(header: Text("API Settings")) {
                TextField("API URL", text: $apiURL)
                    .textContentType(.URL)
            }

            Section(header: Text("Image Settings")) {
                Toggle("Show Images", isOn: $showImages)
            }

            Section {
                Button(action: {
                    saveSettings()
                }) {
                    Text("Save Settings")
                }
            }
        }
        .onAppear {
            loadSettings()
        }
    }

    private func loadSettings() {
        apiURL = UserDefaults.standard.string(forKey: "apiURL") ?? AppConstants.apiURL
        showImages = UserDefaults.standard.bool(forKey: "showImages")
    }

    private func saveSettings() {
        UserDefaults.standard.set(apiURL, forKey: "apiURL")
        UserDefaults.standard.set(showImages, forKey: "showImages")

        viewModel.reloadItems()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: ItemViewModel(repository: ItemRepository()))
    }
}
