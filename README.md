# E-Commerce Flutter App

A modern, full-featured e-commerce application built with Flutter, applying Clean Architecture and integrated with Firebase for authentication, database, and storage.

## Features

- **User Authentication**: Sign up, sign in, password reset, and profile management.
- **Product Catalog**: Browse, search, and filter products by category.
- **Product Details**: View detailed product info, images, reviews, and ratings.
- **Cart & Checkout**:
  - Add, edit, remove products in cart
  - One-step checkout with order summary
  - Support for multiple payment methods (COD, PayPal, Card)
  - Shipping address management
- **Order Management**:
  - View order history and order details
  - Rebuy previous orders
  - Real-time order status tracking
- **User Account Management**:
  - Manage shipping addresses (add, edit, delete)
  - Manage payment methods (add, delete)
  - Change password, edit profile
- **Product Reviews**: Submit and view product ratings and reviews
- **Admin Features**: (if enabled) Product/category management, order management

## Tech Stack

- **Flutter** (Dart)
- **Firebase** (Auth, Firestore, Storage)
- **BLoC** (flutter_bloc) for state management
- **Clean Architecture** (Domain, Data, Presentation layers)
- **get_it** for dependency injection
- **PayPal** integration (via custom server)
- **Other packages**: dartz, shared_preferences, image_picker, intl, etc.

## Project Structure

```
lib/
  core/           # App-wide configs, constants, themes
  domain/         # Entities, repositories, usecases (Clean Architecture)
  data/           # Models, data sources, repository implementations
  presentation/   # UI, BLoC/Cubit, views, widgets
  common/         # Shared widgets, helpers
```

## Getting Started

1. **Clone the repository**
   ```sh
   git clone https://github.com/DangKhanh2808/ecommerce.git
   cd ecommerce
   ```
2. **Install dependencies**
   ```sh
   flutter pub get
   ```
3. **Configure Firebase**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders.
   - Make sure your Firebase project is set up for Auth, Firestore, and Storage.
4. **Run the app**
   ```sh
   flutter run
   ```

## Screenshots

_Add screenshots of main features here for best impression._

## Contribution

Feel free to fork and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.
