//
//  ContentView.swift
//  Shared
//
//  Created by Bradley Ryan on 3/21/22.
//

import SwiftUI

struct ContentView: View {
    
    
    @ObservedObject var content = ContentModel()

		var theme = ThemeData()

    var body: some View {
        VStack(spacing: 24) {
//            Spacer()
//            Button (action: {
//                signInAnonymously()
//            }) {
//                Text("Sign in")
//            }
//            Button (action: {
//                content.getUserData()
//            }) {
//                Text("Get User Data")
//            }

						ThemeView()
							.environmentObject(theme)

//            BoolView()
//
//						ListView()
//
//            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



