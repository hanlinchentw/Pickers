//
//  SwitchPocketView.swift
//  FoodPicker
//
//  Created by 陳翰霖 on 2024/10/6.
//  Copyright © 2024 陳翰霖. All rights reserved.
//

import SwiftUI
import Kingfisher
import URL

struct PocketRowItem: Identifiable, Equatable {
	var id: String { pocket.id }
	let pocket: Pocket
	var isExpanded = false
}

struct SwitchPocketView: View {
	@State var pocketRowItems: [PocketRowItem]

	let onClickCreateBtn: () -> Void
	let onSelectPocket: (Pocket) -> Void
	let onRemovePocket: (Pocket) -> Void
	let onClickEditBtn: (Pocket) -> Void

	init(
		pockets: [Pocket],
		onClickCreateBtn: @escaping () -> Void,
		onSelectPocket: @escaping (Pocket) -> Void,
		onRemovePocket: @escaping (Pocket) -> Void,
		onClickEditBtn: @escaping (Pocket) -> Void
	) {
		_pocketRowItems = State(wrappedValue: pockets.map { PocketRowItem(pocket: $0) })
		self.onClickCreateBtn = onClickCreateBtn
		self.onSelectPocket = onSelectPocket
		self.onRemovePocket = onRemovePocket
		self.onClickEditBtn = onClickEditBtn
	}

	var body: some View {
		ZStack {
			Color.gray.opacity(0.05).ignoresSafeArea()
			VStack(alignment: .leading, spacing: 24) {
				HStack {
					Text("Pocket Lists").en32Bold()
					Spacer()
					Button {
						onClickCreateBtn()
					} label: {
						Image(systemName: "plus.circle")
							.resizable()
							.scaledToFit()
							.frame(width: 24, height: 24)
					}
					.buttonStyle(.plain)
				}

				ScrollView {
					ForEach(pocketRowItems) { item in
						pocketRow(item)
							.padding(.bottom)
					}
				}
				.safeAreaInset(edge: .top) {
					Spacer().height(20)
				}
			}
			.padding()
		}
	}
}

extension SwitchPocketView {
	@ViewBuilder
	func pocketRow(_ item: PocketRowItem) -> some View {
		let pocket = item.pocket
		let isExpanded = item.isExpanded

		VStack {
			HStack(spacing: 16) {
				VStack(alignment: .leading, spacing: 12) {
					HStack(spacing: 4) {
						Text(pocket.name).en18Medium()
						Text("・")
						let count = pocket.places.count
						Text(count <= 1 ? "\(count) place" : "\(count) places")
							.en16Medium()
							.foregroundStyle(Color.gray2)
					}
					Text(pocket.createdTime.description).en16().foregroundStyle(Color.gray3)
				}

				Spacer()

				Button {
					withAnimation(.spring(duration: 0.5)) {
						if let index = pocketRowItems.firstIndex(of: item) {
							pocketRowItems[index].isExpanded.toggle()
						}
					}
				} label: {
					Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
				}
				.buttonStyle(.plain)
			}
			.contentShape(.rect)
			.onTapGesture {
				onSelectPocket(pocket)
			}
			if isExpanded {
				expandedPocketView(pocket)
			}
		}
		.padding(.horizontal, 24)
		.padding(.vertical, 24)
		.background(Color.white)
		.overlay {
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color.gray5)
		}
	}

	@ViewBuilder
	func expandedPocketView(_ pocket: Pocket) -> some View {
		Divider()
		ForEach(pocket.places, id: \.id) { place in
			HStack(spacing: 16) {
				KFImage(place.imageURL)
					.resizable()
					.scaledToFit()
					.frame(width: 80, height: 80)
					.cornerRadius(12)
				VStack(alignment: .leading, spacing: 8) {
					Text(place.name)
						.en16Bold()
						.foregroundColor(.primary)
					Text(place.address)
						.en16()
						.foregroundColor(.secondary)
				}
				Spacer()
			}
		}
		HStack {
			PrimaryButton(title: "Edit", width: .infinity) {
				onClickEditBtn(pocket)
			}
			SecondaryButton(
				title: "Remove",
				width: .infinity,
				role: .destructive
			) {
				onRemovePocket(pocket)
			}
		}
	}
}

#Preview {
	let url = #URL("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRjLWhWpx9PfbzysffLbMA_DK_8jawJAVHbw&s")
	let url2 = #URL("https://rimage.gnst.jp/rest/img/fsbbcur70000/s_0n7f.jpg?dt=1740970522")
	let address = "Emveryviles"
	let place = Place(id: "1", name: "McDonald", imageURL: url, address: address)
	let place2 = Place(id: "2", name: "Ding Tai Fung", imageURL: url2, address: "Taipei")

	let pocket = Pocket(
		id: "123",
		name: "New's",
		places: [place, place2]
	)

	let pockets: [Pocket] = [
		pocket,
		.init(id: "2", name: "Pocket Name B"),
	]

	SwitchPocketView(pockets: pockets) {
		print("onClickCreateBtn")
	} onSelectPocket: { pocket in
		print("onSelectPocket: \(pocket)")
	} onRemovePocket: { pocket in
		print("onRemovePocket: \(pocket)")
	} onClickEditBtn: { pocket in
		print("onClickEditBtn: \(pocket)")
	}
}

private struct PizzaView: View {
	struct ColorSet: RawRepresentable {
		var rawValue: [Color]

		static let colorfulSets: ColorSet = .init(rawValue: [.red, .green, .blue, .yellow])
		static let grayAndBlack: ColorSet = .init(rawValue: [.gray, .black, .gray, .black])
		static let ai: ColorSet = .init(rawValue: [.orange, .red, .purple, .blue])
	}

	let colors: [Color]

	init(set: ColorSet = .colorfulSets) {
		self.colors = set.rawValue
	}

	var body: some View {
		ZStack {
			// Divide the circle into four sections
			ForEach(0..<4) { index in
				// Create each section using a Path
				PizzaSlice(
					startAngle: Angle(degrees: Double(index) * 90),
					endAngle: Angle(degrees: Double(index + 1) * 90)
				)
				.fill(colors[index]) // Fill each slice with a different color
			}
		}
	}
}

private struct PizzaSlice: Shape {
	var startAngle: Angle
	var endAngle: Angle

	// Create the path for each slice of the pizza
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let radius = min(rect.width, rect.height) / 2

		// Move to the center of the circle
		path.move(to: center)

		// Add an arc to form a quarter circle
		path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

		// Close the path back to the center to form the slice
		path.closeSubpath()

		return path
	}
}

private struct AIRow: View {
	var meshGradient: MeshGradient {
		MeshGradient(
			width: 3, height: 3,
			points: [
				.init(0, 0),   .init(0.5, 0),   .init(1, 0),     // Top row (x,y)
				.init(0, 0.5), .init(0.4, 0.5), .init(1, 0.5),   // Middle row
				.init(0, 1),   .init(0.5, 1),   .init(1, 1)      // Bottom row
			],
			colors: [
				Color.orange, Color.yellow ,  Color.yellow,  // Top row colors
				Color.teal,    Color.purple,  Color.indigo,  // Middle row colors
				Color.blue,    Color.pink,    Color.purple   // Bottom row colors
			]
		)
	}

	var body: some View {
		HStack {
			Circle()
				.frame(width: 48, height: 48)
				.padding(.horizontal)
			Text("Hungry for ideas? AI’s cooking up your next pick!")

			Spacer()
		}
		.foregroundStyle(meshGradient)
	}
}
