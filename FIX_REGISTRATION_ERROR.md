# How to Fix "Missing or Insufficient Permissions" Error

The error you are seeing during registration is caused by **Firebase Firestore Security Rules**. By default, Firestore may start in "locked mode" or "production mode" which creates a rule that **denies all writes** to the database to prevent unauthorized access.

Since your app is trying to save the user's phone number and email to the `users` collection, this write operation is being blocked.

## Solution

1.  Go to the [Firebase Console](https://console.firebase.google.com/).
2.  Select your project **worthit-58ab4**.
3.  In the left sidebar, click on **Build** -> **Firestore Database**.
4.  Click on the **Rules** tab at the top.
5.  You will likely see rules that look like this:
    ```
    allow read, write: if false;
    ```
    OR
    ```
    allow read, write: if request.time < timestamp.date(2023-12-30);
    ```

6.  **Replace** the entire rules content with the following **Development Rules** (safe for testing):

    ```firestore
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        
        // Allow users to read/write their OWN data
        match /users/{userId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }

        // Allow anyone to read products (for the shop)
        match /products/{productId} {
          allow read: if true;
          allow write: if request.auth != null; // Only logged in users can write (or restrict to admin)
        }
        
        // Default rule: Allow authenticated users to read/write everything else (Use with caution in production)
        match /{document=**} {
          allow read, write: if request.auth != null;
        }
      }
    }
    ```

7.  Click **Publish**.

## Why this works
These rules allow:
-   Any user who is **logged in** (which happens right after `createUserWithEmailAndPassword`) to write to the database.
-   Specifically, it allows a user with ID `XYZ` to write to `/users/XYZ`.

After publishing these rules, try registering again in the app.
