# 🧪 Forum Backend Testing Guide

This guide provides step-by-step instructions to test the forum backend API manually using simple commands.

## 🚀 Quick Start

### 1. Setup and Start Server
```bash
# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Seed database with sample data
node utils/seedData.js

# Start the server
npm run dev
```

The server will start on `http://localhost:5000`

## 📋 Sample Test Data

After seeding, you'll have these accounts:
- **Admin**: `admin@forum.com` / `Admin123!`
- **User 1**: `john@example.com` / `Password123!`
- **User 2**: `sarah@example.com` / `Password123!`
- **User 3**: `mike@example.com` / `Password123!`

## 🔧 Testing Methods

Choose your preferred method:

### Method 1: PowerShell (Windows)
### Method 2: curl (Cross-platform)
### Method 3: Postman/Insomnia (GUI)

---

## 🧪 Test Cases

### 1. Health Check
**Test if server is running**

**PowerShell:**
```powershell
Invoke-RestMethod -Uri "http://localhost:5000/api/health" -Method GET
```

**curl:**
```bash
curl http://localhost:5000/api/health
```

**Expected Response:**
```json
{
  "status": "OK",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

---

### 2. User Registration
**Create a new user account**

**PowerShell:**
```powershell
$body = @{
    username = "testuser"
    email = "test@example.com"
    password = "TestPass123!"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/auth/register" -Method POST -Body $body -ContentType "application/json"
```

**curl:**
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "TestPass123!"
  }'
```

**Expected Response:**
```json
{
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "...",
    "username": "testuser",
    "email": "test@example.com"
  }
}
```

---

### 3. User Login
**Login and get JWT token**

**PowerShell:**
```powershell
$loginBody = @{
    email = "john@example.com"
    password = "Password123!"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
$token = $response.token
Write-Host "Token: $token"
```

**curl:**
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "Password123!"
  }'
```

**Save the token from response for authenticated requests!**

---

### 4. Get Categories
**Retrieve all forum categories**

**PowerShell:**
```powershell
Invoke-RestMethod -Uri "http://localhost:5000/api/categories" -Method GET
```

**curl:**
```bash
curl http://localhost:5000/api/categories
```

**Expected Response:**
```json
{
  "categories": [
    {
      "id": "...",
      "name": "Programming",
      "description": "General programming discussions",
      "color": "#007bff",
      "threadCount": 1
    }
  ]
}
```

---

### 5. Get All Threads
**Retrieve forum threads with filtering**

**PowerShell:**
```powershell
# Get all threads
Invoke-RestMethod -Uri "http://localhost:5000/api/threads" -Method GET

# Get threads with filtering
Invoke-RestMethod -Uri "http://localhost:5000/api/threads?sort=popular&limit=5" -Method GET
```

**curl:**
```bash
# Get all threads
curl http://localhost:5000/api/threads

# Get threads with filtering
curl "http://localhost:5000/api/threads?sort=popular&limit=5"
```

---

### 6. Create New Thread
**Create a discussion thread (requires authentication)**

**PowerShell:**
```powershell
# First, get a category ID
$categories = Invoke-RestMethod -Uri "http://localhost:5000/api/categories" -Method GET
$categoryId = $categories.categories[0].id

# Create thread
$threadBody = @{
    title = "My First Test Thread"
    content = "This is a test thread created via API. It demonstrates the thread creation functionality."
    category = $categoryId
    tags = @("test", "api", "demo")
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

Invoke-RestMethod -Uri "http://localhost:5000/api/threads" -Method POST -Body $threadBody -Headers $headers
```

**curl:**
```bash
# Replace YOUR_TOKEN with actual token from login
curl -X POST http://localhost:5000/api/threads \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "My First Test Thread",
    "content": "This is a test thread created via API.",
    "category": "CATEGORY_ID_HERE",
    "tags": ["test", "api", "demo"]
  }'
```

---

### 7. Get Single Thread
**Retrieve a specific thread with replies**

**PowerShell:**
```powershell
# Get threads first to find an ID
$threads = Invoke-RestMethod -Uri "http://localhost:5000/api/threads" -Method GET
$threadId = $threads.threads[0].id

# Get specific thread
Invoke-RestMethod -Uri "http://localhost:5000/api/threads/$threadId" -Method GET
```

**curl:**
```bash
# Replace THREAD_ID with actual thread ID
curl http://localhost:5000/api/threads/THREAD_ID
```

---

### 8. Add Reply to Thread
**Add a reply to a discussion thread**

**PowerShell:**
```powershell
$replyBody = @{
    content = "This is my reply to the thread. Great discussion!"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/replies/$threadId" -Method POST -Body $replyBody -Headers $headers
```

**curl:**
```bash
curl -X POST http://localhost:5000/api/replies/THREAD_ID \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "This is my reply to the thread. Great discussion!"
  }'
```

---

### 9. Vote on Thread
**Upvote or downvote a thread**

**PowerShell:**
```powershell
# Upvote
$voteBody = @{
    type = "upvote"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/votes/threads/$threadId" -Method POST -Body $voteBody -Headers $headers

# Downvote
$voteBody = @{
    type = "downvote"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/votes/threads/$threadId" -Method POST -Body $voteBody -Headers $headers
```

**curl:**
```bash
# Upvote
curl -X POST http://localhost:5000/api/votes/threads/THREAD_ID \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type": "upvote"}'

# Downvote
curl -X POST http://localhost:5000/api/votes/threads/THREAD_ID \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type": "downvote"}'
```

---

### 10. Get User Profile
**Retrieve current user profile**

**PowerShell:**
```powershell
Invoke-RestMethod -Uri "http://localhost:5000/api/auth/me" -Method GET -Headers $headers
```

**curl:**
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:5000/api/auth/me
```

---

### 11. Search and Filter
**Advanced search and filtering**

**PowerShell:**
```powershell
# Search threads by content
Invoke-RestMethod -Uri "http://localhost:5000/api/threads?search=javascript" -Method GET

# Filter by category
Invoke-RestMethod -Uri "http://localhost:5000/api/threads?category=$categoryId" -Method GET

# Get popular tags
Invoke-RestMethod -Uri "http://localhost:5000/api/tags/popular" -Method GET
```

**curl:**
```bash
# Search threads
curl "http://localhost:5000/api/threads?search=javascript"

# Filter by category
curl "http://localhost:5000/api/threads?category=CATEGORY_ID"

# Get popular tags
curl http://localhost:5000/api/tags/popular
```

---

## 🎯 Complete Test Script

Here's a complete PowerShell script that tests all major functionality:

```powershell
# Complete API Test Script
Write-Host "🧪 Starting Forum API Tests..." -ForegroundColor Green

# 1. Health Check
Write-Host "`n1. Testing Health Check..." -ForegroundColor Yellow
$health = Invoke-RestMethod -Uri "http://localhost:5000/api/health" -Method GET
Write-Host "✅ Server Status: $($health.status)"

# 2. Login
Write-Host "`n2. Testing Login..." -ForegroundColor Yellow
$loginBody = @{
    email = "john@example.com"
    password = "Password123!"
} | ConvertTo-Json

$loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
$token = $loginResponse.token
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}
Write-Host "✅ Login successful for user: $($loginResponse.user.username)"

# 3. Get Categories
Write-Host "`n3. Testing Categories..." -ForegroundColor Yellow
$categories = Invoke-RestMethod -Uri "http://localhost:5000/api/categories" -Method GET
Write-Host "✅ Found $($categories.categories.Count) categories"

# 4. Get Threads
Write-Host "`n4. Testing Threads..." -ForegroundColor Yellow
$threads = Invoke-RestMethod -Uri "http://localhost:5000/api/threads" -Method GET
Write-Host "✅ Found $($threads.threads.Count) threads"

# 5. Create Thread
Write-Host "`n5. Testing Thread Creation..." -ForegroundColor Yellow
$threadBody = @{
    title = "API Test Thread - $(Get-Date -Format 'HH:mm:ss')"
    content = "This thread was created by the automated test script to verify API functionality."
    category = $categories.categories[0].id
    tags = @("test", "automation")
} | ConvertTo-Json

$newThread = Invoke-RestMethod -Uri "http://localhost:5000/api/threads" -Method POST -Body $threadBody -Headers $headers
Write-Host "✅ Created thread: $($newThread.thread.title)"

# 6. Vote on Thread
Write-Host "`n6. Testing Voting..." -ForegroundColor Yellow
$voteBody = @{ type = "upvote" } | ConvertTo-Json
$voteResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/votes/threads/$($newThread.thread.id)" -Method POST -Body $voteBody -Headers $headers
Write-Host "✅ Vote recorded! Score: $($voteResponse.voteScore)"

# 7. Add Reply
Write-Host "`n7. Testing Replies..." -ForegroundColor Yellow
$replyBody = @{
    content = "This is an automated test reply created by the test script."
} | ConvertTo-Json
$reply = Invoke-RestMethod -Uri "http://localhost:5000/api/replies/$($newThread.thread.id)" -Method POST -Body $replyBody -Headers $headers
Write-Host "✅ Reply added successfully"

Write-Host "`n🎉 All tests completed successfully!" -ForegroundColor Green
Write-Host "Your forum backend is working perfectly!" -ForegroundColor Green
```

Save this as `test-api.ps1` and run with:
```powershell
.\test-api.ps1
```

---

## 🐛 Troubleshooting

### Common Issues:

**1. Server not starting:**
```bash
# Check if port 5000 is in use
netstat -an | findstr :5000

# Kill process if needed
taskkill /f /im node.exe
```

**2. MongoDB connection error:**
```bash
# Restart MongoDB service or use cloud MongoDB
# Update MONGODB_URI in .env file
```

**3. Authentication errors:**
- Make sure to include the `Authorization: Bearer TOKEN` header
- Token expires after 7 days, login again if needed

**4. Validation errors:**
- Check request body format matches the examples
- Ensure required fields are included

### Debug Mode:
```bash
# Run with debug logging
DEBUG=* npm run dev
```

---

## 📚 API Reference Quick Links

- **Base URL**: `http://localhost:5000/api`
- **Authentication**: JWT Bearer token in Authorization header
- **Content-Type**: `application/json` for POST/PUT requests

### Endpoint Categories:
- `/auth/*` - Authentication (register, login, profile)
- `/threads/*` - Thread management
- `/replies/*` - Reply management  
- `/votes/*` - Voting system
- `/categories/*` - Category management
- `/tags/*` - Tag system
- `/users/*` - User profiles

Happy testing! 🚀