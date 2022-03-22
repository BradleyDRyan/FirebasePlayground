//
//  SettingsView.swift
//  FirebasePlayground (iOS)
//
//  Created by Bradley Ryan on 3/22/22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var content = ContentModel()
    
    @State private var state: Bool = false
    
    var body: some View {
        Section(header: Text("States")) {
            
            
            Toggle("Aproach 1", isOn: $state)
                .onChange(of: state) { newValue in
                    updateStatus(state: state)
                }
            
            //Everything works here except the toggle doesn't animate properly.
            Toggle("Approach 2", isOn: Binding<Bool>(
                get: { content.user?.toggled ?? false },
                set: {
                    // $0 is the new Bool value of the toggle
                    // Your code for updating the model, or whatever
                    print("value: \($0)")
                    setToggle(state: $0)
                }
            )
            )
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                state = content.user?.toggled ?? false
                // content.getUserData()
                
                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                    return
                }
                
                FirebaseManager.shared.firestore.collection("users").document(uid).addSnapshotListener { querySnapshot, error in
                    
                    if let error = error {
                        print("Failed to fetch current user:", error)
                        return
                    }

                    guard let data = querySnapshot?.data() else {
                        return
                    }
                    
                    withAnimation {
                        state = data["toggled"] as? Bool ?? false
                    }
                }
                
                
                
            }
        }
    }
    
    
    func updateStatus(state: Bool) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["toggled": state]
        
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
    
    func setToggle(state: Bool) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["toggled": state]
        
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
