//
//  SwiftUIView.swift
//  FirebasePlayground (iOS)
//
//  Created by Bradley Ryan on 4/12/22.
//

import SwiftUI
import Firebase

struct Option: Identifiable, Hashable {
	var id: String = UUID().uuidString
	var name: String
}

struct ListView: View {

	@ObservedObject var viewModel = OptionsViewModel() // (/1)
	@State var selectedSchool = "option 1"
	@StateObject var content = ContentModel()

	var body: some View {

		Form {
			Section {
				Picker(selection: $selectedSchool, label: Text("School Name")) {
					ForEach(viewModel.options) { option in
						Text(option.name).tag(option.name)
					}
				}
				.onChange(of: selectedSchool) { _ in

					//update user in firestore
					guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
							return
					}
					FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["userSelectedOption": selectedSchool])
				}
				.pickerStyle(.inline)
				Text("Local Binding: \(selectedSchool)")
				Text("Firebase: \(content.user?.userSelectedOption ?? "")")
			}
		}

		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				selectedSchool = content.user?.userSelectedOption ?? ""
			}
		}

	}
}


class OptionsViewModel: ObservableObject {

	@Published var options = [Option]()

	init() {
		fetchData()
	}

	func fetchData() {

		FirebaseManager.shared.firestore.collection("options").addSnapshotListener { (querySnapshot, error) in

			guard let documents = querySnapshot?.documents else {
				print("No documents")
				return
			}

			self.options = documents.map { queryDocumentSnapshot -> Option in
				let data = queryDocumentSnapshot.data()
				let name = data["name"] as? String ?? ""

				return Option(name: name)
			}
		}
	}
}
