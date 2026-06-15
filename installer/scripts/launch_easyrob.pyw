"""Launch EasyRob using only its bundled Conda environment."""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path


def configure_private_environment() -> None:
    app_dir = Path(__file__).resolve().parent
    miniforge_dir = app_dir / "miniforge"
    env_dir = miniforge_dir / "envs" / "easyrob"

    private_paths = [
        env_dir,
        env_dir / "Scripts",
        env_dir / "Library" / "bin",
        env_dir / "Library" / "usr" / "bin",
        env_dir / "Library" / "mingw-w64" / "bin",
        miniforge_dir / "condabin",
    ]

    existing_path = os.environ.get("PATH", "")
    os.environ["PATH"] = os.pathsep.join(
        [str(path) for path in private_paths if path.exists()] + [existing_path]
    )
    os.environ["CONDA_PREFIX"] = str(env_dir)
    os.environ["CONDA_DEFAULT_ENV"] = "easyrob"
    os.environ["CONDA_SHLVL"] = "1"


def suppress_console_subprocesses() -> None:
    if os.name != "nt":
        return

    original_popen = subprocess.Popen

    def hidden_popen(*args, **kwargs):
        creationflags = kwargs.get("creationflags", 0)
        kwargs["creationflags"] = creationflags | subprocess.CREATE_NO_WINDOW

        startupinfo = kwargs.get("startupinfo")
        if startupinfo is None:
            startupinfo = subprocess.STARTUPINFO()

        startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        startupinfo.wShowWindow = subprocess.SW_HIDE
        kwargs["startupinfo"] = startupinfo

        return original_popen(*args, **kwargs)

    subprocess.Popen = hidden_popen


def main() -> int:
    configure_private_environment()
    suppress_console_subprocesses()
    from robert.gui_easyrob.easyrob_launcher import main as easyrob_main

    result = easyrob_main()
    return result if isinstance(result, int) else 0


if __name__ == "__main__":
    sys.exit(main())
