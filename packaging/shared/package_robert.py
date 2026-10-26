"""Build a portable ROBERT wheel from the active Python environment's source."""

from __future__ import annotations

import importlib.metadata
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ASSETS_DIR = Path(__file__).resolve().parent / "assets"
SOURCE_FILES = ("setup.py", "setup.cfg", "README.md", "LICENSE")


def main() -> int:
    distribution = importlib.metadata.distribution("robert")
    import robert

    source_root = Path(robert.__file__).resolve().parent.parent
    if not (source_root / "setup.py").is_file():
        raise RuntimeError(f"ROBERT source checkout was not found at {source_root}")

    ASSETS_DIR.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(
        prefix="easyrob-robert-wheel-", dir=ASSETS_DIR
    ) as temp_dir:
        staged_source = Path(temp_dir) / "source"
        staged_source.mkdir()
        for name in SOURCE_FILES:
            source_file = source_root / name
            if source_file.is_file():
                shutil.copy2(source_file, staged_source / name)
        shutil.copytree(
            source_root / "robert",
            staged_source / "robert",
            ignore=shutil.ignore_patterns(".git", "__pycache__", "*.pyc", ".pytest_cache"),
        )
        wheel_dir = Path(temp_dir) / "wheel"
        wheel_dir.mkdir()
        build_env = os.environ.copy()
        build_env.update({name: temp_dir for name in ("TMP", "TEMP", "TMPDIR")})
        subprocess.run(
            [
                sys.executable,
                "-m",
                "pip",
                "wheel",
                "--no-deps",
                "--no-build-isolation",
                "--no-cache-dir",
                "--wheel-dir",
                str(wheel_dir),
                str(staged_source),
            ],
            check=True,
            env=build_env,
        )
        wheels = list(wheel_dir.glob("robert-*.whl"))
        if len(wheels) != 1:
            raise RuntimeError(f"Expected one ROBERT wheel, found {len(wheels)}")
        wheel = wheels[0]
        if not wheel.name.startswith(f"robert-{distribution.version}-"):
            raise RuntimeError(
                f"Built wheel {wheel.name} does not match installed ROBERT {distribution.version}"
            )
        destination = ASSETS_DIR / wheel.name
        shutil.copy2(wheel, destination)
        for previous_wheel in ASSETS_DIR.glob("robert-*.whl"):
            if previous_wheel != destination:
                previous_wheel.unlink()

    print(f"Bundled ROBERT {distribution.version} from {source_root}")
    print(f"Wheel: {destination}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
