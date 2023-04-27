xcodebuild \
  -workspace FoodPicker.xcworkspace \
  -scheme FoodPicker \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.0' \
  test