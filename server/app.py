import json
import socket
from inference import app


def _find_available_port(start_port: int = 7860, max_attempts: int = 10) -> int:
	"""Find an available port starting from start_port."""
	for offset in range(max_attempts):
		port = start_port + offset
		try:
			with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
				s.bind(("0.0.0.0", port))
				s.close()
				return port
		except OSError:
			continue
	raise RuntimeError(f"Could not find available port in range {start_port}-{start_port + max_attempts - 1}")


def main() -> None:
	import os
	import uvicorn

	configured_port = int(os.getenv("PORT", "7860"))
	try:
		available_port = _find_available_port(configured_port)
	except RuntimeError:
		# If couldn't find a port, use port 0 to let OS assign one
		available_port = 0

	print(json.dumps({
		"event": "SERVICE_START",
		"configured_port": configured_port,
		"actual_port": available_port,
		"message": f"Starting FastAPI server on port {available_port if available_port > 0 else 'auto-assigned'}"
	}, ensure_ascii=True), flush=True)
	
	uvicorn.run(app, host="0.0.0.0", port=available_port)


if __name__ == "__main__":
	main()
