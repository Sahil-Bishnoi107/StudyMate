# Assessment & Examination App 📝

*A comprehensive mobile platform for real-time test-taking, featuring secure authentication, seamless assessment management, and a striking neon user interface.*

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge&logo=bloc)
![ASP.NET Core](https://img.shields.io/badge/asp.net_core-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)

## 📱 Application Flow & Previews

<p align="center">
  <table>
    <!-- Row 1: Core Authentication & Entry -->
    <tr>
      <td align="center"><img src="assets/appUi/Onboarding.jpeg" width="100%" alt="Onboarding Screen"><br><sub><b>Onboarding</b></sub></td>
      <td align="center"><img src="assets/appUi/login.jpeg" width="100%" alt="Login Page"><br><sub><b>Login</b></sub></td>
      <td align="center"><img src="assets/appUi/Register.jpeg" width="100%" alt="Register Page"><br><sub><b>Register</b></sub></td>
      <td align="center"><img src="assets/appUi/Homepage.jpeg" width="100%" alt="Homepage"><br><sub><b>Homepage</b></sub></td>
    </tr>
    <!-- Row 2: Examination Engine Flow -->
    <tr>
      <td align="center"><img src="assets/appUi/TestList.jpeg" width="100%" alt="Tests List Page"><br><sub><b>Tests List</b></sub></td>
      <td align="center"><img src="assets/appUi/Test1.jpeg" width="100%" alt="Test Page"><br><sub><b>Test Session</b></sub></td>
      <td align="center"><img src="assets/appUi/Test2.jpeg" width="100%" alt="Submit Page"><br><sub><b>Review & Submit</b></sub></td>
      <td align="center"><img src="assets/appUi/WrongAnswer.jpeg" width="100%" alt="Wrong Answer Page"><br><sub><b>Error Review</b></sub></td>
    </tr>
    <!-- Row 3: Metrics, Analytics & Results -->
    <tr>
      <td align="center"><img src="assets/appUi/Analytics.jpeg" width="100%" alt="Analytics Page"><br><sub><b>Performance Analytics</b></sub></td>
      <td align="center"><img src="assets/appUi/Homepage2.jpeg" width="100%" alt="Homepage"><br><sub><b>Updated Dashboard</b></sub></td>
      <td align="center"><img src="assets/appUi/PrevTests.jpeg" width="100%" alt="Previous Tests Page"><br><sub><b>History Logs</b></sub></td>
      <td align="center"><img src="assets/appUi/Result.jpeg" width="100%" alt="Result Page"><br><sub><b>Scorecard</b></sub></td>
    </tr>
  </table>
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

