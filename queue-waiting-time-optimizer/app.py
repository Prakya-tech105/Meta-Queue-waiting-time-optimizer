from __future__ import annotations

from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from src.gradio_app import build_demo


def main() -> None:
    demo = build_demo()
    # Bind to localhost for direct browser access and let Gradio pick an open port.
    demo.launch(server_name="127.0.0.1")


if __name__ == "__main__":
    main()
