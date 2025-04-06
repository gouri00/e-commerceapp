# 🛒 Flutter E-Commerce App (Buyer & Vendor)

A full-featured e-commerce mobile application built with **Flutter** and **Firebase**, following the **MVC architecture**. This project includes two separate Android apps — one for buyers (senders) and another for vendors — along with an **admin panel** for centralized management.

---

## 📱 Features

### 🔹 Buyer App (Sender)
- 🔐 **Email/Password Authentication**
- 🛍️ **Product Browsing**
- ❤️ **Wishlist Functionality**
- 🛒 **Shopping Cart**
- 👤 **User Account Management**
- 📍 **Google Maps Integration** for location & delivery
- 💵 **Payment on Delivery Option**
- 🗨️ **Live Chat with Vendors**
- 📦 **Order Placement**

### 🔸 Vendor App
- 📦 **Order Management**
- 🧾 **Product Listings**
- 🗺️ **Map Integration** for delivery coordination
- 🗨️ **Real-time Chat with Buyers**
- 📊 **Basic Analytics/Order Tracking**

### 🛠️ Admin Panel
- 🛍️ **Product Management**
- 👥 **User Management**
- 📦 **Order Oversight**
- 📊 **Dashboard with Analytics**

---

## 🧱 Architecture

Follows the **Model-View-Controller (MVC)** pattern for clean separation of logic, UI, and backend calls.

---

## 🔧 Tech Stack

- **Flutter** (Frontend - UI)
- **Firebase** (Backend)
  - Authentication (Email/Password)
  - Firestore (Database)
  - Firebase Storage (Product Images)
  - Firebase Cloud Messaging (Future Scope)
- **Google Maps SDK** (Flutter plugin)
- **Firebase Realtime Chat** (using Firestore or Firebase Realtime Database)
- **Web-based Admin Panel** (can be built using Flutter Web or Firebase Console)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- Firebase Project setup
- Google Maps API Key

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/flutter-ecommerce-app.git
