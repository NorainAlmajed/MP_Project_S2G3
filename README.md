<h1><b>MP_Project_S2G3</b></h1>

<p><b>Repository for the Mobile Programming Project – “Nourish Bahrain”</b><br>
<b>Section 2 – Group 3</b></p>

<p>Nourish Bahrain is an iOS donation application that allows donors to make food donations to verified NGOs through a secure and user-friendly platform.</p>

<h2><b>App Name</b></h2>
<p><b>Nourish Bahrain</b></p>

<h2><b>GitHub Link</b></h2>
<p>To be added by Norain Almajed</p>

<h2><b>Group Members</b></h2>
<table>
  <tr><th>Name</th><th>Student ID</th></tr>
  <tr><td>Zahraa Hubail</td><td>202305220</td></tr>
  <tr><td>Raghad Aleskafi</td><td>202302130</td></tr>
  <tr><td>Fatima Alaiwi</td><td>202301089</td></tr>
  <tr><td>Norain Almajed</td><td>202301660</td></tr>
  <tr><td>Zainab Almahdi</td><td>202302211</td></tr>
  <tr><td>Zainab Mahdi</td><td>202200277</td></tr>
</table>

<h2><b>Main Features</b></h2>
<table>
  <tr><th>Feature No.</th><th>Feature Name</th><th>Developer</th><th>Tester</th></tr>
  <tr><td>1</td><td>User Registration, Authentication, and Profile</td><td>Zainab Almahdi</td><td>Norain Almajed</td></tr>
  <tr><td>2</td><td>Settings Management &amp; Account Control</td><td>Zainab Almahdi</td><td>Zahraa Hubail</td></tr>
  <tr><td>3</td><td>Customize Dashboard</td><td>Fatima Alaiwi</td><td>Raghad Aleskafi</td></tr>
  <tr><td>4</td><td>Impact Tracking</td><td>Fatima Alaiwi</td><td>Zainab Saeed</td></tr>
  <tr><td>5</td><td>Admin User Controls (CRUD) and NGO Approvals</td><td>Norain Almajed</td><td>Zahraa Hubail</td></tr>
  <tr><td>6</td><td>Real-Time Notifications</td><td>Zahraa Hubail</td><td>Raghad Aleskafi</td></tr>
  <tr><td>7</td><td>Donation and Status Management</td><td>Zahraa Hubail</td><td>Zainab Saeed</td></tr>
  <tr><td>8</td><td>NGO Discovery</td><td>Raghad Aleskafi</td><td>Norain Almajed</td></tr>
  <tr><td>9</td><td>Food Donation Creation</td><td>Raghad Aleskafi</td><td>Fatima Alaiwi</td></tr>
  <tr><td>10</td><td>Pickup Scheduling &amp; Recurring Donation Schedules</td><td>Norain Almajed</td><td>Fatima Alaiwi</td></tr>
  <tr><td>11</td><td>Search and Filter Tools</td><td>Zainab Mahdi</td><td>Zainab Almahdi</td></tr>
  <tr><td>12</td><td>Chat / Support Chat</td><td>Zainab Mahdi</td><td>Zahraa Hubail</td></tr>
</table>

<h2><b>Extra Features</b></h2>
<table>
  <tr><th>Feature</th><th>Developer</th><th>Tester</th><th>Description</th></tr>
  <tr><td>Media Export Functionality</td><td>Zahraa Hubail</td><td>Raghad Aleskafi</td><td>Allows exporting media related to donations for sharing or record keeping.</td></tr>
</table>

<h2><b>Design Changes</b></h2>
<table>
  <tr><th>Team Member(s)</th><th>Design Change</th><th>Description</th></tr>
  <tr><td><b>Norain Almajed</b></td><td>Admin User Management UI</td><td>Replaced collection view with table view and added trailing swipe actions for faster CRUD operations.</td></tr>
  <tr><td><b>Fatima Alaiwi</b></td><td>Dashboard Spotlight Section</td><td>The spotlight section was removed due to frequent content updates and increased complexity; the dashboard was simplified to focus on core donation workflows.</td></tr>
  <tr><td><b>Zahraa Hubail</b></td><td>Pickup Reminder Notifications</td><td>Not implemented because reliable scheduling requires background or cloud triggers (e.g., Cloud Functions), which were beyond the project scope.</td></tr>
  <tr><td><b>All Members</b></td><td>Logo Enhancement</td><td>Minor refinements were made to colors and alignment to improve clarity and consistency without changing the original identity.</td></tr>
</table>

<h2><b>Libraries, Packages, and External Code</b></h2>
<table>
  <tr><th>Library / Package</th><th>Usage</th></tr>
  <tr><td>Firebase</td><td>Authentication, Firestore database, and real-time features such as chat and donation status updates.</td></tr>
  <tr><td>Firebase App Check</td><td>Protects backend resources by ensuring only valid app requests access Firebase services.</td></tr>
  <tr><td>Cloudinary</td><td>Uploads, stores, and retrieves images such as NGO logos and donation photos.</td></tr>
  <tr><td>Supporting Dependencies</td><td>Abseil, gRPC, Google Utilities, LevelDB, SwiftProtobuf, and others required internally by Firebase.</td></tr>
</table>

<h2><b>Project Setup Steps</b></h2>
<ol>
  <li>Clone the repository and open it in Xcode on macOS.</li>
  <li>Allow Xcode to resolve and install Swift Package dependencies.</li>
  <li>Add <code>GoogleService-Info.plist</code> to the project.</li>
  <li>Enable Firebase Authentication and Cloud Firestore in Firebase Console.</li>
  <li>Fetch data from Firestore to load approved NGOs, donations, and chat data.</li>
  <li>Run the app using an iOS Simulator or a physical device.</li>
</ol>

<h2><b>Simulators Used for Testing</b></h2>
<table>
  <tr><th>Device Type</th><th>Model</th></tr>
  <tr><td>iPhone</td><td>iPhone 16 Pro</td></tr>
  <tr><td>iPad</td><td>iPad (A16)</td></tr>
</table>

<h2><b>User Login Credentials (For Testing Only)</b></h2>
<table>
  <tr><th>Role</th><th>Email</th><th>Password</th></tr>
  <tr><td>Admin</td><td>admin@nourish.com</td><td>admin@123</td></tr>
  <tr><td>Donor (Fatima)</td><td>fatima@hotmail.com</td><td>12341234</td></tr>
  <tr><td>Donor (Zahraa Hubail)</td><td>zahraa@gmail.com</td><td>zahraa</td></tr>
  <tr><td>NGO (Raghad Aleskafi Charity)</td><td>raghad@charity.com</td><td>12341234</td></tr>
  <tr><td>NGO (Karrana Charity Society)</td><td>contact@karranacharity.org</td><td>12341234</td></tr>
</table>
