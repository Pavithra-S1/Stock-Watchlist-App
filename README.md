
# 📈 Stock Watchlist App (Flutter)

This is a stock watchlist Flutter application built as part of a technical interview task. It features a dark-themed UI, BLoC state management, and follows Clean Architecture. All data is handled locally using mock data sources — no API calls are used.

---

## ✨ Features Implemented (Based on the Task)

### 1. Home Screen with Bottom Navigation Bar
- The app opens with a Home screen that includes a bottom navigation bar.
- Tabs include: **Watchlist**, **Orders**, **Portfolio**, **Movers**, and **More**.

### 2. Watchlist Screen
- Contains **multiple watchlist groups** (e.g., NIFTY, BANKNIFTY, etc.) using a top TabBar.
- Group-specific **symbol lists** with distinct stocks per tab.
- Integrated **Search bar** that navigates to the Search screen.
- On **long press** of any symbol, the screen enters **Edit Mode** where:
  - Symbols can be **reordered using drag-and-drop**
  - All **edge cases** are handled, including:
    - Switching tabs during edit mode
    - Clicking search while editing
    - Properly exiting edit mode

### 3. Search Screen
- Displays a list of **default stock symbols**
- Live **search and filtering** based on input
- Allows adding symbols to the current group using a ➕ icon
- Prevents adding duplicates

### 4. Manage Watchlist Screen
- Users can:
  - **Reorder** entire watchlist groups
  - **Rename** watchlist titles
  - **Delete** watchlists
  - Option to **customize the view** layout (placeholder implemented)

### 5. Local Storage (Mock)
- All watchlists and stock data are stored in memory via mock data sources
- No backend/API is used
- Data simulates persistence (can be extended using SharedPreferences or Hive)

### 6. BLoC and Clean Architecture
- BLoC is used throughout the app for scalable and testable state management
- Code is structured using **Clean Architecture**:
  - `data`, `domain`, and `presentation` layers
  - Supports scalability and maintainability

---



## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants/
│   └── services/
├── features/
│   ├── home/
│   │   └── presentation/
│   │       └── pages/
│   ├── search/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── pages/
│   └── watchlist/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── main.dart
```

---

### Prerequisites

- Flutter SDK (3.x or higher)
- Dart SDK
- VS Code or Android Studio

### Run the App

```bash
flutter pub get  
flutter run
```


### Getting Started
Prerequisites
Flutter SDK (3.x or higher)
Dart SDK
Android Studio or VS Code


### Screenshots of App's UI


![WhatsApp Image 2025-04-09 at 6 13 29 PM (1)](https://github.com/user-attachments/assets/f86be99a-3e40-4a44-918a-d5fce20c96f8)
![WhatsApp Image 2025-04-09 at 6 13 29 PM (2)](https://github.com/user-attachments/assets/61d3ce9d-4d06-440a-a0aa-ecc58485d799)
![WhatsApp Image 2025-04-09 at 6 13 29 PM](https://github.com/user-attachments/assets/b8e6a776-ab64-4cbe-be17-644311ae8ce9)


   
