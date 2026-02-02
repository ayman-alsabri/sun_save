# Sun Save Application Report

## 1. Introduction
**Sun Save** represents a sophisticated model for educational and utility applications, specifically designed to address the challenges of vocabulary retention and language acquisition (English/Arabic). It combines modern mobile development practices with a clean, user-centric design to provide a seamless experience for managing, learning, and reinforcing vocabulary.

Developed using the **Flutter** framework, the application ensures high performance and a consistent user experience across Android and iOS platforms. This report provides an in-depth analysis of the application, ranging from the general vision to the precise technical details of the infrastructure and interfaces.

### 1.1 Vision and Strategy
The core concept revolves around creating a personal linguistic companion, not just a list of words. It aims to bridge the gap between encountering a new word and mastering it.
The application strives to achieve the following goals:
*   **Active Learning:** Engaging the user through Text-to-Speech (TTS) and interactive cards.
*   **Accessibility:** Providing quick access to translation and pronunciation tools.
*   **Retention:** utilizing daily smart notifications to reinforce memory.

## 2. Technical Infrastructure Analysis
The application relies on a robust technical architecture that ensures stability and scalability. The components were identified through a thorough examination of the project files.

### Core Technologies
| Component | Technology | Description |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart) | For developing high-performance cross-platform UIs. |
| **Database** | Drift (SQLite) | For robust, structured local storage of words and progress. |
| **State Management** | BLoC / Cubit | For predictable state transitions and separation of logic from UI. |
| **Dependency Injection** | GetIt | For decoupling components and managing service locators. |
| **Notifications** | Flutter Local Notifications | For scheduling localized daily learning reminders. |
| **Text-to-Speech** | Flutter TTS | For audio pronunciation of words (En & Ar). |
| **Localization** | flutter_localizations | For full Arabic and English support (ARB files). |

## 3. User Experience (UX) and Interface Design (UI)
The interface was designed based on modern **Material 3** principles, focusing on usability and visual clarity.

### A. Visual Identity
*   **Dynamic Theming:** The app features a customizable color system where users can pick a "Seed Color". The entire app scheme (Primary, Secondary, Surface) adapts dynamically to this choice.
*   **Modes:** Fully supports **Light** and **Dark** modes, automatically adapting to system settings or user preference.

### B. User Journey
The user journey is streamlined:
1.  **Onboarding/Auth:** Splash screen → Login/Register (Local Auth).
2.  **Home:** A clean dashboard split into "Unsaved" (Active) and "Saved" (Mastered) tabs.
3.  **Action:** A prominent FAB (Floating Action Button) allows quick word addition with Auto-Translate.
4.  **Review:** Tapping words reveals meanings; long-pressing offers management options.

## 4. Functional Interfaces
### Home Screen
The beating heart of the app, containing:
*   **Tabs:** Distinct views for `Unsaved` (Learning) and `Saved` (Done) words.
*   **Word Cards:** Interactive tiles that show English/Arabic. Features include:
    *   **Hide/Show:** Toggle visibility of translation for self-testing.
    *   **TTS Indicator:** Visual feedback when a word is being spoken.
*   **TTS Bar:** Global controls to Play/Pause/Stop the pronunciation of the list.

### Word Management (Details & Action)
*   **Add Word Sheet:** A bottom sheet with input validation and a "Smart Translate" button to fetch meanings automatically.
*   **Test Mode:** A distraction-free dialog with a dark background to test memory without cheating.
*   **Edit/Delete:** Full CRUD operations available via long-press on any word card.

### Settings & Navigation
*   **Drawer Menu:** Quick access to Profile, Settings, About, and Logout.
*   **Settings Page:**
    *   **Theming:** Color picker and Mode toggle.
    *   **Notifications:** Configuration for "Words per day" and active hours.
    *   **Language:** Switch app-wide language (Ar/En).

## 5. Configuration & Management System
While the app is personal (client-side), it includes a comprehensive internal configuration system:
*   **Data Management:** Users can manage their local database (CRUD) directly.
*   **Notification Scheduling:** An intelligent scheduler that recalculates delivery times based on the user's "Active Hours" and the number of unsaved words.
*   **User Profile:** Manages authentication state and user preferences locally.

## 6. Security and Data Protection
The application adheres to strict data handling standards:
*   **Local-First:** All vocabulary data is stored locally using `Drift` (SQLite), ensuring privacy and offline access.
*   **Secure Auth:** User credentials for local sessions are handled securely.
*   **Permissions:** Runtime permissions for Notifications are requested transparently with context.

## 7. Recommendations and Future Expansions
Based on the current analysis, the following features are recommended for future updates:
1.  **Cloud Sync:** Implement Firebase or a backend to sync words across devices.
2.  **Gamification:** Add streaks and badges for daily practice consistency.
3.  **Spaced Repetition:** Implement an algorithm (like SuperMemo) for more efficient learning intervals.

---

## Appendix A: Visual Assets
The app utilizes a centralized asset management strategy:
| Visual Resource | Path | Description |
| :--- | :--- | :--- |
| **App Icon** | `assets/icons/app_icon.png` | The primary launcher identity. |
| **Icons** | Material Symbols | Vector icons used throughout for scalability and clarity. |

## Appendix B: Data Flow Analysis
The app follows a **Clean Architecture** data flow:
1.  **UI Event:** User interacts (e.g., adds word).
2.  **BLoC:** Receives event, talks to `UseCase`.
3.  **UseCase:** Encapsulates business logic, calls `Repository`.
4.  **Repository:** Decides data source (Local DB via `Drift`).
5.  **State Change:** Data updates, BLoC emits new state, UI rebuilds.

## Appendix C: Quality Assurance
The app has undergone rigorous structure validation:
1.  **Linter:** `flutter_lints` is active to ensure code quality.
2.  **Unit Testing:** `flutter_test` is set up for logical verification.
3.  **Analysis:** Strong typing and null safety are enforced throughout the codebase.

## Appendix D: Quick User Guide
*   **Add a Word:** Tap the `+` button, type the English word, tap "Translate", then "Save".
*   **Hear Pronunciation:** Tap the speaker icon on any word or the Play button in the bottom bar.
*   **Test Yourself:** Tap a word card to open the Focus/Test mode.
*   **Customize:** Open the Drawer (top-left) → Settings to change colors or words-per-day.