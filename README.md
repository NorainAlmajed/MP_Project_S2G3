MP_Project_S2G3
Repository for the Mobile Programming Project – “Nourish Bahrain”
Section 2 – Group 3
Nourish Bahrain is an iOS donation application that allows donors to make food donations to verified NGOs through a secure and user-friendly platform.
App Name
Nourish Bahrain
GitHub Link
🔗 To be added by Norain Almajed
Group Members
Name    Student ID
Zahraa Hubail    202305220
Raghad Aleskafi    202302130
Fatima Alaiwi    202301089
Norain Almajed    202301660
Zainab Almahdi    202302211
Zainab Mahdi    202200277
Main Features
Feature No.    Feature Name    Developer    Tester
1    User Registration, Authentication, and Profile    Zainab Almahdi    Norain Almajed
2    Settings Management & Account Control    Zainab Almahdi    Zahraa Hubail
3    Customize Dashboard    Fatima Alaiwi    Raghad Aleskafi
4    Impact Tracking    Fatima Alaiwi    Zainab Saeed
5    Admin User Controls (CRUD) and NGO Approvals    Norain Almajed    Zahraa Hubail
6    Real-Time Notifications    Zahraa Hubail    Raghad Aleskafi
7    Donation and Status Management    Zahraa Hubail    Zainab Saeed
8    NGO Discovery    Raghad Aleskafi    Norain Almajed
9    Food Donation Creation    Raghad Aleskafi    Fatima Alaiwi
10    Pickup Scheduling & Recurring Donation Schedules    Norain Almajed    Fatima Alaiwi
11    Search and Filter Tools    Zainab Mahdi    Zainab Almahdi
12    Chat / Support Chat    Zainab Mahdi    Zahraa Hubail
Extra Features
Feature    Developer    Tester    Description
Media Export Functionality    Zahraa Hubail    Raghad Aleskafi    Allows exporting media content related to donations for sharing or record purposes.
Design Changes
Team Member(s)    Design Change    Description
Norain Almajed    Admin User Management UI    The admin interface was redesigned to use a table view instead of a collection view for better readability. Trailing swipe actions were implemented instead of buttons to allow quicker and cleaner CRUD operations.
Fatima Alaiwi    Dashboard Spotlight Section    The donor and NGO dashboards initially included a spotlight section displaying donation images with related text or statistics. This feature was removed during implementation due to the need for frequent updates and additional data handling, which increased complexity without contributing to core functionality. The dashboard was simplified to focus on essential donation workflows.
Zahraa Hubail    Pickup Reminder Notifications    A pickup reminder notification feature was considered but not implemented. Reliable time-based notifications in iOS require background services or cloud-based triggers such as Firebase Cloud Functions, which were beyond the project scope. The focus remained on core features.
All Team Members    Logo Enhancement    The application logo was refined collaboratively to improve visual clarity and consistency. Minor adjustments were made to colors, alignment, and styling to create a more professional appearance while preserving the original design concept.
Libraries, Packages, and External Code
Library / Package    Usage
Firebase    Used as the main backend service for authentication, data storage (Cloud Firestore), and real-time features such as chat and donation status updates.
Firebase App Check    Protects backend resources by ensuring requests originate from the authentic application.
Cloudinary    Used to upload, store, and retrieve images such as NGO logos and donation photos.
Abseil    Internal dependency required by Firebase to support its core functionality.
gRPC    Used internally by Firebase for efficient client–server communication.
Google Utilities    Provides helper functions used internally by Firebase and Google services.
Google Data Transport    Handles secure data transmission between the app and Firebase services.
Google App Measurement    Supports Firebase Analytics by tracking user interactions.
Google Ads On-Device Conversion    Included as part of Firebase dependencies; not directly used in application logic.
GTMSessionFetcher    Manages secure network requests internally for Firebase services.
Interop for Google    Enables interoperability between Google and Firebase components.
LevelDB    Provides offline data caching support for Cloud Firestore.
Nanopb    Lightweight protocol buffer library used internally by Firebase.
Promises    Supports asynchronous operations within Firebase services.
SwiftProtobuf    Used internally by Firebase for efficient data encoding and decoding.
Project Setup Steps
Clone the project repository from GitHub and open it in Xcode on macOS.
Allow Xcode to automatically resolve and install all Swift Package dependencies.
Add the Firebase configuration file (GoogleService-Info.plist) to the project.
Enable Firebase services such as Authentication and Cloud Firestore in the Firebase Console.
Fetch data from Cloud Firestore to load approved NGOs, donations, and chat data dynamically.
Run the application using an iOS Simulator or a physical device.
Simulators Used for Testing
Device Type    Model
iPhone    iPhone 16 Pro
iPad    iPad (A16)
User Login Credentials (For Testing Only)
Role    Email    Password
Admin    admin@nourish.com    admin@123
Donor (Fatima)    fatima@hotmail.com    12341234
Donor (Zahraa Hubail)    zahraa@gmail.com    zahraa
NGO (Raghad Aleskafi Charity)    raghad@charity.com    12341234
NGO (Karrana Charity Society)    contact@karranacharity.org    12341234
