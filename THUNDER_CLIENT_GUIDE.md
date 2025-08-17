# ⚡ Thunder Client Testing Guide

This guide shows you how to test the Forum Backend API using Thunder Client in VS Code.

## 🚀 Quick Setup

### 1. Install Thunder Client Extension
1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "Thunder Client"
4. Install the extension by Ranga Vadhineni

### 2. Import the Collection
1. Open Thunder Client in VS Code (click the Thunder Client icon in the sidebar)
2. Click on "Collections" tab
3. Click "Import" button
4. Select "Import from File"
5. Choose the `thunder-client-collection.json` file from your project
6. The "Forum Backend API" collection will be imported with all requests organized in folders

### 3. Start Your Server
Make sure your forum backend is running:
```bash
npm run dev
```

## 📋 Testing Workflow

### Step 1: Health Check
1. Open the "Forum Backend API" collection
2. Click on "🏥 Health Check" request
3. Click "Send" button
4. You should see: `{"status": "OK", "timestamp": "..."}`

### Step 2: Authentication Flow
1. **Login**: Click on "🔐 Authentication" → "Login User"
   - This uses the sample account: `john@example.com` / `Password123!`
   - Click "Send"
   - The JWT token will be automatically saved to environment variables
   
2. **Get Profile**: Click on "Get Current User Profile"
   - This will use the saved token automatically
   - Click "Send" to see your user profile

### Step 3: Categories and Setup
1. **Get Categories**: Click on "📂 Categories" → "Get All Categories"
   - Click "Send"
   - The first category ID will be automatically saved for later use

### Step 4: Thread Management
1. **View Threads**: Click on "📝 Threads" → "Get All Threads"
   - See all existing threads
   - The first thread ID will be saved automatically

2. **Create Thread**: Click on "Create New Thread"
   - Uses the saved category ID and auth token automatically
   - Click "Send" to create a new thread
   - The new thread ID will be saved

3. **View Single Thread**: Click on "Get Single Thread"
   - Uses the saved thread ID
   - Shows detailed thread with replies

### Step 5: Replies and Interactions
1. **Add Reply**: Click on "💬 Replies" → "Add Reply to Thread"
   - Uses saved thread ID and auth token
   - Click "Send" to add a reply

2. **Add Nested Reply**: Click on "Add Nested Reply"
   - Creates a reply to the previous reply
   - Demonstrates threaded conversations

### Step 6: Voting System
1. **Upvote**: Click on "👍 Voting" → "Upvote Thread"
   - Click "Send" to upvote the thread

2. **Downvote**: Click on "Downvote Thread"
   - Click "Send" to change vote to downvote

3. **Vote Stats**: Click on "Get Vote Statistics"
   - See detailed voting statistics

### Step 7: Advanced Features
1. **Search**: Click on "📝 Threads" → "Search Threads"
   - Searches for threads containing "javascript"

2. **Filter**: Click on "Filter Threads by Category"
   - Shows threads from a specific category

3. **Tags**: Click on "🏷️ Tags" → "Get Popular Tags"
   - See most used tags

4. **Users**: Click on "👤 Users" → "Search Users"
   - Search for users by username

## 🎯 Key Features

### Automatic Token Management
- Login once and the JWT token is saved automatically
- All authenticated requests use the saved token
- No need to copy/paste tokens manually

### Environment Variables
The collection uses these variables (automatically managed):
- `baseUrl`: http://localhost:5000/api
- `authToken`: JWT token from login
- `categoryId`: First category ID
- `threadId`: First thread ID
- `newThreadId`: Newly created thread ID
- `replyId`: Reply ID for nested replies

### Built-in Tests
Each request includes automatic tests that:
- Verify correct HTTP status codes
- Check response structure
- Save important IDs for later use

## 📊 Request Organization

### 🔐 Authentication
- Register New User
- Login User
- Get Current User Profile

### 📝 Threads
- Get All Threads
- Create New Thread
- Get Single Thread
- Search Threads
- Filter Threads by Category

### 💬 Replies
- Add Reply to Thread
- Add Nested Reply

### 👍 Voting
- Upvote Thread
- Downvote Thread
- Get Vote Statistics

### 📂 Categories
- Get All Categories

### 🏷️ Tags
- Get Popular Tags
- Search Tags

### 👤 Users
- Get User Profile by ID
- Update User Profile
- Search Users

## 🔧 Customizing Requests

### Modify Request Bodies
1. Click on any POST/PUT request
2. Go to the "Body" tab
3. Edit the JSON as needed
4. Click "Send"

### Add Query Parameters
1. Click on any GET request
2. Go to the "Query" tab
3. Enable/disable parameters or add new ones
4. Click "Send"

### Change Environment
1. Click on "Env" dropdown in Thunder Client
2. Select "Local Development" environment
3. Modify variables as needed

## 🧪 Testing Scenarios

### Complete User Journey
1. **Health Check** → Verify server is running
2. **Login** → Authenticate user
3. **Get Categories** → See available categories
4. **Create Thread** → Start a discussion
5. **Add Reply** → Participate in discussion
6. **Vote** → Show appreciation
7. **Search** → Find relevant content

### Error Testing
Try these to test error handling:
1. **Invalid Login**: Change email/password in login request
2. **Unauthorized Access**: Remove auth token from a protected request
3. **Invalid Data**: Send malformed JSON in create requests
4. **Not Found**: Use invalid IDs in URL parameters

### Performance Testing
1. **Pagination**: Test different page sizes in thread requests
2. **Search**: Try various search terms
3. **Filtering**: Combine multiple filters

## 🐛 Troubleshooting

### Common Issues

**1. "Connection refused" error**
- Make sure server is running: `npm run dev`
- Check server is on port 5000

**2. "401 Unauthorized" error**
- Run the "Login User" request first
- Check if token is saved in environment

**3. "Validation failed" error**
- Check request body format
- Ensure required fields are included

**4. "Not found" error**
- Make sure you've run setup requests first
- Check if IDs are saved in environment variables

### Debug Tips
1. **Check Environment**: Click "Env" to see saved variables
2. **View Response**: Check the response body for error details
3. **Test Status**: Green checkmarks indicate passing tests
4. **Console Logs**: Check VS Code output panel for Thunder Client logs

## 🎉 Success Indicators

You'll know everything is working when you see:
- ✅ Green status codes (200, 201)
- ✅ Green test checkmarks
- ✅ Proper JSON responses
- ✅ Automatic variable saving
- ✅ Seamless request flow

## 📚 Next Steps

After testing with Thunder Client:
1. **Frontend Integration**: Use these same endpoints in your React app
2. **API Documentation**: Reference the request/response formats
3. **Custom Features**: Add new endpoints following the same patterns
4. **Production Testing**: Change baseUrl to your deployed API

Happy testing! ⚡