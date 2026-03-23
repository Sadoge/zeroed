# Zeroed

Professional invoicing app for solo freelancers. Create, manage, and send invoices — all from your phone.

## Features

- **Invoicing** — Create and send professional PDF invoices
- **Client Management** — Store and manage client details
- **Dashboard** — Overview of your invoicing activity
- **Tax Export** — Export data for tax season
- **Reminders** — Payment reminder notifications
- **Settings** — Customize your business profile and preferences

## Tech Stack

- **Flutter** with Dart
- **Riverpod** for state management
- **Supabase** for backend and authentication
- **Auto Route** for navigation
- **Freezed** for immutable data models
- **RevenueCat** for subscriptions
- **Hive** for local storage

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (SDK ^3.9.2)
- [FVM](https://fvm.app/) (recommended)
- A Supabase project

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/zeroed.git
   cd zeroed
   ```

2. Install dependencies:
   ```bash
   fvm flutter pub get
   ```

3. Run code generation:
   ```bash
   fvm dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   fvm flutter run
   ```
