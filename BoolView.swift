//
//  SettingsView.swift
//  FirebasePlayground (iOS)
//
//  Created by Bradley Ryan on 3/22/22.

import SwiftUI

// ptea.sima@gmail.com
//TODO: lookup firestore codable

struct BoolView: View {

	@StateObject var content = ContentModel()

	var body: some View {
		Section(header: Text("States")) {
			Toggle("Approach 2", isOn: Binding<Bool>(
				get: {
					content.user?.toggled ?? false
				},
				set: {
					content.setToggled(to: $0)
				} ))
		}
		.animation(.default, value: content.user?.toggled ?? false)
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		BoolView()
	}
}
