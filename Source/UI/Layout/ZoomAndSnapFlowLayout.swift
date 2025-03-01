//
//  ZoomAndSnapFlowLayout.swift
//  Picker
//
//  Created by 陳翰霖 on 2022/9/3.
//  Copyright © 2022 陳翰霖. All rights reserved.
//

import UIKit

// swiftlint:disable force_cast
class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {
  let activeDistance: CGFloat = 200
  let zoomFactor: CGFloat = 0.1

  override func prepare() {
    guard let collectionView else { fatalError("not exist collectionView") }
    let collectionInset = collectionView.adjustedContentInset
    let verticalRemaining = collectionInset.top + collectionInset.bottom + itemSize.height
    let verticalInsets = (collectionView.frame.height - verticalRemaining) / 2
    let horizontalRemaining = collectionInset.right + collectionInset.left + itemSize.width
    let horizontalInsets = (collectionView.frame.width - horizontalRemaining) / 2
    sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
    super.prepare()
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let collectionView else { return nil }
    let rectAttributes = super.layoutAttributesForElements(in: rect)?.map {
      $0.copy() as! UICollectionViewLayoutAttributes
    }
    guard let rectAttributes else { return [] }

    let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

    // Make the cells be zoomed when they reach the center of the screen
    for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
      let distance = visibleRect.midX - attributes.center.x
      let normalizedDistance = distance / activeDistance

      if distance.magnitude < activeDistance {
        let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
        attributes.zIndex = Int(zoom.rounded())
      }
    }

    return rectAttributes
  }

  override func targetContentOffset(
    forProposedContentOffset proposedContentOffset: CGPoint,
    withScrollingVelocity _: CGPoint
  ) -> CGPoint {
    guard let collectionView else { return .zero }

    // Add some snapping behaviour so that the zoomed cell is always centered
    let targetRect = CGRect(
      x: proposedContentOffset.x,
      y: 0,
      width: collectionView.frame.width,
      height: collectionView.frame.height
    )
    guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

    var offsetAdjustment = CGFloat.greatestFiniteMagnitude
    let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

    for layoutAttributes in rectAttributes {
      let itemHorizontalCenter = layoutAttributes.center.x
      if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
        offsetAdjustment = itemHorizontalCenter - horizontalCenter
      }
    }

    return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
  }

  override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
    // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
    true
  }

  override func invalidationContext(
    forBoundsChange newBounds: CGRect
  ) -> UICollectionViewLayoutInvalidationContext {
    let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
    context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
    return context
  }
}

// swiftlint:enable force_cast
