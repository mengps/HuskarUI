#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
from pathlib import Path
from loguru import logger

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from extract_docs import extract_all_docs, save_docs_to_json
from generate_markdown import generate_markdown


def main() -> None:
    """主函数：提取文档并生成markdown"""
    # 提取所有文档
    docs = extract_all_docs()

    # 保存到JSON文件
    output_meta_path = Path(__file__).parent.parent / "docs/guide.metainfo.json"
    save_docs_to_json(docs, output_meta_path)

    logger.info(f"文档已提取并保存到 {output_meta_path}")
    logger.info(f"共提取了 {len(docs)} 个组件的文档")

    # 生成markdown文件
    generate_markdown(str(output_meta_path))


if __name__ == "__main__":
    main()
