# 🌄 SL Hiker – Travel App

**SL Hiker** is a mobile application developed using **Flutter** and **Firebase** to enhance the hiking and travel experience in Sri Lanka. The app allows users to explore new places, track their location, connect with local guides, rent camping equipment, and more.

---

## 🚀 Features and Functionalities

### 🔐 Login & Signup – *Implemented by W.A.P.H.S Warnasuriya*
- Users can **sign in** using their email and password.
- If new, users can **create an account** by providing their name, email, and password via the **Sign Up** screen.
- After login, users are navigated to the main interface.
- A **sign out** button is available at the **top left corner** of the app.

---

### 🗺️ Google Map Location Tracking – *Implemented by U.H.S Apsara & R.D.P.R Rmanayka*
- Displays the user’s **current location** on an interactive Google Map.
- Helps users identify their position and navigate surroundings.
- Uses Flutter's `google_maps_flutter` and device location plugins.
- Firebase is used for backend support and data access.

---

### 📍 Real-Time Location Tracking – *Implemented by R.R Chandrasekara & R.P.S.G. Madushanka*
- Continuously tracks the **user’s movement** and updates the location in **real-time**.
- Useful for group travel, hiking safety, or location sharing features.
- Integrated with Firebase for live updates and data synchronization.

---

### 🏞️ Add Travel Places – *Implemented by H.A.R. Dharmasena*
- Users can add new places by tapping the **floating action button** at the bottom right.
- Supports:
  - Image upload
  - Title input
  - Description of the travel place
- All added places are visible in a list view – both **user-uploaded** and **others’ contributions**.

---

### 🔍 Search Functionality – *Implemented by R.P.T.G Madushanka*
- Users can search travel places by:
  - Full name of the location
  - Partial match (e.g., just one or two letters)
- Provides quick filtering and better discoverability of places.

---

### 👨‍✈️ Hire Guide & 🏕️ Hire Camping Items – *Implemented by W.M.V.R. Wijethunga*
- **Hire Guide**: Navigates to a page showing the **guide’s name and contact number**.
- **Hire Camping Items**: Navigates to a screen with the **rental provider’s name and phone number**.
- Data is stored and managed via **Firebase Firestore**.
- Admin-side control is handled via the **Firebase Console**, not inside the app.

---

## 📱 Technologies Used

- **Flutter** – Mobile UI toolkit
- **Firebase** – Backend as a service
  - Authentication
  - Firestore (database)
  - Real-time updates
- **Google Maps API** – For map features

---

## 🧑‍💻 Contributors

| Name                        | Feature Implemented                              |
|-----------------------------|--------------------------------------------------|
| W.A.P.H.S Warnasuriya       | Login / Signup                                   |
| U.H.S Apsara                | Google Map Location Tracking                     |
| R.D.P.R Rmanayka            | Google Map Location Tracking                     |
| R.R Chandrasekara           | Real-Time Location Tracking                      |
| R.P.S.G. Madushanka         | Real-Time Location Tracking                      |
| H.A.R. Dharmasena           | Add Travel Places                                |
| R.P.T.G. Madushanka         | Search Functionality                             |
| W.M.V.R. Wijethunga         | Hire Guide & Hire Camping Items                  |

---

## 📂 Project Setup Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/sl-hiker.git
   cd sl-hiker
