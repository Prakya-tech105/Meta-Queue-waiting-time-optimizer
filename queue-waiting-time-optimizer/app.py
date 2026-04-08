from __future__ import annotations

import os
from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from src.gradio_app import build_demo


def main() -> None:
    demo = build_demo()
    # Spaces requires 0.0.0.0, while localhost is best for local preview.
    host = "0.0.0.0" if os.getenv("SPACE_ID") else "127.0.0.1"
    demo.launch(server_name=host)


if __name__ == "__main__":
    main()
