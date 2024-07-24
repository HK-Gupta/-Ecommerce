# eCommerce App Source Code

## Overview
The eCommerce App is a mobile application developed using Flutter that provides a comprehensive solution for online shopping. It features both admin and user models, real-time database updates using Firebase, secure payment processing with Stripe, and an intuitive UI enhanced by Lottie animations.

## Features
- Admin and User Models
- Firebase for Backend Services
- Stripe Payment Integration
- HTTP for Network Requests
- Lottie Animations for Enhanced UI
- Responsive Design for both iOS and Android

## Screenshots
<table>
  <tr align="center">
     <td>Starting Page</td>
     <td>Home Page</td>
     <td>Details Page</td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/cdc05145-919d-4d22-9a93-c80509d2291c" width="200"></td>
    <td><img src="https://github.com/user-attachments/assets/f41ad539-dd56-46de-bf59-ed73fdc8834e" width="200"></td>
    <td><img src="https://github.com/user-attachments/assets/05cfad99-7c3b-4c17-8015-f0339e57feda" width="200"></td>
  </tr>
</table>
<table>
  <tr align="center">
     <td>Payment Page</td>
     <td>Add Product Admin</td>
     <td>Orders Admin</td>
  </tr>
  <tr>
     <td><img src="https://github.com/user-attachments/assets/35478199-b3bb-4de7-a53c-108d7e97e403" width="200"></td>
    <td><img src="https://github.com/user-attachments/assets/21e57e99-f5f6-4b40-8ba7-7476cae36f50" width="200"></td>
    <td><img src="https://github.com/user-attachments/assets/bdcbf71a-c81c-4621-9fa9-f8d0558624c3" width="200"></td>
  </tr>
</table>

## Installation

### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- An editor like Android Studio or Visual Studio Code

### Steps
1. Clone the repository:
    ```sh
    git clone https://github.com/your-username/your-repo-name.git
    ```
2. Navigate to the project directory:
    ```sh
    cd your-repo-name
    ```
3. Get the dependencies:
    ```sh
    flutter pub get
    ```
4. Set up Firebase:
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Firebase Firestore and Authentication
   - Enable Google Sign-In in the Authentication section
   - Download the `google-services.json` file and place it in the `android/app` directory

5. Set up Stripe:
   - Sign up at [Stripe](https://stripe.com/)
   - Get your Stripe API keys and add them to your `.env` file

6. Create a `.env` file in the root directory and add your environment variables:
   ```env
   FIREBASE_API_KEY=your_firebase_api_key
   STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
