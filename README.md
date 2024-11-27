# Headache Diary

## Description
Headache Diary is a simple and intuitive web application designed to help users track their headache experiences over time. 
The app allows users to log the intensity of their headaches, change their username, and view statistics about their entries. 
It’s a helpful tool for anyone who wants to keep a record of their headache patterns and analyze trends.

The application features:
- A responsive design with breakpoints for mobile and tablet screens.
- Persistent data storage using local storage, so your entries remain even after restarting.
- A user-friendly navigation experience with multiple screens, including a homepage, headache entry screen, username change screen, and a statistics page.
- A deployed live version accessible online.

## Deployment URL
The application is deployed and can be accessed at:  
[https://SimoKind.github.io/headache_diary/](https://SimoKind.github.io/headache_diary/)

## Instructions
1. **Home Screen**  
   - When you open the app, you'll be greeted with your username and the most recent headache entry (if you already added one).
   - Two main buttons are available: 
     - **"Change your name"**: Navigate to the screen for changing your name.
     - **"Add a headache"**: Navigate to the screen for logging a new headache entry.
     - **"Statistics"**: View a summary of your headache entries.

2. **Adding a Headache**  
   - Select the intensity level of your headache from the options provided (Level 0, Level 1, Level 2, Level 3).
   - Click the "Save" button to record the entry. The data will be stored and visible on the home screen as the latest entry.

3. **Changing Username**  
   - Click the "Change your name" button on the home screen.
   - Enter a new username in the input field and click "Save" to update it.

4. **Viewing Statistics**  
   - Click the "Statistics" button to see the total number of entries and a breakdown of recorded headache levels.

## Features
- **Responsiveness**: The application adjusts its layout dynamically for different screen sizes, ensuring a smooth experience on both mobile and larger devices.
- **Persistent Storage**: Data is saved locally using Hive, so it remains even after closing and reopening the application.
- **Path Variables**: The statistics screen uses path variables to dynamically show data.
- **Easy Deployment**: The application is deployed using GitHub Pages, making it accessible from anywhere.

Enjoy using Headache Diary to manage your headache tracking efficiently!
