# Assessment & Examination App 📝

*A comprehensive mobile platform for real-time test-taking, featuring secure authentication, seamless assessment management, and a striking neon user interface.*

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge&logo=bloc)
![ASP.NET Core](https://img.shields.io/badge/asp.net_core-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)

## 📱 Application Flow & Previews

<p align="center">
  <img src="assets/appUi/Onboarding.jpeg" width="21%" alt="Onboarding Screen">&nbsp;&nbsp;
  <img src="assets/appUi/login.jpeg" width="21%" alt="Login Page">&nbsp;&nbsp;
  <img src="assets/appUi/Register.jpeg" width="21%" alt="Register Page">&nbsp;&nbsp;
  <img src="assets/appUi/Homepage.jpeg" width="21%" alt="Homepage">
  <br><br>

  <img src="assets/appUi/TestList.jpeg" width="21%" alt="Tests List Page">&nbsp;&nbsp;
  <img src="assets/appUi/Test1.jpeg" width="21%" alt="Test Page">&nbsp;&nbsp;
  <img src="assets/appUi/Test2.jpeg" width="21%" alt="Submit Page">&nbsp;&nbsp;
  <img src="assets/appUi/WrongAnswer.jpeg" width="21%" alt="Wrong Answer Page">
  <br><br>

  <img src="assets/appUi/Analytics.jpeg" width="21%" alt="Analytics Page">&nbsp;&nbsp;
  <img src="assets/appUi/Homepage2.jpeg" width="21%" alt="Homepage">&nbsp;&nbsp;
  <img src="assets/appUi/PrevTests.jpeg" width="21%" alt="Previous Tests Page">&nbsp;&nbsp;
  <img src="assets/appUi/Result.jpeg" width="21%" alt="Result Page">
</p>

> **Note:** Update the `src` paths above with your actual GitHub issue links or relative asset paths.

## ✨ Key Features

*   **Striking Neon UI:** A custom-designed, visually engaging neon theme applied consistently across onboarding, dashboards, and testing interfaces.
*   **Predictable State Management:** Utilizes the BLoC (Business Logic Component) pattern to strictly decouple UI components from the underlying business logic, ensuring scalable and testable code.
*   **Secure Authentication:** End-to-end token validation ensuring that only registered users can access the homepage and active assessments.
*   **Dynamic Assessment Engine:** Fetches live test data, including varied question types, directly from the backend API.
*   **Reliable Submission Pipeline:** Packages test data and pushes it to the backend infrastructure, handling loading states and success/failure confirmations on the submission page.

## 🏗️ Architecture & Tech Stack

**Frontend (Mobile Client)**
*   **Framework:** Flutter (Dart)
*   **State Management:** BLoC
*   **UI/UX:** Custom Neon Theme
*   **Local Persistence:** Hive (for caching user session tokens and offline data)

**Backend (API & Infrastructure)**
*   **Server:** ASP.NET Core Web API
*   **Database:** MongoDB
*   **Deployment Architecture:** Containerized microservices using Docker, orchestrated via Kubernetes.

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (v3.0 or higher)
*   .NET 8.0 SDK (for local backend development)
*   A running instance of MongoDB (Local or Atlas)

