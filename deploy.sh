#!/bin/bash

# Repository Browser Deployment Script
# This script prepares the repository for GitHub Pages deployment

set -e  # Exit on any error

echo "🚀 Starting Repository Browser Deployment..."
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "This is not a Git repository. Please run from the repository root."
    exit 1
fi

# Generate repository structure
print_status "Generating repository structure..."
if command -v python3 &> /dev/null; then
    python3 generate_structure.py
    print_success "Repository structure generated successfully!"
else
    print_error "Python 3 is required but not found."
    exit 1
fi

# Validate the generated JSON
print_status "Validating generated structure..."
if python3 -c "import json; json.load(open('repo_structure.json'))" 2>/dev/null; then
    ITEM_COUNT=$(python3 -c "import json; data=json.load(open('repo_structure.json')); print(len(data['structure']))")
    print_success "JSON is valid with $ITEM_COUNT top-level items"
else
    print_error "Generated JSON is invalid!"
    exit 1
fi

# Check if index.html exists
if [ ! -f "index.html" ]; then
    print_error "index.html not found! The browser interface is missing."
    exit 1
fi

print_success "Browser interface found"

# Check GitHub Actions workflow
if [ -f ".github/workflows/sync_repo_files.yml" ]; then
    print_success "GitHub Actions workflow found"
else
    print_warning "GitHub Actions workflow not found. Manual deployment only."
fi

# Create deployment summary
echo ""
echo "📊 DEPLOYMENT SUMMARY"
echo "===================="
echo "Repository: $(git remote get-url origin 2>/dev/null || echo 'Unknown')"
echo "Branch: $(git branch --show-current 2>/dev/null || echo 'Unknown')"
echo "Structure Items: $ITEM_COUNT"
echo "Last Updated: $(date)"
echo ""

# Git status check
if [ -n "$(git status --porcelain)" ]; then
    print_warning "There are uncommitted changes:"
    git status --short
    echo ""
    read -p "Do you want to commit these changes? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Committing changes..."
        git add .
        git commit -m "Update repository browser structure - $(date)"
        print_success "Changes committed"
        
        read -p "Do you want to push to GitHub? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push
            print_success "Changes pushed to GitHub"
        fi
    fi
fi

# Instructions for GitHub Pages
echo ""
echo "🌐 GITHUB PAGES SETUP"
echo "===================="
echo "To enable GitHub Pages for this repository:"
echo "1. Go to your repository on GitHub"
echo "2. Navigate to Settings > Pages"
echo "3. Under 'Source', select 'GitHub Actions'"
echo "4. The workflow will automatically deploy your browser"
echo ""
echo "Your site will be available at:"
echo "https://$(git remote get-url origin 2>/dev/null | sed 's/.*github.com[:/]//' | sed 's/.git$//' | sed 's|/|.github.io/|')"
echo ""

print_success "Deployment preparation complete!"
echo "================================================"
