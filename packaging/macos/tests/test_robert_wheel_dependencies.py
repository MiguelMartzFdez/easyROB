"""Regression tests for macOS ROBERT wheel dependency metadata."""

from __future__ import annotations

import base64
import csv
import hashlib
import io
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

from packaging.requirements import Requirement

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from patch_robert_wheel import patch_robert_wheel


class RobertWheelDependenciesTest(unittest.TestCase):
    def test_bundled_wheel_can_be_patched(self) -> None:
        asset_directory = Path(__file__).resolve().parents[2] / "shared" / "assets"
        wheels = list(asset_directory.glob("robert-*.whl"))
        self.assertEqual(len(wheels), 1)
        with tempfile.TemporaryDirectory() as directory:
            wheel = Path(directory) / wheels[0].name
            patch_robert_wheel(wheels[0], wheel)
            with zipfile.ZipFile(wheel) as archive:
                self.assertIsNone(archive.testzip())
                metadata_name = next(
                    name for name in archive.namelist() if name.endswith(".dist-info/METADATA")
                )
                metadata = archive.read(metadata_name)
            self.assertIn(b"Requires-Dist: numba==0.62.1", metadata)

    def test_patches_numba_for_intel_macos_and_updates_record(self) -> None:
        with tempfile.TemporaryDirectory(dir=Path(__file__).parent) as directory:
            source_wheel = Path(directory) / "source.whl"
            wheel = Path(directory) / "robert-2.2.1-py3-none-any.whl"
            metadata_name = "robert-2.2.1.dist-info/METADATA"
            record_name = "robert-2.2.1.dist-info/RECORD"
            with zipfile.ZipFile(source_wheel, "w") as archive:
                archive.writestr(
                    metadata_name,
                    "Metadata-Version: 2.4\nName: robert\nVersion: 2.2.1\n"
                    "Requires-Dist: numba==0.66.0\nRequires-Dist: shap==0.52.0\n",
                )
                archive.writestr(record_name, f"{metadata_name},,\n{record_name},,\n")

            patch_robert_wheel(source_wheel, wheel)

            with zipfile.ZipFile(wheel) as archive:
                metadata = archive.read(metadata_name)
                rows = list(csv.reader(io.StringIO(archive.read(record_name).decode())))
            self.assertIn(
                b'Requires-Dist: numba==0.62.1; sys_platform == "darwin" and platform_machine == "x86_64"',
                metadata,
            )
            self.assertIn(
                b'Requires-Dist: numba==0.66.0; sys_platform != "darwin" or platform_machine != "x86_64"',
                metadata,
            )
            self.assertIn(b"Requires-Dist: shap==0.52.0", metadata)
            numba_requirements = [
                Requirement(line.removeprefix("Requires-Dist: "))
                for line in metadata.decode().splitlines()
                if line.startswith("Requires-Dist: numba")
            ]
            for platform, machine, version in (
                ("darwin", "x86_64", "==0.62.1"),
                ("darwin", "arm64", "==0.66.0"),
                ("linux", "x86_64", "==0.66.0"),
                ("win32", "AMD64", "==0.66.0"),
            ):
                active = [
                    requirement
                    for requirement in numba_requirements
                    if requirement.marker.evaluate(
                        {"sys_platform": platform, "platform_machine": machine}
                    )
                ]
                self.assertEqual(len(active), 1)
                self.assertEqual(str(active[0].specifier), version)
            metadata_row = next(row for row in rows if row[0] == metadata_name)
            digest = base64.urlsafe_b64encode(hashlib.sha256(metadata).digest()).rstrip(b"=").decode()
            self.assertEqual(metadata_row[1], f"sha256={digest}")
            self.assertEqual(metadata_row[2], str(len(metadata)))


if __name__ == "__main__":
    unittest.main()
