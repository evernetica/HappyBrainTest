//
//  ContentView.swift
//  HappyBrainTest
//
//  Created by Alexander Malygin on 11/23/21.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var viewModel = MainViewModel()

    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.dataSource, id: \.self) { item in
                    Image(uiImage: item)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .cancel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
