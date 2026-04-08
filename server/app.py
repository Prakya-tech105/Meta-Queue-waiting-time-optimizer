from inference import app


def main() -> None:
	import os
	import uvicorn

	uvicorn.run(app, host="0.0.0.0", port=int(os.getenv("PORT", "7860")))


if __name__ == "__main__":
	main()
