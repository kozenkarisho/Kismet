# 🌌 Kismet: AI-Powered Mind Vault

**Save links. Let AI organize them. Rediscover your digital footprint.**

Kismet is an offline-first, AI-powered link organizer designed to be your personal "Mind Vault." Instead of letting bookmarks gather dust in forgotten folders, Kismet uses an AI "Automated Librarian" to instantly summarize, tag, and organize your saved links into intuitive **Mind Spaces**.

---

## ✨ Key Features

- 🧠 **AI-Powered Organization:** Paste a URL, and Kismet's AI (powered by Google Gemini) automatically generates a concise summary and assigns relevant tags.
-  **Offline-First Architecture:** Built with **Isar**, your Mind Vault lives entirely on your device. Fast, private, and accessible without an internet connection.
- 🎨 **Bento-Style Modern UI:** A sleek, dark-themed interface with neon lime accents, featuring a custom programmatic logo and modern grid layouts.
- 🔄 **Rediscover Feature:** The "Dive In" card surfaces forgotten links from weeks ago, encouraging you to actually consume the content you save.
- 🏷️ **Mind Spaces:** Automatically filtered categories based on AI-generated tags (e.g., Movies, Recipes, Tech).

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **Local Database:** Isar (Offline-first, blazing fast)
- **AI Integration:** Google Generative AI (Gemini API)
- **Environment Management:** flutter_dotenv
- **Typography:** Google Fonts (Inter)

---

## 🏗️ Architecture

Kismet is built on a strict separation of concerns:
1. **The Brain (Services):** The `DatabaseService` handles all Isar transactions, while the AI service acts as the "Automated Librarian," processing URLs and returning structured data.
2. **The Vault (Models):** The `Memory` model defines the core data structure, utilizing Isar's code generation for type-safe, high-performance database queries.
3. **The UI (Screens/Widgets):** A modular, widget-based UI that separates the Home Screen, Mind Vault, and input mechanisms for a clean user experience.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest stable version)
- A Google Gemini API Key (Get one for free at [Google AI Studio](https://aistudio.google.com/))

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kozenkarisho/Kismet.git
   cd Kismet
