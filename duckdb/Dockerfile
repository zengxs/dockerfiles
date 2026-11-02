# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-slim-bookworm

ARG DUCKDB_VERSION=2.0.0

ENV DUCKDB_VERSION=${DUCKDB_VERSION} \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH=/opt/venv/bin:$PATH

RUN python -m venv /opt/venv \
    && /opt/venv/bin/python -m pip install \
       --only-binary=:all: \
       "duckdb==${DUCKDB_VERSION}"

RUN /opt/venv/bin/python - <<'PY'
import hashlib
import io
import os
from pathlib import Path
import subprocess
import tarfile
from urllib.request import Request, urlopen

version = os.environ["DUCKDB_VERSION"]
url = (
    f"https://github.com/duckdb/duckdb/releases/download/v{version}/"
    "duckdb-cli-linux-amd64.tar.gz"
)
request = Request(url, headers={"User-Agent": "duckdb-tools-image-builder"})
with urlopen(request, timeout=120) as response:
    archive = response.read()

with tarfile.open(fileobj=io.BytesIO(archive), mode="r:gz") as tar:
    candidates = [m for m in tar.getmembers()
                  if m.isfile() and Path(m.name).name == "duckdb"]
    assert len(candidates) == 1, "Expected exactly one DuckDB CLI binary"
    binary = Path("/opt/duckdb/bin/duckdb")
    binary.parent.mkdir(parents=True, exist_ok=True)
    binary.write_bytes(tar.extractfile(candidates[0]).read())
    binary.chmod(0o755)

actual = subprocess.check_output(
    [str(binary), "-csv", "-noheader", "-c", "SELECT version();"], text=True
).strip()
assert actual == f"v{version}", f"Unexpected CLI version: {actual}"
print(f"CLI_OK: {actual}")
PY

RUN /opt/venv/bin/python - <<'PY'
import gzip
import os
from pathlib import Path
from urllib.request import Request, urlopen

import duckdb

version = os.environ["DUCKDB_VERSION"]
assert duckdb.__version__ == version

extension_root = Path("/opt/duckdb/extensions")
con = duckdb.connect(config={
    "extension_directory": str(extension_root),
    "threads": 2,
})

platform = con.execute("PRAGMA platform").fetchone()[0]
assert platform == "linux_amd64", f"Unexpected platform: {platform}"

destination = extension_root / f"v{version}" / platform
destination.mkdir(parents=True, exist_ok=True)

for name in ("httpfs", "iceberg"):
    url = (
        f"https://extensions.duckdb.org/v{version}/"
        f"{platform}/{name}.duckdb_extension.gz"
    )
    request = Request(url, headers={
        "User-Agent": f"duckdb/v{version}({platform})"
    })
    with urlopen(request, timeout=120) as response:
        content = gzip.decompress(response.read())

    (destination / f"{name}.duckdb_extension").write_bytes(content)
    con.execute(f"LOAD {name}")
    print(f"EXTENSION_OK: {name}")

con.close()
PY

COPY --chmod=0755 <<'SH' /usr/local/bin/duckdb
#!/bin/sh
exec /opt/duckdb/bin/duckdb \
  -cmd "SET extension_directory='/opt/duckdb/extensions'; LOAD httpfs; LOAD iceberg;" \
  "$@"
SH

RUN groupadd --gid 10001 duckdb \
    && useradd --uid 10001 --gid 10001 \
       --create-home --shell /bin/bash duckdb \
    && mkdir -p /work \
    && chown 10001:10001 /work

RUN apt update -yq && apt install -yq vim

WORKDIR /work
USER 10001:10001

RUN /usr/local/bin/duckdb -batch -c \
    "SELECT version(); SELECT extension_name, loaded FROM duckdb_extensions() WHERE extension_name IN ('httpfs', 'iceberg');"

CMD ["sleep", "infinity"]
