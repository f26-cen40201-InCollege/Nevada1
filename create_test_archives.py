from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile

# made with ai to simply handle outputs

ROOT = Path(__file__).resolve().parent
TESTS_DIR = ROOT / "tests"
ZIPS_DIR = ROOT / "zips"
OUTPUT_NAMES = {"output.txt", "epic-output.txt"}


def main():
    ZIPS_DIR.mkdir(exist_ok=True)

    for epic_dir in sorted(TESTS_DIR.glob("epic-*")):
        if not epic_dir.is_dir():
            continue

        files = sorted(path for path in epic_dir.rglob("*") if path.is_file())
        output_files = [path for path in files if path.name in OUTPUT_NAMES]
        input_files = [path for path in files if path.name not in OUTPUT_NAMES]

        for suffix, archive_files in (
            ("output", output_files),
            ("inputs", input_files),
        ):
            archive_path = ZIPS_DIR / f"{epic_dir.name}-{suffix}.zip"
            with ZipFile(archive_path, "w", ZIP_DEFLATED) as archive:
                for path in archive_files:
                    archive.write(path, path.relative_to(ROOT))

            print(f"Created {archive_path.relative_to(ROOT)} ({len(archive_files)} files)")


if __name__ == "__main__":
    main()