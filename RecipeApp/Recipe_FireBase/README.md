# Recipe Saver

The Recipe Saver App is an iOS application built using the SwiftUI framework and following the MVVM architecture pattern.
It utilizes Firebase Authentication and Firebase Database for user authentication and data storage, respectively.
The app leverages the async-await concurrency model for efficient task execution.

# Features
- User Authentication: The app provides seamless user authentication using Firebase Authentication, ensuring secure access to saved recipes.
- Recipe Management: Users can save and organize their favorite recipes within the app, making it easy to find and reference them later.
- Dynamic User Interface: The app's user interface is built with SwiftUI, offering a highly responsive and intuitive experience.
- MVVM Architecture: The app follows the Model-View-ViewModel (MVVM) architecture pattern, promoting code organization, testability, and maintainability.
- Firebase Integration: Firebase Database is used to store recipe data, allowing for real-time updates and synchronization across devices.
- Async-Await Concurrency: The app utilizes async-await concurrency to execute time-consuming tasks efficiently without blocking the main thread, resulting in a smooth user interface.

# Usage
- Launch the app on your iOS device.
- If you are a new user, sign up for an account using the provided authentication options.
- Once logged in, you will be directed to the main screen.
- You can search for specific recipes using the search bar.
- To view favorite recipes, go to the "Favorites" section.
- To add a new recipe go to the "New" Section
- To update your account settings, go to the "Settings" section.

# Acknowledgements
- SwiftUI: Apple's declarative framework for building user interfaces.
- Firebase: Google's mobile and web application development platform.
- Async-Await Concurrency: Swift's powerful concurrency model for asynchronous programming.

# App Structure
- Recipe
  - Views
    - Main
        - RootView
        - TabBar
        - HomeViewView
        - CategoriesView
        - NewView
        - FavoritesView
        - SettingsView
        - AuthenticationView
        - Authentication
            - SubView
                - SignInEmailView
                - SignInEmailViewModel
                - SignUpEmailView
                - SignUpEmailViewModel
        - Detail
            - RecipeView
            - CategoryView
            - RecipeForm
            
        - Components
            - RecipeCard
            - CategoryCard
            - RecipeList
            - RecipeCardViewBuilder
            - RecipeViewViewBuilder
            
  - View Models
    - RecipesViewModel
    - AuthenticationViewModel
    - SettingsViewModel
    
  - Models
    - RecipeModel
    
  - Authentication
    - AuthenticationManager
    - SignInWithGoogleHelper
    - SignInWithAppleHelper
    
  - Resources
    - Bundle-Decodable
    - Utilities
    - DocumentsDirectory
    - Color-Theme
    
  - FireStore
    - UserManager
    - RecipeManager    
    
# Contact

For any inquiries or feedback, please contact:

Abdelaziz
Email: azozsalah19@gmail.com    
