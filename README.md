# oasis-rofl-client-rube

[![Publish to PyPI](https://github.com/rube-de/oasis-rofl-client-py/actions/workflows/publish.yml/badge.svg)](https://github.com/rube-de/oasis-rofl-client-py/actions/workflows/publish.yml)
[![PyPI version](https://badge.fury.io/py/oasis-rofl-client-rube.svg)](https://badge.fury.io/py/oasis-rofl-client-rube)

Python client SDK for Oasis ROFL with **automated PyPI publishing** via GitHub Actions.

## Key Features

- **Automatic versioning** from git tags (powered by `hatch-vcs`)
- **GitHub Actions workflow** for automated PyPI publishing
- **Zero-config releases** - just tag and push!
- **TestPyPI integration** for safe testing
- **Trusted publishing** support (no tokens needed)

## Installation

From PyPI:

```bash
uv pip install oasis-rofl-client-rube
```

The package requires Python 3.9+ and depends on `httpx` for async HTTP operations.

## Quickstart

The RoflClient provides async methods for interacting with ROFL services:

```python
import asyncio
from oasis_rofl_client import RoflClient

async def main():
    # Create a client (defaults to Unix socket at /run/rofl-appd.sock)
    client = RoflClient()
    
    # Or use a custom URL
    # client = RoflClient(url="https://rofl.example.com")
    
    # Or use a custom Unix socket path
    # client = RoflClient(url="/custom/socket.sock")
    
    # Generate a cryptographic key
    key = await client.generate_key("my-key-id")
    print(f"Generated key: {key}")

# Run the async function
asyncio.run(main())
```

## API Reference

### RoflClient

The main client class for interacting with ROFL runtime services.

#### Constructor

```python
RoflClient(url: str = '')
```

- `url`: Optional URL or Unix socket path
  - If empty (default): Uses Unix socket at `/run/rofl-appd.sock`
  - If starts with `http://` or `https://`: Uses HTTP transport
  - Otherwise: Treats as Unix socket path

#### Methods

##### `async generate_key(key_id: str) -> str`

Fetches or generates a secp256k1 cryptographic key from ROFL.

- **Parameters:**
  - `key_id`: Identifier for the key
- **Returns:** The private key as a hex string
- **Raises:** `httpx.HTTPStatusError` if the request fails

## Examples

### Using with Unix Socket (Default)

```python
import asyncio
from oasis_rofl_client import RoflClient

async def generate_keys():
    client = RoflClient()  # Uses /run/rofl-appd.sock
    
    # Generate multiple keys
    keys = {}
    for i in range(3):
        key_id = f"key-{i}"
        keys[key_id] = await client.generate_key(key_id)
    
    return keys

keys = asyncio.run(generate_keys())
for key_id, key in keys.items():
    print(f"{key_id}: {key}")
```

### Using with HTTP URL

```python
import asyncio
from oasis_rofl_client import RoflClient

async def main():
    client = RoflClient(url="https://rofl.myservice.com")
    key = await client.generate_key("api-key")
    print(f"Generated API key: {key}")

asyncio.run(main())
```

### Error Handling

```python
import asyncio
import httpx
from oasis_rofl_client import RoflClient

async def safe_key_generation():
    client = RoflClient()
    
    try:
        key = await client.generate_key("secure-key")
        print(f"Success: {key}")
    except httpx.HTTPStatusError as e:
        print(f"HTTP error occurred: {e.response.status_code}")
    except httpx.RequestError as e:
        print(f"Request failed: {e}")

asyncio.run(safe_key_generation())
```

## Prerequisites

Install the following tools:

### macOS (using Homebrew)
```bash
# Install Python
brew install python

# Install uv (Python package manager)
brew install uv
```

### Other platforms
- **Python**: Download from [python.org](https://www.python.org/downloads/)
- **UV**: Follow installation instructions at [docs.astral.sh/uv](https://docs.astral.sh/uv/)

Note: `uv publish` is built-in - no need to install separate tools like twine!

## Automatic Versioning

This package uses **dynamic versioning** from git tags. The version is automatically determined:
- **Tagged releases**: `v1.0.0` → Version `1.0.0`
- **Development builds**: Between tags → Version like `1.0.1.dev5+g2345678`

No need to manually update version numbers!

## Development

Create a virtual environment and install dev tools if needed:

```bash
uv venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
uv pip install -e .
```

Run a quick sanity check:

```bash
uv run python - <<'PY'
from oasis_rofl_client import Client
print(Client().ping())
PY
```

## Building the Package

To build the package, run:

```bash
uv build
```

This will create distribution files in the `dist/` directory:
- Source distribution (`.tar.gz`)
- Wheel distribution (`.whl`)

## Automated Publishing with GitHub Actions

This project includes a GitHub Actions workflow that **automatically publishes** to PyPI when you create a new release!

### How It Works

1. **Push a tag** starting with `v`:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **GitHub Actions automatically**:
   - Builds the package with the version from your tag
   - Publishes to TestPyPI (for all tags)
   - Publishes to PyPI (for releases)

### Setup Required

Configure Trusted Publishing (Recommended):

#### For TestPyPI
1. Go to [test.pypi.org](https://test.pypi.org) → Account settings → Publishing
2. Click "Add a new pending publisher"
3. Fill in:
   - **Repository owner**: rube-de
   - **Repository name**: oasis-rofl-client-py
   - **Workflow name**: `publish.yml`
   - **Environment**: `testpypi`
4. Click "Add"

#### For PyPI
1. Go to [PyPI.org](https://pypi.org) → Account settings → Publishing
2. Click "Add a new pending publisher"
3. Fill in:
   - **Repository owner**: rube-de
   - **Repository name**: oasis-rofl-client-py
   - **Workflow name**: `publish.yml`
   - **Environment**: `pypi`
4. Click "Add"

## Manual Publishing with uv

### Publish to TestPyPI

```bash
# Set the TestPyPI URL
export UV_PUBLISH_URL="https://test.pypi.org/legacy/"

# Publish with API token
export UV_PUBLISH_TOKEN="pypi-YOUR_TOKEN_HERE"
uv publish
```

### Publish to PyPI

```bash
# Using API token
export UV_PUBLISH_TOKEN="pypi-YOUR_TOKEN_HERE"
uv publish
```

**Note**: Create API tokens at:
- TestPyPI: [test.pypi.org](https://test.pypi.org/manage/account/#api-tokens)
- PyPI: [pypi.org](https://pypi.org/manage/account/#api-tokens)

## Testing the Uploaded Package

To test your uploaded package from TestPyPI:

```bash
# Create a test environment
uv venv test-env
source test-env/bin/activate  # Windows: test-env\Scripts\activate

# Install from TestPyPI
uv pip install --index-url https://test.pypi.org/simple/ \
               --extra-index-url https://pypi.org/simple/ \
               oasis-rofl-client-rube

# Test the package
uv run python -c "from oasis_rofl_client import Client; print(Client().ping())"
```

## Releasing a New Version

### Automated Release (Recommended)

1. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add amazing feature"
   ```

2. **Create and push a version tag**:
   ```bash
   git tag v1.0.0
   git push origin main --tags
   ```

3. **GitHub Actions handles the rest**:
   - Automatically builds with version `1.0.0`
   - Publishes to TestPyPI
   - To publish to PyPI: Go to GitHub → Releases → "Draft a new release" → Choose tag `v1.0.0` → Publish release

### Manual Release

If you prefer manual control:

1. **Tag your release**:
   ```bash
   git tag v1.0.0
   ```

2. **Build the package** (version comes from tag):
   ```bash
   uv build
   ```

3. **Upload to PyPI**:
   ```bash
   # With token as environment variable
   export UV_PUBLISH_TOKEN="pypi-YOUR_TOKEN_HERE"
   uv publish
   ```

**Note**: Each version can only be uploaded once. The version is automatically set from your git tag - no manual editing needed!

## Important Notes

- You CANNOT delete or overwrite PyPI releases
- Use post-releases for hotfixes: `v1.0.0.post1`
- Always use trusted publishing (no API tokens)
- Protect your main branch
- Test with TestPyPI first

Always verify on TestPyPI first:
```bash
uv pip install --index-url https://test.pypi.org/simple/ \
               --extra-index-url https://pypi.org/simple/ \
               oasis-rofl-client-rube
```

## License

Licensed under the Apache License, Version 2.0. See `LICENSE` for details or visit http://www.apache.org/licenses/LICENSE-2.0.