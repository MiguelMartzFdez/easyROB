"""Adjust the bundled ROBERT wheel for Numba's Intel macOS support."""

from __future__ import annotations

import base64
import csv
import hashlib
import io
import sys
import zipfile
from pathlib import Path


OLD_REQUIREMENT = "Requires-Dist: numba==0.66.0"
INTEL_REQUIREMENT = (
    'Requires-Dist: numba==0.62.1; sys_platform == "darwin" '
    'and platform_machine == "x86_64"'
)
OTHER_REQUIREMENT = (
    'Requires-Dist: numba==0.66.0; sys_platform != "darwin" '
    'or platform_machine != "x86_64"'
)


def patch_robert_wheel(source_path: Path, destination_path: Path) -> None:
    """Write a macOS wheel with a valid RECORD and an Intel Numba pin."""
    if Path(source_path).resolve() == Path(destination_path).resolve():
        raise ValueError("Source and destination ROBERT wheels must differ")
    with zipfile.ZipFile(source_path) as source:
        metadata_names = [name for name in source.namelist() if name.endswith(".dist-info/METADATA")]
        record_names = [name for name in source.namelist() if name.endswith(".dist-info/RECORD")]
        if len(metadata_names) != 1 or len(record_names) != 1:
            raise ValueError("ROBERT wheel must contain one METADATA file and one RECORD file")
        metadata_name, record_name = metadata_names[0], record_names[0]
        original_metadata = source.read(metadata_name)
        newline = b"\r\n" if b"\r\n" in original_metadata else b"\n"
        old_line = OLD_REQUIREMENT.encode() + newline
        if original_metadata.count(old_line) != 1:
            raise ValueError("ROBERT wheel does not have the expected Numba requirement")
        replacement = newline.join(
            (INTEL_REQUIREMENT.encode(), OTHER_REQUIREMENT.encode(), b"")
        )
        metadata = original_metadata.replace(old_line, replacement, 1)

        records = list(csv.reader(io.StringIO(source.read(record_name).decode("utf-8"))))
        metadata_rows = [row for row in records if row[0] == metadata_name]
        if len(metadata_rows) != 1:
            raise ValueError("ROBERT wheel RECORD must contain its METADATA file")
        digest = base64.urlsafe_b64encode(hashlib.sha256(metadata).digest()).rstrip(b"=").decode()
        metadata_rows[0][1:] = [f"sha256={digest}", str(len(metadata))]
        record_stream = io.StringIO(newline="")
        csv.writer(record_stream, lineterminator="\n").writerows(records)
        record = record_stream.getvalue().encode("utf-8")

        with zipfile.ZipFile(destination_path, "w") as destination:
            for member in source.infolist():
                data = (
                    metadata if member.filename == metadata_name else
                    record if member.filename == record_name else
                    source.read(member.filename)
                )
                destination.writestr(member, data)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("Usage: patch_robert_wheel.py SOURCE_WHEEL DESTINATION_WHEEL")
    patch_robert_wheel(Path(sys.argv[1]), Path(sys.argv[2]))
