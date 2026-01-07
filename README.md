# SwiftUIAssignment
SwiftUI assignment with Clean + mvvm architecture

**Product App (SwiftUI + SwiftData)**
A robust iOS application demonstrating modern architectural patterns using Clean Architecture, MVVM, and Offline-First data synchronization.

**Architecture Overview**
The app is built using a layered architecture to ensure separation of concerns, high testability, and maintainability.

**1. Presentation Layer (MVVM)**
View: SwiftUI views that observe the ViewModel.
ViewModel: Manages UI state (Loading, Success, Error) and communicates with the UseCase.

**3. Domain Layer**
UseCase: Contains business logic. It acts as a bridge between the ViewModel and the Repository.

Entities: The core data models used by the business logic (e.g., ProductEntity).

**5. Data Layer**
Repository: Orchestrates data between the remote API and the local database. It handles the logic for offline data persistence.

API Manager: Handles network requests and JSON decoding into DTOs (Data Transfer Objects).

Local Store (SwiftData): Manages local persistence using ModelContext.

**Features**
Offline-First: Uses a Repository pattern to fetch from the local database if the network is unavailable.

Network Monitoring: Real-time connectivity checks to determine data sourcing.

Data Synchronization: Automatically updates local records with fresh data from the API during successful fetches.

Robust Error Handling: Distinct handling for server errors, empty data, and invalid URLs.
