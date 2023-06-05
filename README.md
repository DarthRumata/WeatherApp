# Weather App

The Weather App is a simple iOS application that displays current weather information based on user-selected or searched locations. It utilizes various services and frameworks to fetch weather data, handle user location, and display the information in a user-friendly interface.

## Features

 - Automatic retrieval of the user's current location
 - View the current weather details for a selected location
 - Search for locations by name using the Geocoding API
 - Robust error handling for network requests and location permissions
 - Persistence of the last selected location using UserDefaults, with retrieval on app start
 - Support for both landscape and portrait orientations on iPhone devices
 - Convenient button to switch to the user's current location from the currently selected location in weather details

## Installation

Clone the repository to your local machine.
Open the project in Xcode.
Build and run the app on the iOS Simulator or a physical device.
If you want to make changes in the code you also need to install Needle code generator using **homebrew**

## Architecture

The app implements a custom Mobile Architecture that combines the best features from MVVM, VIPER, and Clean Architecture. 
This architecture aims to separate concerns and improve maintainability.

For the user interface, a combination of UIKit and SwiftUI is used. UIViewController serves as the navigation container, while SwiftUI is responsible for rendering the screen content. 
This approach allows the usage of the Coordinator pattern for UI navigation transitions, avoiding the limitations of SwiftUI's immature navigation capabilities.

Combine is utilized for reactive programming in SwiftUI-ViewModel integrations, while Structured Concurrency (async/await) is employed in services.

The network layer is built on top of Alamofire, providing a robust NetworkService infrastructure for executing NetworkRequests. 

The dependency injection layer ensures compile-time safety, thanks to Needle Components that create services and coordinators. 
The coordinator acts as a module builder, receiving dependencies from the DI Component while constructing models and controllers.

The  UIViewController creates a hosting controller for SwiftUI content and passes the ViewModel inside. 
The DomainModel handles domain logic and interacts with services to fetch data and manage state. 
The ViewModel receives state updates from the DomainModel and formats it for consumption by the View.
The View is dual-bound with the ViewModel's state and provides user interaction feedback back to the ViewModel and DomainModel, completing the flow of data and actions.

## Dependencies
The app utilizes the following dependencies, managed with Swift Package Manager:

 - Alamofire: https://github.com/Alamofire/Alamofire A networking library used to make API requests.
 - Needle: https://github.com/uber/needle for DI layer
 - Kingfisher: https://github.com/onevcat/Kingfisher for image loading and caching(supports SwiftUI)
 - PopupView: https://github.com/exyte/PopupView for presenting error messages with toast style in SwiftUI

## License
The Weather App is released under the MIT License.
