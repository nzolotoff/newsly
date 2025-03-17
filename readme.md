# Newsly

## Overview
Newsly is a modern news application built with Swift and UIKit, following the SVIP (VIPER) architecture. The app fetches and displays news articles with pagination support and image caching, ensuring a smooth user experience.

## User Interface 
![shimmer](https://github.com/user-attachments/assets/b22eeedd-7ac1-4164-99e2-ebadf2984378)
<img width="352" alt="loading" src="https://github.com/user-attachments/assets/044698a0-b070-45cd-b7b2-8ad09c4403be" />
<img width="352" alt="error state" src="https://github.com/user-attachments/assets/f42e4cb1-1a25-46f3-b0fe-845872071f87" />
<img width="352" alt="share" src="https://github.com/user-attachments/assets/ce304c58-c05d-4081-90a1-9886e650fff7" />


## Features
- **Clean Architecture - SVIP (VIPER)**: Ensures modularity and testability of the business logic.
- **Custom Networking Layer**: A fully implemented infrastructure layer that interacts with a local worker for fetching news with efficient pagination.
- **Data Transfer Objects (DTOs)**: Implements DTOs to separate network models from business logic, ensuring clean data transformation and maintainability.
- **Pagination Support** – New articles load automatically when the user scrolls to the bottom of the list.
- **Pull-to-Refresh** – Users can refresh news articles by pulling down at the top of the feed.
- **Shimmer Animation** – Uses `CAGradientLayer` to simulate content loading before data appears.
- **Efficient Cell Reuse** – Optimized table view cells for better scrolling performance.
- **Article Viewing** – Articles open in `SFSafariViewController` for a seamless reading experience.
- **Sharing Feature** – Users can share articles using `UIActivityViewController` by long-pressing on a cell.
- **Image Caching**: Implements `NSCache` to reduce network requests and improve performance.
- **Error Handling**: Multi-level error handling across the network, business logic, and UI, with proper state representation for the user.
- **Unit Testing** – The business logic is covered with `XCTest` to ensure app stability and reliability.


## Tech Stack
- **Swift**
- **UIKit**
- **SVIP (VIPER) Architecture**
- **URLSession** (Networking)
- **GCD** (Concurrency & Performance Optimization)
- **NSCache** (Image Caching)
- **XCTest** (Unit Testing)
- **SafariServices** 

## Requirements
- Xcode 15+
- iOS 15.6+

### Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/Newsly.git
   cd Newsly
   ```
2. Open `Newsly.xcodeproj` in Xcode.
3. Build and run the project on a simulator or a physical device.

## Architecture
Newsly follows the **SVIP (VIPER)** architecture, which promotes separation of concerns and enhances testability.
- **View** – Responsible for displaying UI and handling user input.
- **Interactor** – Manages business logic and processes data received from the Worker.
- **Presenter** – Prepares data for the View and handles navigation logic (unlike VIPER, where navigation is handled separately by a Router).
- **Worker** – Executes network requests and processes raw data.
- **Service Layer** – Handles API requests, response parsing, and error management.

## Testing
Newsly uses `XCTest` for unit testing. Key testable components:
- **Interactor Tests**: Ensuring business logic functions correctly. Validates that business logic processes data correctly, including API responses, pagination, and error handling.

Run tests using:
```sh
Cmd + U (in Xcode)
```

## Contributing
Feel free to contribute by opening issues or submitting pull requests.

## License
MIT License. See `LICENSE` for details.





