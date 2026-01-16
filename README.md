# Weather Clean App

![Build Status](https://img.shields.io/badge/build-passing-brightgreen) ![License](https://img.shields.io/badge/license-MIT-blue)

A modern, feature-rich Weather Application built with Flutter, demonstrating the power of **Clean Architecture**.

![Weather App Mockup](./assets/images/weather_app_mockup.png)

## 🌟 Features

-   **Clean Architecture**: Separation of concerns into Data, Domain, and Presentation layers.
-   **State Management**: Uses `flutter_bloc` for predictable state management.
-   **Real-time Weather**: Current temperature, humidity, wind speed, and pressure.
-   **Forecasts**: Hourly and daily weather forecasts.
-   **City Management**: Search and save favorite cities.
-   **Interactive Map**: Visualize weather patterns on a map.
-   **Beautiful UI**: Glassmorphism design with smooth animations.

## 🏗️ Architecture

This project strictly follows the **Clean Architecture** principles to ensure scalability, testability, and maintainability.

### Layers

1.  **Presentation Layer (UI)**:
    -   Contains Widgets, Pages, and BLoCs.
    -   Responsible for displaying data and handling user interactions.
    -   Depends only on the Domain Layer.

2.  **Domain Layer (Business Logic)**:
    -   The core of the application.
    -   Contains Entities, Use Cases, and Repository Interfaces.
    -   Pure Dart code, independent of Flutter or external libraries.

3.  **Data Layer (Data Access)**:
    -   Handles data retrieval from APIs (OpenWeatherMap) or local storage.
    -   Contains DTOs (Data Transfer Objects), Repository Implementations, and Data Sources.

### Project Structure

```
lib/
├── core/                   # Core utilities, constants, and error handling
├── data/                   # Data layer (DTOs, Repositories, Data Sources)
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/                 # Domain layer (Entities, UseCases, Repository Interfaces)
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/           # Presentation layer (BLoCs, Pages, Widgets)
│   ├── bloc/
│   ├── pages/
│   └── widgets/
├── injector.dart           # Dependency Injection setup
└── main.dart               # Application entry point
```

## 🚀 Getting Started

### Prerequisites

-   Flutter SDK
-   Dart SDK

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/your-username/weather_clean_app.git
    ```
2.  Navigate to the project directory:
    ```bash
    cd weather_clean_app
    ```
3.  Install dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the app:
    ```bash
    flutter run
    ```

## 📚 Libraries Used

-   `flutter_bloc`: State management.
-   `dio`: HTTP client for API requests.
-   `get_it` & `injectable`: Dependency injection.
-   `equatable`: Value equality comparisons.
-   `flutter_map`: specific map implementation.
-   `fl_chart`: For drawing charts.
