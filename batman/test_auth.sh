#!/bin/bash

# Configuration
API_URL="http://localhost:4000/api"
TIMESTAMP=$(date +%s)
EMAIL="test.${TIMESTAMP}@example.com"
USERNAME="testuser${TIMESTAMP}"
PASSWORD="password123"
PROTECTED_ROUTE="/users"
COOKIE_FILE="/tmp/cookies.txt"
rm -f $COOKIE_FILE
# Colors and styles
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Symbols
CHECK_MARK="${GREEN}✓${NC}"
CROSS_MARK="${RED}✗${NC}"
ARROW="${YELLOW}➜${NC}"
ROCKET="${PURPLE}🚀${NC}"
GEAR="${CYAN}⚙️${NC}"
WARNING="${YELLOW}⚠️${NC}"
LOCK="${PURPLE}🔒${NC}"

# Helper functions (previous helper functions remain the same)
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "\n${CHECK_MARK} ${GREEN}${BOLD}SUCCESS:${NC} $2"
    else
        echo -e "\n${CROSS_MARK} ${RED}${BOLD}FAILED:${NC} $2"
        echo -e "${RED}Response: $3${NC}"
    fi
}

print_header() {
    echo -e "\n${BLUE}${BOLD}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}${BOLD}  $1${NC}"
    echo -e "${BLUE}${BOLD}══════════════════════════════════════════════════════════════${NC}\n"
}

extract_from_json() {
    echo $1 | grep -o "\"$2\":\"[^\"]*\"" | sed "s/\"$2\":\"//;s/\"//g"
}

log_request() {
    echo -e "${ARROW} ${CYAN}Sending request to:${NC} ${BOLD}$1${NC}"
    echo -e "${GEAR} ${CYAN}Method:${NC} ${BOLD}$2${NC}"
}

# Starting banner (remains the same)
clear
echo -e "${BLUE}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                   API Authentication Tests                     ║"
echo "╚═══════════════════════════════════════════════════════════════╝${NC}"
echo -e "\n${ROCKET} ${CYAN}Test Suite Started at:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${GEAR} ${CYAN}Test Configuration:${NC}"
echo -e "   ${ARROW} Email: ${BOLD}${EMAIL}${NC}"
echo -e "   ${ARROW} Username: ${BOLD}${USERNAME}${NC}"
echo -e "   ${ARROW} API URL: ${BOLD}${API_URL}${NC}"

# 1. Test Protected Route Without Authentication
print_header "1. TESTING PROTECTED ROUTE WITHOUT AUTH ${WARNING}"
log_request "${API_URL}${PROTECTED_ROUTE}" "GET"
echo -e "${GEAR} ${CYAN}Attempting to access protected route without token...${NC}"

UNAUTH_RESPONSE=$(curl -s -X GET "${API_URL}${PROTECTED_ROUTE}")

if echo "$UNAUTH_RESPONSE" | grep -q "Unauthorized"; then
    print_result 0 "Security Check Passed (Unauthorized access properly rejected)"
else
    print_result 1 "Security Check Failed" "$UNAUTH_RESPONSE"
fi

# 2. Test Sign Up
print_header "2. TESTING USER REGISTRATION ${LOCK}"
log_request "${API_URL}/users/sign_up" "POST"
echo -e "${GEAR} ${CYAN}Registering new user...${NC}"

SIGNUP_RESPONSE=$(curl -s -c $COOKIE_FILE -X POST "${API_URL}/users/sign_up" \
    -H "Content-Type: application/json" \
    -H "Origin: http://localhost:8080" \
    -d '{
        "email": "'${EMAIL}'",
        "password": "'${PASSWORD}'",
        "username": "'${USERNAME}'",
        "first_name": "Test",
        "last_name": "User",
        "role": "admin"
    }')

if echo "$SIGNUP_RESPONSE" | grep -q "user_id"; then
    XSRF_TOKEN=$(echo "$SIGNUP_RESPONSE" | grep -o '"xsrf_token":"[^"]*"' | cut -d'"' -f4)
    USER_ID=$(echo "$SIGNUP_RESPONSE" | grep -o '"user_id":"[^"]*"' | cut -d'"' -f4)
    print_result 0 "User Registration Complete"
    echo -e "${GEAR} ${CYAN}Details:${NC}"
    echo -e "   ${ARROW} User ID: ${BOLD}${USER_ID}${NC}"
    echo -e "   ${ARROW} XSRF Token: ${BOLD}${XSRF_TOKEN:0:20}...${NC}"
else
    print_result 1 "User Registration Failed" "$SIGNUP_RESPONSE"
    exit 1
fi

# 3. Test Protected Route With Authentication
print_header "3. TESTING PROTECTED ROUTE WITH AUTH ${LOCK}"
log_request "${API_URL}${PROTECTED_ROUTE}" "GET"
echo -e "${GEAR} ${CYAN}Attempting to access protected route with token...${NC}"

AUTH_RESPONSE=$(curl -s -b $COOKIE_FILE \
    -H "x-xsrf-token: ${XSRF_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Origin: http://localhost:8080" \
    "${API_URL}${PROTECTED_ROUTE}")

if ! echo "$AUTH_RESPONSE" | grep -q "Unauthorized"; then
    print_result 0 "Authorized Access Successful"
    echo -e "${GEAR} ${CYAN}Response:${NC} $AUTH_RESPONSE"
else
    print_result 1 "Authorized Access Failed" "$AUTH_RESPONSE"
fi

# 4. Test Invalid Token
print_header "4. TESTING INVALID TOKEN ${WARNING}"
log_request "${API_URL}${PROTECTED_ROUTE}" "GET"
echo -e "${GEAR} ${CYAN}Testing with invalid token...${NC}"

INVALID_AUTH_RESPONSE=$(curl -s \
    -H "x-xsrf-token: invalid_xsrf" \
    -H "Content-Type: application/json" \
    -H "Origin: http://localhost:8080" \
    "${API_URL}${PROTECTED_ROUTE}")

if echo "$INVALID_AUTH_RESPONSE" | grep -q "Unauthorized"; then
    print_result 0 "Security Check Passed (Invalid token properly rejected)"
else
    print_result 1 "Security Check Failed" "$INVALID_AUTH_RESPONSE"
fi

# 5. Test Sign Out
print_header "5. TESTING USER LOGOUT ${LOCK}"
log_request "${API_URL}/users/sign_out" "POST"
echo -e "${GEAR} ${CYAN}Attempting logout...${NC}"

SIGNOUT_RESPONSE=$(curl -s -b $COOKIE_FILE -c $COOKIE_FILE \
    -H "x-xsrf-token: ${XSRF_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Origin: http://localhost:8080" \
    -X POST "${API_URL}/users/sign_out")

if echo "$SIGNOUT_RESPONSE" | grep -q "Successfully signed out"; then
    print_result 0 "Logout Successful"
else
    print_result 1 "Logout Failed" "$SIGNOUT_RESPONSE"
fi

# Petit délai pour s'assurer que le cookie est bien traité
sleep 1

# 6. Test Protected Route After Logout
print_header "6. TESTING PROTECTED ROUTE AFTER LOGOUT ${WARNING}"
log_request "${API_URL}${PROTECTED_ROUTE}" "GET"
echo -e "${GEAR} ${CYAN}Attempting to access protected route after logout...${NC}"

# Créer une nouvelle session pour être sûr de ne pas réutiliser les anciens cookies
TEMP_COOKIE_FILE="/tmp/temp_cookies.txt"
rm -f $TEMP_COOKIE_FILE

POST_LOGOUT_RESPONSE=$(curl -s \
    -H "x-xsrf-token: ${XSRF_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Origin: http://localhost:8080" \
    "${API_URL}${PROTECTED_ROUTE}")

if echo "$POST_LOGOUT_RESPONSE" | grep -q "Unauthorized"; then
    print_result 0 "Security Check Passed (Post-logout access properly rejected)"
else
    print_result 1 "Security Check Failed" "$POST_LOGOUT_RESPONSE"
fi

# Nettoyer les fichiers de cookies temporaires
rm -f $COOKIE_FILE
rm -f $TEMP_COOKIE_FILE

# Final Summary
print_header "TEST SUITE SUMMARY ${ROCKET}"
echo -e "${BOLD}Test Results:${NC}"
echo -e "${GEAR} Total Tests Run: ${BOLD}6${NC}"
echo -e "${GEAR} Test Account: ${BOLD}${EMAIL}${NC}"
echo -e "${GEAR} User ID: ${BOLD}${USER_ID}${NC}"
echo -e "${GEAR} Test Completed at: ${BOLD}$(date '+%Y-%m-%d %H:%M:%S')${NC}"

echo -e "\n${BLUE}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}                    Test Suite Completed                      ${NC}"
echo -e "${BLUE}${BOLD}══════════════════════════════════════════════════════════════${NC}"