# How to Add This Project to GitHub

## Step 1: Initialize Git Repository

Run these commands in your project directory:

```bash
cd /Users/malakasanjeewa/vehicle-part-app

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Vehicle Parts App with feature-first architecture"
```

## Step 2: Create GitHub Repository

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the **"+"** icon in the top right corner
3. Select **"New repository"**
4. Fill in the details:
   - **Repository name**: `vehicle-part-app` (or your preferred name)
   - **Description**: "Flutter mobile app for vehicle parts management"
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click **"Create repository"**

## Step 3: Connect and Push to GitHub

After creating the repository, GitHub will show you commands. Use these:

```bash
# Add the remote repository (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/vehicle-part-app.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

## Alternative: Using SSH (if you have SSH keys set up)

```bash
git remote add origin git@github.com:YOUR_USERNAME/vehicle-part-app.git
git branch -M main
git push -u origin main
```

## What's Already Excluded (.gitignore)

The following files/folders are already excluded from git:
- `.env` files (environment variables)
- Build artifacts (`/build/`, `/android/app/debug`, etc.)
- IDE files (`.idea/`, `*.iml`)
- Flutter generated files (`.dart_tool/`, `.flutter-plugins`)
- iOS/Android build files

## Important Notes

⚠️ **Before pushing, make sure:**
- Your `.env` file is NOT committed (it's in .gitignore)
- No sensitive API keys or credentials are in the code
- PayHere credentials in `payhere_service.dart` should be removed or use environment variables

## Next Steps After Pushing

1. Add a README.md with project description
2. Add license file if needed
3. Set up GitHub Actions for CI/CD (optional)
4. Add collaborators if working in a team

