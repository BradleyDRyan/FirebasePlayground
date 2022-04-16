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

	@StateObject var content = ContentModel()
	@StateObject var viewModel = OptionsViewModel() // (/1)

	var body: some View {

		Form {
			Section {
				
				Picker(selection: Binding<String>(
					get: {
						content.user?.userSelectedOption ?? ""
					},
					set: {
					 content.updateUserSelectedOption(to: $0)
				  }),
					label: Text("School Name")) {
					ForEach(viewModel.options) { option in
						Text(option.name).tag(option.name)
					}
				}
				.pickerStyle(.inline)

				Text("Firebase: \(content.user?.userSelectedOption ?? "")")
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
