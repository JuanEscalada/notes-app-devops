from pathlib import Path
import runpy


CONFIG_PATH = Path(__file__).resolve().parents[1] / "notes" / "config.py"


def load_config():
    return runpy.run_path(str(CONFIG_PATH))


def test_default_configuration(monkeypatch):
    monkeypatch.delenv("MONGO_URI", raising=False)
    monkeypatch.delenv("LOG_FILE", raising=False)

    config = load_config()

    assert config["MONGO_URI"] == "mongodb://localhost:27017/notes"
    assert config["LOG_FILE"] is None


def test_configuration_from_environment(monkeypatch):
    monkeypatch.setenv("MONGO_URI", "mongodb://mongo:27017/notes")
    monkeypatch.setenv("LOG_FILE", "/tmp/notes.log")

    config = load_config()

    assert config["MONGO_URI"] == "mongodb://mongo:27017/notes"
    assert config["LOG_FILE"] == "/tmp/notes.log"


def test_empty_log_file_disables_file_logging(monkeypatch):
    monkeypatch.setenv("LOG_FILE", "")

    config = load_config()

    assert config["LOG_FILE"] is None