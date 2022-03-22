//
//  ContentView.swift
//  Shared
//
//  Created by Bradley Ryan on 3/21/22.
//

import SwiftUI

struct ContentView: View {
    
    
    @ObservedObject var content = ContentModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Button (action: {
                signInAnonymously()
            }) {
                Text("Sign in")
            }
            Button (action: {
                content.getUserData()
            }) {
                Text("Get User Data")
            }
            
            SettingsView()
            
            // why do I have to do this?
            Text(content.user?.name ?? "")
                .foregroundColor(Color.blue)
            
            if content.user?.toggled ?? false {
                Text("On").onTapGesture {
                    toggleOff()
                }
            } else {
                Text("Off")
                    .onTapGesture {
                        toggleOn()
                    }
            }
            
            Spacer()
        }
    }

    
    
    private func toggleOn() {
        
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["toggled": true]
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).updateData(userData) { err in
                if let err = err {
                    print(err)
                    print("Failure")
                    return
                }
                print("Success")
            }
    }
    
    private func toggleOff() {
        
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["toggled": false]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).updateData(userData) { err in
                if let err = err {
                    print(err)
                    print("Failure")
                    return
                }
                print("Success")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



