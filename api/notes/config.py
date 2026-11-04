import os

MONGO_URI = os.environ.get(
    "MONGO_URI",
    "mongodb://localhost:27017/notes",
)

LOG_FILE = os.environ.get("LOG_FILE") or None

LIST_LIMIT = 100
TITLE_MAX_LENGTH = 120