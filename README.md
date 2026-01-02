<h1>MP_Project_S2G3</h1>

<p>
Repository for mobile programming project "Nourish Bahrain" (Donation Application), Section2 - Group3<br>
ios app that allow donors to make donations for verified NGOs.
</p>

<h2>App Name</h2>
<p>Nourish Bahrain</p>

<h2>GitHub Link</h2>
<p>(https://github.com/NorainAlmajed/MP_Project_S2G3.git)</p>

<h2>Group members names and IDs</h2>
<table border="1" cellpadding="6" cellspacing="0">
  <tr>
    <th>Name</th>
    <th>ID</th>
  </tr>
  <tr><td>Zahraa Hubail</td><td>202305220</td></tr>
  <tr><td>Raghad Aleskafi</td><td>202302130</td></tr>
  <tr><td>Fatima Alaiwi</td><td>202301089</td></tr>
  <tr><td>Norain Almajed</td><td>202301660</td></tr>
  <tr><td>Zainab Almahdi</td><td>202302211</td></tr>
  <tr><td>Zainab Mahdi</td><td>202200277</td></tr>
</table>

<h2>Main Features</h2>
<table border="1" cellpadding="6" cellspacing="0">
  <tr>
    <th>Feature No.</th>
    <th>Feature Name</th>
    <th>Developer</th>
    <th>Tester</th>
  </tr>
  <tr><td>1</td><td>User Registration, Authentication, and Profile</td><td>Zainab Almahdi</td><td>Norain Almajed</td></tr>
  <tr><td>2</td><td>Settings Management & Account Control</td><td>Zainab Almahdi</td><td>Zahraa Hubail</td></tr>
  <tr><td>3</td><td>Customize Dashboard</td><td>Fatima Alaiwi</td><td>Raghad Aleskafi</td></tr>
  <tr><td>4</td><td>Impact Tracking</td><td>Fatima Alaiwi</td><td>Zainab Saeed</td></tr>
  <tr><td>5</td><td>Admin User Controls (CRUD) and NGO Approvals</td><td>Norain Almajed</td><td>Zainab Almahdi</td></tr>
  <tr><td>6</td><td>Real-Time Notifications</td><td>Zahraa Hubail</td><td>Raghad Aleskafi</td></tr>
  <tr><td>7</td><td>Donation and Status Management</td><td>Zahraa Hubail</td><td>Zainab Saeed</td></tr>
  <tr><td>8</td><td>NGO Discovery</td><td>Raghad Aleskafi</td><td>Norain Almajed</td></tr>
  <tr><td>9</td><td>Food Donation Creation</td><td>Raghad Aleskafi</td><td>Fatima Alaiwi</td></tr>
  <tr><td>10</td><td>Pickup Scheduling & Recurring Donation Schedules</td><td>Norain Almajed</td><td>Fatima Alaiwi</td></tr>
  <tr><td>11</td><td>Search and Filter Tools</td><td>Zainab Mahdi</td><td>Zainab Almahdi</td></tr>
  <tr><td>12</td><td>Chat / Support Chat</td><td>Zainab Mahdi</td><td>Zahraa Hubail</td></tr>
</table>

<h2>Extra Features</h2>
<table border="1" cellpadding="6" cellspacing="0">
  <tr>
    <th>Feature</th>
    <th>Developer</th>
    <th>Tester</th>
  </tr>
  <tr>
    <td>Media Export Functionality</td>
    <td>Zahraa Hubail</td>
    <td>Raghad Aleskafi</td>
  </tr>
</table>

<h2>Design Changes</h2>

<h3>Zainab Almahdi</h3>

<ul>
  <li>
    <strong>User Registration, Authentication, and Profile</strong>
    <ul>
      <li>
        A Confirm Password field was added to reduce password entry errors during
        registration and credential updates, improving validation reliability and overall user
        experience.
      </li>
      <li>
        Multi-Factor Authentication (MFA) and its associated storyboard scenes were
        removed to keep the authentication flow simple and aligned with the current project
        scope, while reducing navigation and state-management complexity in both the
        storyboard and Swift codebase.
      </li>
    </ul>
  </li>

  <li>
    <strong>Settings Management & Account Control</strong>
    <ul>
      <li>
        Selecting the Security Settings cell now navigates directly to the Change
        Email/Password screen, minimizing unnecessary intermediary views and improving
        task efficiency in line with iOS navigation best practices.
      </li>
      <li>
        Advanced account management features (last login details, active sessions,
        device-specific logout, and local data/cache management) were removed to avoid UI
        clutter and keep the storyboard structure lightweight, focusing on essential and
        commonly used security actions.
      </li>
    </ul>
  </li>
</ul>


<h3>Norain Almajed</h3>
<ul>
  <li>Admin controls and user management(CRUD)
    <ul>
      <li>used a table view instead of a collection view to display users.</li>
      <li>used trailing swipe actions instead of buttons for quick actions.</li>
    </ul>
  </li>
</ul>

<h3>Fatima Alaiwi</h3>
<p>
NGO and Donor Dashboard Spotlight Section<br>
Initially, the donor and NGO dashboards included a spotlight section that displayed images of recent donations, where selecting an image would reveal descriptive text or related statistics. During implementation, this feature was excluded as it required frequent content updates and additional data management, which would increase system complexity without providing essential functionality. Since the spotlight section was not a core requirement and did not directly support the main donation workflow, the design was simplified to focus on core features such as browsing NGOs, managing donations, and tracking donation status.
</p>

<h3>Zahraa Hubail</h3>
<p>
An upcoming pickup reminder notification was considered, but it was not implemented. In iOS, time-based notifications are not reliable when the app is closed unless background or cloud services are used. A proper implementation would require a backend solution like Firebase Cloud Functions, which was beyond the scope of this project. Since this was an extra feature and not a core requirement, we focused on the main functionality of the app.
</p>

<h3>Zainab Mahdi</h3>
<p>
The send button was removed since sending messages through the keyboard follows common chat interaction conventions and helps maintain a clean, focused layout. To support this simplified design, The unread badge was not included to align with a simplified, minimal design approach that prioritizes clarity and readability over additional notification indicators. An admin profile photo was added to clearly identify official support communication, resulting in a more intuitive chat experience.
</p>

<h3>All</h3>
<p>
The application logo was refined as a team to improve its visual clarity and overall appearance. Minor enhancements were made to colors, alignment, and consistency to better match the app’s theme and provide a more professional and polished look, without changing the original concept or identity of the logo.
</p>

<h2>Libraries, Packages, External Code</h2>
<table border="1" cellpadding="6" cellspacing="0">
  <tr><th>Library / Package</th><th>Description</th></tr>
  <tr><td>Firebase</td><td>Firebase is used as the main backend service for the application. It handles user authentication, stores NGO and donation data in Cloud Firestore, and supports real-time updates such as chat messages and donation status changes.</td></tr>
  <tr><td>Firebase App Check</td><td>Firebase App Check is used to protect backend resources by ensuring that only requests coming from the authentic app can access Firebase services, improving security against unauthorized access.</td></tr>
  <tr><td>Cloudinary</td><td>Cloudinary is used to upload, store, and retrieve images such as NGO profile images and donation photos. It allows efficient image handling without storing large files directly in Firebase.</td></tr>
  <tr><td>Abseil</td><td>Abseil is a low-level C++ support library required internally by Firebase.</td></tr>
  <tr><td>gRPC</td><td>gRPC is used internally by Firebase to handle efficient communication.</td></tr>
  <tr><td>Google Utilities</td><td>Provides helper functions used internally by Firebase and Google libraries.</td></tr>
  <tr><td>DGCharts</td><td>Used to display donation trends through simple and interactive line charts on the dashboard..</td></tr>
  <tr><td>Google Data Transport</td><td>Manages secure transmission of analytics and backend data.</td></tr>
  <tr><td>Google App Measurement</td><td>Supports Firebase Analytics.</td></tr>
  <tr><td>Google Ads On-Device Conversion</td><td>Included as part of Firebase dependencies.</td></tr>
  <tr><td>GTMSessionFetcher</td><td>Manages secure network requests.</td></tr>
  <tr><td>Interop for Google</td><td>Allows communication between Google services.</td></tr>
  <tr><td>LevelDB</td><td>Used for local data caching and offline support.</td></tr>
  <tr><td>Nanopb</td><td>Lightweight protocol buffer library.</td></tr>
  <tr><td>Promises</td><td>Supports asynchronous programming.</td></tr>
  <tr><td>SwiftProtobuf</td><td>Encodes and decodes structured data.</td></tr>
</table>

<h2>Description of the steps to setup the project</h2>
<ol>
  <li>Clone the project repository from GitHub and open it in Xcode on macOS.</li>
  <li>Allow Xcode to automatically install all required Swift Package dependencies.</li>
  <li>Add the Firebase configuration file (GoogleService-Info.plist) to the project.</li>
  <li>Enable Firebase services such as Authentication and Cloud Firestore in the Firebase Console.</li>
  <li>Fetch data from Cloud Firestore to load approved NGOs, donations, and chat data dynamically within the app.</li>
  <li>Run the application using an iOS Simulator or a physical device.</li>
</ol>

<h2>Simulators used for testing the application</h2>
<table border="1" cellpadding="6" cellspacing="0">
  <tr><th>Device</th><th>Model</th></tr>
  <tr><td>iPhone</td><td>iPhone 16 Pro</td></tr>
  <tr><td>iPad</td><td>iPad (A16)</td></tr>
</table>

<h2>User Login Credentials</h2>

<h3>Admin</h3>
<p>Email: admin@nourish.com<br>Password: admin@123</p>

<h3>Donor (Fatima)</h3>
<p>Email: fatima@hotmail.com<br>Password: 12341234</p>

<h3>Donor (Zahraa Hubail)</h3>
<p>Email: zahraa@gmail.com<br>Password: zahraa</p>

<h3>NGO (Raghad Aleskafi Charity)</h3>
<p>Email: contact@karranacharity.org<br>Password: 12341234</p>

<h3>NGO (Karrana Charity Society)</h3>
<p>Email: raghad@chrity.com<br>Password: 12341234</p>
