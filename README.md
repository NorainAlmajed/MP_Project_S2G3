# MP_Project_S2G3
    Repository for mobile programming project "Nourish Bahrain" (Donation Application), Section2 - Group3
    ios app that allow donors to make donations for verified NGOs.

##App Name: Nourish Bahrain

##GitHub Link:
    Noorain put the link plz

 ##Group members names and IDs:
    - Zahraa Hubail 202305220
    - Raghad Aleskafi 202302130
    - Fatima Alaiwi 202301089
    - Norain Almajed 202301660
    - Zainab Almahdi 202302211
    - Zainab Mahdi  202200277

##Main Features
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
    
        
        
        
        
        
##Extra Features:
    - Feature: Media Export Functionality
        - Developer: Zahraa Hubail
        - Tester: Raghad Aleskafi
    
    
##Design Changes:
    - Norain Almajed: 
    - Fatima Alaiwi: 
    - Zahraa Hubail: 
        - An upcoming pickup reminder notification was considered, but it was not implemented. In iOS, time-based notifications are not reliable when the app is closed unless background or cloud services are used. A proper implementation would require a backend solution like Firebase Cloud Functions, which was beyond the scope of this project. Since this was an extra feature and not a core requirement, we focused on the main functionality of the app.



##Libraries, Packages, External Code:
    - Firebase: Firebase is used as the main backend service for the application. It handles user authentication, stores NGO and donation data in Cloud Firestore, and supports real-time updates such as chat messages and donation status changes.
    
    - Firebase App Check: Firebase App Check is used to protect backend resources by ensuring that only requests coming from the authentic app can access Firebase services, improving security against unauthorized access.
    
    - Cloudinary: Cloudinary is used to upload, store, and retrieve images such as NGO profile images and donation photos. It allows efficient image handling without storing large files directly in Firebase.
    
    - Abseil: Abseil is a low-level C++ support library required internally by Firebase. It is not used directly in the app’s code but is included as a dependency to support Firebase functionality.
    
    - gRPC: gRPC is a networking framework used internally by Firebase to handle efficient communication between the app and Firebase servers. It operates in the background and is not accessed directly by the app.
    
    - Google Utilities provides helper functions used internally by Firebase and other Google libraries. It supports common tasks such as logging, data handling, and configuration.
    
    - Google Data Transport: Google Data Transport is used internally to manage the secure transmission of analytics and backend data between the app and Firebase services.
    
    - Google App Measurement: Google App Measurement supports Firebase Analytics by collecting usage data and events. This helps track how users interact with the application.
    
    - Google Ads On-Device Conversion: This library supports Google services internally. It is included as part of Firebase dependencies and is not directly used in the application logic.
    
    - GTMSessionFetcher: GTMSessionFetcher is used internally by Firebase to manage secure network requests, especially when communicating with backend services.
    
    - Interop for Google: Interop for Google allows different Google services and Firebase components to communicate smoothly within the app.
    
    - LevelDB: LevelDB is used internally by Firebase Firestore for local data caching and offline support, allowing the app to function even when internet connectivity is unstable.
    
    - Nanopb: Nanopb is a lightweight protocol buffer library used internally by Firebase for efficient data serialization.
    
    - Promises: Promises provides asynchronous programming support used internally by Firebase to handle background tasks such as network requests and database operations.
    
    - SwiftProtobuf: SwiftProtobuf is used internally by Firebase to encode and decode structured data efficiently when communicating with backend services.





##Description of the steps to setup the project:
    1- Clone the project repository from GitHub and open it in Xcode on macOS.
    2- Allow Xcode to automatically install all required Swift Package dependencies.
    3- Add the Firebase configuration file (GoogleService-Info.plist) to the project.
    4- Enable Firebase services such as Authentication and Cloud Firestore in the Firebase Console.
    5- Fetch data from Cloud Firestore to load approved NGOs, donations, and chat data dynamically within the app.
    6- Run the application using an iOS Simulator or a physical device.



##Simulators used for testing the application:
    - iPhone: iPhone 16 Pro
    - iPad: iPad (A16)





##User Login Credentials:
- Admin
    - Email: admin@nourish.com
    - Password: admin@123
    
- Donor ()
    - Email:
    - Password:
- Donor ()
    - Email:
    - Password:
- NGO ()
    - Email: 
    - Password:
- NGO ()
    - Email:
    - Password:
