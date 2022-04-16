//
//  Theme.swift
//  FirebasePlayground (iOS)
//
//  Created by Bradley Ryan on 4/12/22.
//

import SwiftUI

protocol ColorTheme {
	//acent
	var accent: Color { get }
	var themeName: String { get }
}



struct Theme1: ColorTheme {

	var accent: Color

	init() {
		self.accent =  Color("Accent")
	}

	var themeName: String = "Blue Accent"

}


struct Theme2: ColorTheme {
	var accent: Color
	init() {
		self.accent =  Color("Accent2")
	}
	var themeName: String = "Red Accent"
}


enum ThemeManager {

	static let colorThemes: [ColorTheme] = [Theme1(), Theme2()]

	static func getTheme(_ colorTheme: Int) -> ColorTheme {
		Self.colorThemes[colorTheme]
	}

}


class ThemeData: ObservableObject {

	@Published var color: ColorTheme = Theme2()
	@ObservedObject var content = ContentModel()

	init() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.updateTheme(value: self.content.user?.theme ?? 0)
		}
	}

	func updateTheme(value: Int) {
		color = ThemeManager.getTheme(value)
	}


}


struct ThemeView: View {

	@EnvironmentObject var themeData: ThemeData
	@StateObject var content = ContentModel()

	var body: some View {

		VStack {

			//			Button("Button title") {
			//				themeData.updateTheme(value: 0)
			//			}
			//
			//
			//			Button("Button title") {
			//				themeData.updateTheme(value: 1)
			//			}

			Form {

				Section(header: Text("Color Themes")) {

					Section {

						Picker(selection: Binding<String>(
							get: {
								content.user?.userSelectedOption ?? ""
							},
							set: {
								updateTheme(value: 1)
								content.updateUserSelectedOption(to: $0)
							}),
									 label: Text("School Name")) {
							ForEach(0..<ThemeManager.colorThemes.count, id: \.self) { theme in
								Text(ThemeManager.colorThemes[theme].themeName)
									.foregroundColor(themeData.color.accent)
							}
						}
						.pickerStyle(.inline)
					}
				}
			}
		}
	}
}
