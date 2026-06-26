# Assessment & Examination App 📝

*A comprehensive mobile platform for real-time test-taking, featuring secure authentication, seamless assessment management, and a striking neon user interface.*

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State_Management-BLoC-blue?style=for-the-badge&logo=bloc)
![ASP.NET Core](https://img.shields.io/badge/asp.net_core-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white)
![Theme](https://img.shields.io/badge/UI_Design-Neon_Theme-00f5ff?style=for-the-badge)

## 📱 Application Flow & Previews

<p align="center">
  <img src="assets/onboarding.png" width="22%" alt="Onboarding Screen">
  <img src="assets/login.png" width="22%" alt="Login Page">
  <img src="assets/register.png" width="22%" alt="Register Page">
  <img src="assets/homepage.png" width="22%" alt="Homepage">
</p>

<p align="center">
  <img src="assets/tests_list.png" width="22%" alt="Tests List Page">
  <img src="assets/test_page.png" width="22%" alt="Test Page">
  <img src="assets/submit_page.png" width="22%" alt="Submit Page">
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

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone [https://github.com/yourusername/assessment-app.git](https://github.com/yourusername/assessment-app.git)
