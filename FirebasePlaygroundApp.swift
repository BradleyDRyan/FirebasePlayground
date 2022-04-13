//
//  FirebasePlaygroundApp.swift
//  Shared
//
//  Created by Bradley Ryan on 3/21/22.
//

import SwiftUI
import Firebase
import FirebaseAuth


class FirebaseManager : NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}

@main

struct FirebasePlaygroundApp: App {
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContentModel())
        }
    }
}


func signInAnonymously() {
    
    
    print("Trying")
    
    FirebaseManager.shared.auth.signInAnonymously { authResult, error in
        if let error = error {
            print("ⓧ Authentication error: \(error.localizedDescription).")
        } else {
            print("✔ Authentication was successful.")
            storeUserInformation()
        }
    }
}

func storeUserInformation() {
    
    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
    
    let userData = ["uid": uid]
    
    FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { error in
        if let error = error {
            print(error)
        } else {
            print("Success")
        }
    }
}


struct User {
    var uid,
    name: String,
		userSelectedOption: String,
    toggled: Bool
 }

class ContentModel: ObservableObject {
    
	@Published var errorMessage = ""
	@Published var user: User?
    
	init() {
			getUserData()
	}

	func setToggled(to newValue: Bool) {
		user?.toggled = newValue

		//update user in firestore
		guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
				self.errorMessage = "Could not find firebase uid"
				return
		}
		FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["toggled": newValue])
	}

    func getUserData() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        
     
        FirebaseManager.shared.firestore.collection("users").document(uid).addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }

            guard let data = querySnapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }
            
            let uid = data["uid"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let toggled = data["toggled"] as? Bool ?? false
						let userSelectedOption = data["userSelectedOption"] as? String ?? "option 1"

            self.user = User(
                uid: uid,
                name: name,
								userSelectedOption: userSelectedOption,
                toggled: toggled
            )

        }
        
    }

}



