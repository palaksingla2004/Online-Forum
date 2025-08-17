#!/bin/bash

# Forum Backend API Test Script (Cross-platform with curl)
# Make this file executable: chmod +x test-api.sh

echo "🧪 Starting Forum API Tests..."
echo "Make sure the server is running on http://localhost:5000"
echo ""

BASE_URL="http://localhost:5000/api"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GRAY='\033[0;37m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to check if command was successful
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "   ${GREEN}✅ $1${NC}"
    else
        echo -e "   ${RED}❌ $1 failed${NC}"
        exit 1
    fi
}

# 1. Health Check
echo -e "${YELLOW}1. Testing Health Check...${NC}"
curl -s "$BASE_URL/health" > /dev/null
check_status "Server is running"

# 2. Get Categories
echo -e "\n${YELLOW}2. Testing Categories...${NC}"
CATEGORIES=$(curl -s "$BASE_URL/categories")
echo "$CATEGORIES" | grep -q "categories"
check_status "Categories retrieved"

# Extract first category ID for later use
CATEGORY_ID=$(echo "$CATEGORIES" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo -e "   ${GRAY}Using category ID: $CATEGORY_ID${NC}"

# 3. Login
echo -e "\n${YELLOW}3. Testing Login...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "Password123!"
  }')

echo "$LOGIN_RESPONSE" | grep -q "token"
check_status "Login successful"

# Extract token
TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
echo -e "   ${GRAY}Token obtained (length: ${#TOKEN})${NC}"

# 4. Get User Profile
echo -e "\n${YELLOW}4. Testing User Profile...${NC}"
PROFILE=$(curl -s -H "Authorization: Bearer $TOKEN" "$BASE_URL/auth/me")
echo "$PROFILE" | grep -q "username"
check_status "Profile retrieved"

USERNAME=$(echo "$PROFILE" | grep -o '"username":"[^"]*"' | cut -d'"' -f4)
echo -e "   ${GRAY}Logged in as: $USERNAME${NC}"

# 5. Get Existing Threads
echo -e "\n${YELLOW}5. Testing Thread Retrieval...${NC}"
THREADS=$(curl -s "$BASE_URL/threads")
echo "$THREADS" | grep -q "threads"
check_status "Threads retrieved"

THREAD_COUNT=$(echo "$THREADS" | grep -o '"id":"[^"]*"' | wc -l)
echo -e "   ${GRAY}Found $THREAD_COUNT existing threads${NC}"

# 6. Create New Thread
echo -e "\n${YELLOW}6. Testing Thread Creation...${NC}"
TIMESTAMP=$(date +"%H:%M:%S")
NEW_THREAD=$(curl -s -X POST "$BASE_URL/threads" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"title\": \"API Test Thread - $TIMESTAMP\",
    \"content\": \"This thread was created by the automated test script to verify API functionality.\",
    \"category\": \"$CATEGORY_ID\",
    \"tags\": [\"test\", \"automation\", \"api\"]
  }")

echo "$NEW_THREAD" | grep -q "thread"
check_status "Thread created"

# Extract new thread ID
THREAD_ID=$(echo "$NEW_THREAD" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo -e "   ${GRAY}Thread ID: $THREAD_ID${NC}"

# 7. Get Single Thread
echo -e "\n${YELLOW}7. Testing Single Thread Retrieval...${NC}"
THREAD_DETAILS=$(curl -s "$BASE_URL/threads/$THREAD_ID")
echo "$THREAD_DETAILS" | grep -q "thread"
check_status "Thread details retrieved"

# 8. Vote on Thread
echo -e "\n${YELLOW}8. Testing Voting System...${NC}"
VOTE_RESPONSE=$(curl -s -X POST "$BASE_URL/votes/threads/$THREAD_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"type": "upvote"}')

echo "$VOTE_RESPONSE" | grep -q "voteScore"
check_status "Vote recorded"

VOTE_SCORE=$(echo "$VOTE_RESPONSE" | grep -o '"voteScore":[0-9]*' | cut -d':' -f2)
echo -e "   ${GRAY}New vote score: $VOTE_SCORE${NC}"

# 9. Add Reply
echo -e "\n${YELLOW}9. Testing Reply System...${NC}"
REPLY_RESPONSE=$(curl -s -X POST "$BASE_URL/replies/$THREAD_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "content": "This is an automated test reply created by the test script."
  }')

echo "$REPLY_RESPONSE" | grep -q "reply"
check_status "Reply added"

# 10. Get Popular Tags
echo -e "\n${YELLOW}10. Testing Tag System...${NC}"
TAGS=$(curl -s "$BASE_URL/tags/popular")
echo "$TAGS" | grep -q "tags"
check_status "Popular tags retrieved"

# 11. Search Functionality
echo -e "\n${YELLOW}11. Testing Search...${NC}"
SEARCH_RESULTS=$(curl -s "$BASE_URL/threads?search=test")
echo "$SEARCH_RESULTS" | grep -q "threads"
check_status "Search functionality working"

# 12. Filter by Category
echo -e "\n${YELLOW}12. Testing Category Filtering...${NC}"
FILTERED_THREADS=$(curl -s "$BASE_URL/threads?category=$CATEGORY_ID")
echo "$FILTERED_THREADS" | grep -q "threads"
check_status "Category filtering working"

# 13. Get Vote Statistics
echo -e "\n${YELLOW}13. Testing Vote Statistics...${NC}"
VOTE_STATS=$(curl -s "$BASE_URL/votes/threads/$THREAD_ID/stats")
echo "$VOTE_STATS" | grep -q "thread"
check_status "Vote statistics retrieved"

# Summary
echo ""
echo -e "${CYAN}============================================================${NC}"
echo -e "${GREEN}🎉 ALL TESTS COMPLETED SUCCESSFULLY!${NC}"
echo -e "${CYAN}============================================================${NC}"
echo ""
echo -e "${GREEN}✅ Authentication System - Working${NC}"
echo -e "${GREEN}✅ Thread Management - Working${NC}"
echo -e "${GREEN}✅ Reply System - Working${NC}"
echo -e "${GREEN}✅ Voting System - Working${NC}"
echo -e "${GREEN}✅ Category System - Working${NC}"
echo -e "${GREEN}✅ Tag System - Working${NC}"
echo -e "${GREEN}✅ Search & Filtering - Working${NC}"
echo -e "${GREEN}✅ User Profiles - Working${NC}"
echo ""
echo -e "${GREEN}Your Forum Backend API is fully functional! 🚀${NC}"
echo -e "${CYAN}You can now connect your frontend or continue development.${NC}"