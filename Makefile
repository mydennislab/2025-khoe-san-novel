.PHONY: help generate serve clean test deploy

help: ## Show this help message
	@echo "Repository Browser Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

generate: ## Generate repository structure JSON
	@echo "🔍 Generating repository structure..."
	@python3 generate_structure.py
	@echo "✅ Repository structure generated successfully!"

serve: ## Serve the repository browser locally
	@echo "🌐 Starting local server on http://localhost:8000"
	@echo "Press Ctrl+C to stop the server"
	@python3 -m http.server 8000

clean: ## Clean generated files
	@echo "🧹 Cleaning generated files..."
	@rm -f repo_structure.json
	@echo "✅ Cleaned!"

test: generate ## Test the structure generation
	@echo "🧪 Testing repository structure generation..."
	@python3 -c "import json; data = json.load(open('repo_structure.json')); print(f'✅ Valid JSON with {len(data[\"structure\"])} top-level items')"

deploy: generate ## Prepare for deployment (generate structure)
	@echo "🚀 Preparing for deployment..."
	@python3 generate_structure.py
	@echo "✅ Ready for deployment!"

install: ## Install local dependencies (if needed)
	@echo "📦 All dependencies are built-in Python modules"
	@echo "✅ No additional installation required!"
