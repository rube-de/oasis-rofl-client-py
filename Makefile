.PHONY: help install format lint clean test

# Default target: show help
help:
	@echo "Available targets:"
	@echo "  install    - Install all dependencies including dev dependencies"
	@echo "  format     - Format code using ruff"
	@echo "  lint       - Lint code using ruff"
	@echo "  clean      - Remove build artifacts and caches"
	@echo "  test       - Run tests with pytest"

# Install all dependencies
install:
	@echo "Installing dependencies..."
	pip install --upgrade pip
	pip install -e .
	pip install -e ".[dev]"
	@echo "Dependencies installed successfully!"

# Format code with ruff
format:
	@echo "Formatting code with ruff..."
	ruff format src/ tests/ examples/
	@echo "Code formatting complete!"

# Lint code with ruff
lint:
	@echo "Linting code with ruff..."
	ruff check src/ tests/ examples/ --fix
	@echo "Linting complete!"

# Clean build artifacts and caches
clean:
	@echo "Cleaning build artifacts and caches..."
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf src/*.egg-info
	rm -rf .pytest_cache/
	rm -rf .ruff_cache/
	rm -rf __pycache__/
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type f -name "*.cover" -delete
	@echo "Clean complete!"

# Run tests
test:
	@echo "Running tests..."
	pytest tests/