# iOS Machine Learning Examples

A collection of iOS applications demonstrating machine learning implementation using Apple's CoreML and Vision frameworks.

## Overview

This repository contains multiple example projects showcasing different ML use cases including image classification, gender detection, and regression models. Each project demonstrates practical implementation of trained models on iOS devices.

## Technologies

- **Language**: Swift
- **Frameworks**: CoreML, Vision, UIKit, CreateML
- **Platform**: iOS

## Projects Included

### 1. Gender Detection App
**Location**: `temp Gender Detector/`

Classifies gender from images using the GenderNet.mlmodel.

```swift
let request = VNCoreMLRequest(model: genderModel) { request, error in
    guard let results = request.results as? [VNClassificationObservation] else { return }
    // Process classification results
}
```

### 2. Dog/Cat Classifier
**Location**: `temp dogCat App/`

Binary image classification to identify dogs or cats.

- Camera and photo library input
- VNCoreMLRequest for inference
- Confidence score display

### 3. Mars Habitat Pricer
**Location**: `temp ML Mars habitat/`

Regression model predicting Mars habitat prices based on:
- Number of solar panels (0-5)
- Number of greenhouses (0-5)
- Size in acres (1000-10000)

```swift
let prediction = try model.prediction(
    solarPanels: Double(panels),
    greenhouses: Double(houses),
    size: Double(acres)
)
```

### 4. Image Classifier Playground
**Location**: `temp Image Classifer.playground/`

Swift Playground demonstrating CreateML UI for training image classifiers.

## Features

- Real-time image classification
- Camera and photo library integration
- Background processing with GCD
- Confidence score visualization
- Multiple model types (classification, regression)

## Project Structure

```
Swift_ios_ML_Machine_Learning/
├── temp Gender Detector/       # Gender classification
├── temp dogCat App/            # Dog/Cat classifier
├── temp ML Mars habitat/       # Regression model
└── temp Image Classifer.playground/  # CreateML demo
```

## Requirements

- Xcode
- iOS 11.0+ (CoreML support)
- Physical device recommended for camera features

## License

MIT License

![ML Demo](https://github.com/The-Odd-Institute/Swift_ios_ML_Machine_Learning/blob/master/ios_ML%20.gif)
