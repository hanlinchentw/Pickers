//
//  CarouselImage.swift
//  Picker
//
//  Created by 陳翰霖 on 2025/3/14.
//

import Combine
import RswiftResources
import SwiftUI

struct CarouselImage: View {
	typealias ImageResource = RswiftResources.ImageResource

	@State var currentIndex = 0
	private let images: [ImageResource]
	private let size: CGSize?
	private let timer: Publishers.Autoconnect<Timer.TimerPublisher>

	init(images: [ImageResource], interval: TimeInterval = 1, size: CGSize? = nil) {
		self.images = images
		self.size = size
		timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
	}

	var body: some View {
		Image(currentImage)
			.ifLet(size, transform: { size, image in
				image
					.resizable()
					.scaledToFit()
					.frame(width: size.width, height: size.height)
			})
			.onReceive(timer) { timer in
				withAnimation(.spring()) {
					currentIndex = Int(timer.timeIntervalSince1970) % images.count
				}
			}
	}

	var currentImage: ImageResource {
		images[currentIndex]
	}
}

#Preview {
	let images = [R.image.fast_food_line, R.image.rice_line, R.image.pizza_line, R.image.spaghetti_line, R.image.fish_chips_line]
	CarouselImage(images: images, size: .zero)
}
