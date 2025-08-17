# Forum Backend API Test Script
# Run this script to test all major API functionality

Write-Host "🧪 Starting Forum API Tests..." -ForegroundColor Green
Write-Host "Make sure the server is running on http://localhost:5000" -ForegroundColor Cyan
Write-Host ""

try {
    # 1. Health Check
    Write-Host "1. Testing Health Check..." -ForegroundColor Yellow
    $health = Invoke-RestMethod -Uri "http://localhost:5000/api/health" -Method GET
    Write-Host "   ✅ Server Status: $($health.status)" -ForegroundColor Green

    # 2. Get Categories
    Write-Host "`n2. Testing Categories..." -ForegroundColor Yellow
    $categories = Invoke-RestMethod -Uri "http://localhost:5000/api/categories" -Method GET
    Write-Host "   ✅ Found $($categories.categories.Count) categories" -ForegroundColor Green
    $categories.categories | ForEach-Object { Write-Host "      - $($_.name)" -ForegroundColor Gray }

    # 3. Login with sample user
    Write-Host "`n3. Testing Login..." -ForegroundColor Yellow
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
    Write-Host "   ✅ Login successful for user: $($loginResponse.user.username)" -ForegroundColor Green
    Write-Host "      Reputation: $($loginResponse.user.reputation)" -ForegroundColor Gray

    # 4. Get Current User Profile
    Write-Host "`n4. Testing User Profile..." -ForegroundColor Yellow
    $profile = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/me" -Method GET -Headers $headers
    Write-Host "   ✅ Profile retrieved for: $($profile.user.username)" -ForegroundColor Green
    Write-Host "      Email: $($profile.user.email)" -ForegroundColor Gray
    Write-Host "      Joined: $($profile.user.joinedAt)" -ForegroundColor Gray

    # 5. Get Existing Threads
    Write-Host "`n5. Testing Thread Retrieval..." -ForegroundColor Yellow
    $threads = Invoke-RestMethod -Uri "http://localhost:5000/api/threads" -Method GET
    Write-Host "   ✅ Found $($threads.threads.Count) existing threads" -ForegroundColor Green
    $threads.threads | ForEach-Object { 
        Write-Host "      - $($_.title) (Score: $($_.voteScore), Replies: $($_.replyCount))" -ForegroundColor Gray 
    }

    # 6. Create New Thread
    Write-Host "`n6. Testing Thread Creation..." -ForegroundColor Yellow
    $timestamp = Get-Date -Format "HH:mm:ss"
    $threadBody = @{
        title = "API Test Thread - $timestamp"
        content = "This thread was created by the automated test script to verify API functionality. It includes proper authentication, validation, and database operations."
        category = $categories.categories[0].id
        tags = @("test", "automation", "api")
    } | ConvertTo-Json

    $newThread = Invoke-RestMethod -Uri "http://localhost:5000/api/threads" -Method POST -Body $threadBody -Headers $headers
    Write-Host "   ✅ Created thread: $($newThread.thread.title)" -ForegroundColor Green
    Write-Host "      Thread ID: $($newThread.thread.id)" -ForegroundColor Gray

    # 7. Get Single Thread Details
    Write-Host "`n7. Testing Single Thread Retrieval..." -ForegroundColor Yellow
    $threadDetails = Invoke-RestMethod -Uri "http://localhost:5000/api/threads/$($newThread.thread.id)" -Method GET
    Write-Host "   ✅ Retrieved thread details" -ForegroundColor Green
    Write-Host "      Views: $($threadDetails.thread.views)" -ForegroundColor Gray
    Write-Host "      Tags: $($threadDetails.thread.tags.name -join ', ')" -ForegroundColor Gray

    # 8. Vote on Thread
    Write-Host "`n8. Testing Voting System..." -ForegroundColor Yellow
    $voteBody = @{ type = "upvote" } | ConvertTo-Json
    $voteResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/votes/threads/$($newThread.thread.id)" -Method POST -Body $voteBody -Headers $headers
    Write-Host "   ✅ Upvote recorded! New score: $($voteResponse.voteScore)" -ForegroundColor Green

    # 9. Add Reply to Thread
    Write-Host "`n9. Testing Reply System..." -ForegroundColor Yellow
    $replyBody = @{
        content = "This is an automated test reply created by the test script. It demonstrates the nested comment functionality of the forum API."
    } | ConvertTo-Json
    $reply = Invoke-RestMethod -Uri "http://localhost:5000/api/replies/$($newThread.thread.id)" -Method POST -Body $replyBody -Headers $headers
    Write-Host "   ✅ Reply added successfully" -ForegroundColor Green
    Write-Host "      Reply ID: $($reply.reply.id)" -ForegroundColor Gray

    # 10. Get Popular Tags
    Write-Host "`n10. Testing Tag System..." -ForegroundColor Yellow
    $popularTags = Invoke-RestMethod -Uri "http://localhost:5000/api/tags/popular" -Method GET
    Write-Host "   ✅ Found $($popularTags.tags.Count) popular tags" -ForegroundColor Green
    $popularTags.tags | ForEach-Object { 
        Write-Host "      - $($_.name) (used $($_.usageCount) times)" -ForegroundColor Gray 
    }

    # 11. Search Functionality
    Write-Host "`n11. Testing Search..." -ForegroundColor Yellow
    $searchResults = Invoke-RestMethod -Uri "http://localhost:5000/api/threads?search=test" -Method GET
    Write-Host "   ✅ Search found $($searchResults.threads.Count) threads containing 'test'" -ForegroundColor Green

    # 12. Filter by Category
    Write-Host "`n12. Testing Category Filtering..." -ForegroundColor Yellow
    $categoryFilter = Invoke-RestMethod -Uri "http://localhost:5000/api/threads?category=$($categories.categories[0].id)" -Method GET
    Write-Host "   ✅ Found $($categoryFilter.threads.Count) threads in '$($categories.categories[0].name)' category" -ForegroundColor Green

    # 13. Get Vote Statistics
    Write-Host "`n13. Testing Vote Statistics..." -ForegroundColor Yellow
    $voteStats = Invoke-RestMethod -Uri "http://localhost:5000/api/votes/threads/$($newThread.thread.id)/stats" -Method GET
    Write-Host "   ✅ Vote stats retrieved" -ForegroundColor Green
    Write-Host "      Thread score: $($voteStats.thread.score)" -ForegroundColor Gray
    Write-Host "      Total upvotes: $($voteStats.total.upvotes)" -ForegroundColor Gray

    # Summary
    Write-Host "`n" + "="*60 -ForegroundColor Cyan
    Write-Host "🎉 ALL TESTS COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "="*60 -ForegroundColor Cyan
    Write-Host ""
    Write-Host "✅ Authentication System - Working" -ForegroundColor Green
    Write-Host "✅ Thread Management - Working" -ForegroundColor Green
    Write-Host "✅ Reply System - Working" -ForegroundColor Green
    Write-Host "✅ Voting System - Working" -ForegroundColor Green
    Write-Host "✅ Category System - Working" -ForegroundColor Green
    Write-Host "✅ Tag System - Working" -ForegroundColor Green
    Write-Host "✅ Search & Filtering - Working" -ForegroundColor Green
    Write-Host "✅ User Profiles - Working" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your Forum Backend API is fully functional! 🚀" -ForegroundColor Green
    Write-Host "You can now connect your frontend or continue development." -ForegroundColor Cyan

} catch {
    Write-Host "`n❌ Test failed with error:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting tips:" -ForegroundColor Yellow
    Write-Host "1. Make sure the server is running: npm run dev" -ForegroundColor Gray
    Write-Host "2. Check if database is seeded: node utils/seedData.js" -ForegroundColor Gray
    Write-Host "3. Verify server is accessible: http://localhost:5000/api/health" -ForegroundColor Gray
}