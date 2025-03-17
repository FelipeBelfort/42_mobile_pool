# 📱 Piscine Mobile - 42 School

This repository contains all the modules from the **Piscine Mobile** at 42 School. The Piscine is an intensive set of projects designed to teach the fundamentals of mobile development using **Flutter and Firebase**.

## 📌 Piscine Structure
The Piscine is divided into **6 modules**, which should be completed in order:

| Module  | Name | Description |
|---------|---------------------------------|------------------------------------------------------|
| **0**   | Basic-of-the-mobile-application | Introduction to Flutter, Widgets, and first steps. |
| **1**   | Structure and logic | Code organization, navigation, and state management. |
| **2**   | API and data | API consumption, data handling, and JSON. |
| **3**   | Design | User interface, themes, and responsiveness. |
| **4**   | Auth and database | Firebase authentication and database handling. |
| **5**   | Manage data and display | Data management and real-time display. |

---

## 🛠️ Project Setup

### **1️⃣ Clone the Repository**
```sh
git clone https://github.com/your-username/piscine-mobile.git
cd piscine-mobile
```

### **2️⃣ Install Dependencies**
```sh
flutter pub get
```

### **3️⃣ Configure Firebase (if needed)**
For modules involving **authentication and database**, set up Firebase:
1. Create a project in [Firebase Console](https://console.firebase.google.com/).
2. Download the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) file and place it in the corresponding folders:
   - `android/app/`
   - `ios/Runner/`
3. Enable **Authentication** and **Firestore Database**.

### **4️⃣ Run the Project**
```sh
flutter run
```

---

## 📂 Repository Structure
```
piscine-mobile/
│── mobile-0/                 # Module 0 - Introduction to Flutter
│── mobile-1/                 # Module 1 - Structure and logic
│── mobile-2/                 # Module 2 - API and data
│── mobile-3/                 # Module 3 - Design
│── mobile-4/                 # Module 4 - Authentication and database
│── mobile-5/                 # Module 5 - Data management
│── README.md                 # Project documentation
```

