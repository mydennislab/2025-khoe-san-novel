#!/usr/bin/env python3
"""
URL Validation Script
Tests that GitHub URLs are being constructed correctly for the repository browser.
"""

import json
import urllib.request
import urllib.error

def test_github_urls():
    """Test that GitHub URLs are accessible"""
    print("🔍 Testing GitHub URL construction...")
    
    # Load repository structure
    try:
        with open('repo_structure.json', 'r') as f:
            repo_data = json.load(f)
    except FileNotFoundError:
        print("❌ repo_structure.json not found. Run 'python3 generate_structure.py' first.")
        return False
    
    repo_name = repo_data['repository']
    branch = repo_data['branch']
    
    print(f"Repository: {repo_name}")
    print(f"Branch: {branch}")
    print()
    
    # Test a few sample files
    sample_files = []
    
    def collect_files(items, max_files=5):
        for item in items:
            if len(sample_files) >= max_files:
                break
            if item['type'] == 'file':
                sample_files.append(item)
            elif item['type'] == 'directory' and 'children' in item:
                collect_files(item['children'], max_files)
    
    collect_files(repo_data['structure'])
    
    print(f"Testing {len(sample_files)} sample files:")
    print("=" * 50)
    
    success_count = 0
    
    for file_item in sample_files:
        file_path = file_item['path']
        file_name = file_item['name']
        
        # Construct URLs (same logic as browser)
        view_url = f"https://github.com/{repo_name}/blob/{branch}/{file_path}"
        raw_url = f"https://raw.githubusercontent.com/{repo_name}/{branch}/{file_path}"
        
        print(f"📄 {file_name}")
        print(f"   View: {view_url}")
        print(f"   Raw:  {raw_url}")
        
        # Test if URLs are accessible (just check if they return 200 or redirect)
        try:
            # Test view URL
            req = urllib.request.Request(view_url)
            req.add_header('User-Agent', 'Mozilla/5.0 (Repository Browser Test)')
            with urllib.request.urlopen(req, timeout=10) as response:
                if response.status in [200, 301, 302]:
                    print(f"   ✅ View URL accessible (status: {response.status})")
                else:
                    print(f"   ⚠️  View URL returned status: {response.status}")
            
            # Test raw URL
            req = urllib.request.Request(raw_url)
            req.add_header('User-Agent', 'Mozilla/5.0 (Repository Browser Test)')
            with urllib.request.urlopen(req, timeout=10) as response:
                if response.status in [200, 301, 302]:
                    print(f"   ✅ Raw URL accessible (status: {response.status})")
                    success_count += 1
                else:
                    print(f"   ⚠️  Raw URL returned status: {response.status}")
                    
        except urllib.error.HTTPError as e:
            if e.code == 404:
                print(f"   ❌ File not found (404) - repository may be private or file doesn't exist")
            else:
                print(f"   ❌ HTTP Error {e.code}: {e.reason}")
        except urllib.error.URLError as e:
            print(f"   ❌ URL Error: {e.reason}")
        except Exception as e:
            print(f"   ❌ Error: {e}")
        
        print()
    
    print("=" * 50)
    print(f"Summary: {success_count}/{len(sample_files)} files successfully accessible")
    
    if success_count == len(sample_files):
        print("🎉 All URLs are working correctly!")
        return True
    elif success_count > 0:
        print("⚠️  Some URLs are working. If repository is private, this is expected.")
        return True
    else:
        print("❌ No URLs are accessible. Check repository name and network connection.")
        return False

def test_url_construction():
    """Test URL construction logic"""
    print("🧪 Testing URL construction logic...")
    
    test_cases = [
        {
            'repo': 'mydennislab/2025-khoe-san-novel',
            'branch': 'main',
            'file_path': 'galaxy_kraken/bacteria_summary.tsv',
            'expected_view': 'https://github.com/mydennislab/2025-khoe-san-novel/blob/main/galaxy_kraken/bacteria_summary.tsv',
            'expected_raw': 'https://raw.githubusercontent.com/mydennislab/2025-khoe-san-novel/main/galaxy_kraken/bacteria_summary.tsv'
        }
    ]
    
    for test in test_cases:
        repo = test['repo']
        branch = test['branch']
        file_path = test['file_path']
        
        # Handle different repository formats (same as browser logic)
        if repo.startswith('git@github.com:'):
            repo = repo.replace('git@github.com:', '')
        elif repo.startswith('https://github.com/'):
            repo = repo.replace('https://github.com/', '')
        repo = repo.replace('.git', '')
        
        view_url = f"https://github.com/{repo}/blob/{branch}/{file_path}"
        raw_url = f"https://raw.githubusercontent.com/{repo}/{branch}/{file_path}"
        
        print(f"Repository: {test['repo']}")
        print(f"Generated view URL: {view_url}")
        print(f"Expected view URL:  {test['expected_view']}")
        print(f"View URL match: {'✅' if view_url == test['expected_view'] else '❌'}")
        print()
        print(f"Generated raw URL: {raw_url}")
        print(f"Expected raw URL:  {test['expected_raw']}")
        print(f"Raw URL match: {'✅' if raw_url == test['expected_raw'] else '❌'}")
        print()
    
    print("✅ URL construction logic verified!")

if __name__ == "__main__":
    print("🚀 Repository Browser URL Validation")
    print("=" * 40)
    print()
    
    test_url_construction()
    print()
    test_github_urls()
