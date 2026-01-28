#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
from pathlib import Path
from loguru import logger
from shutil import rmtree

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from extract_docs import extract_all_docs, save_docs_to_json
from generate_markdown import generate_markdown


def gen_docs() -> None:
    cwd = (Path(__file__) / "../../").resolve()
    docs_dir = cwd / "docs"
    if docs_dir.exists():
        rmtree(docs_dir)
    examples_dir = cwd / "gallery/qml/Examples"
    output_meta_path = cwd / "docs/guide.metainfo.json"
    docs = extract_all_docs(examples_dir, cwd)
    save_docs_to_json(docs, output_meta_path)
    generate_markdown(str(output_meta_path))


if __name__ == "__main__":
    gen_docs()
