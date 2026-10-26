"""Adjust the bundled ROBERT wheel for macOS compatibility."""

from __future__ import annotations

import base64
import csv
import hashlib
import io
import sys
import zipfile
from pathlib import Path


OLD_REQUIREMENT = "Requires-Dist: numba==0.66.0"
UNIFIED_REQUIREMENT = "Requires-Dist: numba==0.62.1"
INTEL_REQUIREMENT = (
    'Requires-Dist: numba==0.62.1; sys_platform == "darwin" '
    'and platform_machine == "x86_64"'
)
OTHER_REQUIREMENT = (
    'Requires-Dist: numba==0.66.0; sys_platform != "darwin" '
    'or platform_machine != "x86_64"'
)
WINDOW_NAME = "robert/gui_easyrob/main/window.py"
OLD_EVENT_FILTER = b'if application is not None and sys.platform != "linux":'
SAFE_EVENT_FILTER = b'if application is not None and sys.platform == "win32":'


def patch_robert_wheel(source_path: Path, destination_path: Path) -> None:
    """Write a macOS wheel with compatible dependencies and Qt event handling."""
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
        if original_metadata.count(old_line) == 1:
            replacement = newline.join(
                (INTEL_REQUIREMENT.encode(), OTHER_REQUIREMENT.encode(), b"")
            )
            metadata = original_metadata.replace(old_line, replacement, 1)
        elif original_metadata.count(UNIFIED_REQUIREMENT.encode() + newline) == 1:
            metadata = original_metadata
        elif all(
            original_metadata.count(requirement.encode() + newline) == 1
            for requirement in (INTEL_REQUIREMENT, OTHER_REQUIREMENT)
        ):
            metadata = original_metadata
        else:
            raise ValueError("ROBERT wheel does not have the expected Numba requirements")
        if WINDOW_NAME not in source.namelist():
            raise ValueError("ROBERT wheel does not contain the EasyRob main window")
        original_window = source.read(WINDOW_NAME)
        if original_window.count(OLD_EVENT_FILTER) == 1:
            window = original_window.replace(OLD_EVENT_FILTER, SAFE_EVENT_FILTER, 1)
        elif original_window.count(SAFE_EVENT_FILTER) == 1:
            window = original_window
        else:
            raise ValueError("ROBERT wheel does not have the expected Qt event filter")

        records = list(csv.reader(io.StringIO(source.read(record_name).decode("utf-8"))))
        for name, data in ((metadata_name, metadata), (WINDOW_NAME, window)):
            matching_rows = [row for row in records if row[0] == name]
            if len(matching_rows) != 1:
                raise ValueError(f"ROBERT wheel RECORD must contain exactly one {name} entry")
            digest = base64.urlsafe_b64encode(hashlib.sha256(data).digest()).rstrip(b"=").decode()
            matching_rows[0][1:] = [f"sha256={digest}", str(len(data))]
        record_stream = io.StringIO(newline="")
        csv.writer(record_stream, lineterminator="\n").writerows(records)
        record = record_stream.getvalue().encode("utf-8")

        with zipfile.ZipFile(destination_path, "w") as destination:
            for member in source.infolist():
                data = (
                    metadata if member.filename == metadata_name else
                    window if member.filename == WINDOW_NAME else
                    record if member.filename == record_name else
                    source.read(member.filename)
                )
                destination.writestr(member, data)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("Usage: patch_robert_wheel.py SOURCE_WHEEL DESTINATION_WHEEL")
    patch_robert_wheel(Path(sys.argv[1]), Path(sys.argv[2]))
