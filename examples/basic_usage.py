#!/usr/bin/env python
"""Basic usage example for oasis-rofl-client."""

import asyncio
import logging
import sys
from pathlib import Path

# Add parent directory to path for development
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from oasis_rofl_client import RoflClient

# Configure logging to see debug messages
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)


async def main():
    """Demonstrate basic RoflClient usage."""
    
    # Create client with default Unix socket
    client = RoflClient()
    print(f"Client created with default socket: {client.ROFL_SOCKET_PATH}")
    
    # Generate a key (requires running ROFL service)
    try:
        key = await client.generate_key("my-first-key")
        print(f"Generated key: {key}")
    except Exception as e:
        print(f"Note: Key generation requires a running ROFL service")
        print(f"Error: {e}")


if __name__ == "__main__":
    asyncio.run(main())