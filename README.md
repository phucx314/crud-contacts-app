# CRUD Contacts App

This is a simple CRUD application for managing contacts, consisting of:
- **Backend**: .NET Web API
- **Web Frontend**: React.js
- **Mobile Frontend**: Flutter

## 📌 Project Structure
```
📂 crud-contacts-app
 ├── 📂 dotnet        # .NET Web API (Backend)
 ├── 📂 reactjs       # React.js Web Frontend
 ├── 📂 flutter       # Flutter Mobile App
```

---

## 🛠 Setup Guide

### 1️⃣ Backend - .NET Web API
#### Prerequisites:
- [.NET SDK 7+](https://dotnet.microsoft.com/download)
- SQLite (update connection string in `Program.cs`)

#### Steps to Run:
```bash
cd dotnet
dotnet restore
dotnet run
```
The API should now be running at: `http://localhost:8080/api/Contacts`
The API test UI is at: `http://localhost:8080/swagger/index.html`

---

### 2️⃣ Web Frontend - React.js
#### Prerequisites:
- [Node.js](https://nodejs.org/) installed
- [Yarn](https://yarnpkg.com/) (or use `npm`)

#### Steps to Run:
```bash
cd reactjs
npm install --legacy-peer-deps # or yarn install
npm start                      # or yarn start
```
Open `http://localhost:3000` in your browser.

---

### 3️⃣ Mobile Frontend - Flutter
#### Prerequisites:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android/iOS emulator or a physical device (recommended)

#### Steps to Run:
```bash
cd flutter
flutter pub get
flutter run
```

---

## ⚙️ Environment Variables
- **Mobile Frontend (Flutter)**: Modify API URL in `lib/api_endpoint.dart`

---

## 📄 API Endpoints
| Method | Endpoint                               | Description                                                         |
|--------|----------------------------------------|---------------------------------------------------------------------|
| GET    | `/api/Contacts/get-all-contacts?page={page}&contactsPerPage={pageSize}`| Get all contacts (with pagination)  |
| GET    | `/api/Contacts/get-a-contact/{id}`     | Get a contact by ID                                                 |
| POST   | `/api/Contacts/add-new-contact`        | Create a new contact                                                |
| POST   | `/api/Contacts/add-multiple-contacts`  | Add multiple contacts                                               |
| PUT    | `/api/Contacts/update-contact/{id}`    | Update a contact by ID                                              |
| DELETE | `/api/Contacts/delete-contact/{id}`    | Delete a contact by ID                                              |


---

## 🎯 Notes
- Ensure the **backend is running first** before starting frontend apps.
- I have enabled CORS in the `.NET Web API` (`Program.cs`).


