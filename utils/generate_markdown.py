#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os
import re
from pathlib import Path
from typing import Dict, List, Any
from loguru import logger


def extract_category(file_path: str) -> str:
    """从文件路径中提取组件分类

    Args:
        file_path: 文件路径，格式为 gallery/qml/Examples/Category/ExpComponent.qml

    Returns:
        分类名称，如DataDisplay、Feedback等
    """
    for separator in ["/", "\\"]:
        parts = file_path.split(separator)
        try:
            examples_idx = parts.index("Examples")
            if examples_idx + 1 < len(parts):
                return parts[examples_idx + 1]
        except ValueError:
            continue
    return "Unknown"


def process_internal_links(
    text: str, category: str, component_map: Dict[str, str]
) -> str:
    """处理内部链接，将internal://转换为markdown链接

    Args:
        text: 包含链接的文本
        category: 当前组件所在的分类
        component_map: 组件名到filePath的映射字典

    Returns:
        处理后的文本
    """
    pattern = r"\[([^\]]+)\]\(internal://([^)]+)\)"

    def replace_link(match: Any) -> str:
        link_text = match.group(1)
        component = match.group(2)

        target_filepath = component_map.get(component)
        if not target_filepath:
            # 不区分大小写查找
            for key, filepath in component_map.items():
                if key.lower() == component.lower():
                    target_filepath = filepath
                    break

        if not target_filepath:
            return f"[{link_text}](./{component}.md)"

        target_category = extract_category(target_filepath)
        target_filename = component

        if target_category == category:
            return f"[{link_text}](./{target_filename}.md)"
        else:
            return f"[{link_text}](../{target_category}/{target_filename}.md)"

    return re.sub(pattern, replace_link, text)


def clean_escape_sequences(text: str, preserve_newlines: bool = False) -> str:
    """清理文本中的转义序列

    Args:
        text: 需要清理的文本
        preserve_newlines: 是否保留\\n为字面量（代码块场景使用True）

    Returns:
        清理后的文本
    """
    if not text:
        return text

    text = text.replace("\\`\\`", "``")
    text = text.replace("\\`", "`")
    text = text.replace("\\t", "\t")
    text = text.replace('\\"', '"')
    text = text.replace("\\'", "'")
    text = text.replace("\\\\", "\\")

    if not preserve_newlines:
        text = text.replace("\\n", "\n")

    return text


def remove_leading_indent(code: str, indent_size: int = 16) -> str:
    """移除代码每一行的前N个空格

    Args:
        code: 代码文本
        indent_size: 要移除的前导空格数

    Returns:
        处理后的代码
    """
    lines = code.split("\n")
    cleaned_lines = []
    for line in lines:
        if line.startswith(" " * indent_size):
            cleaned_lines.append(line[indent_size:])
        elif line.strip():
            cleaned_lines.append(line)
        else:
            cleaned_lines.append("")
    return "\n".join(cleaned_lines).strip()


def generate_component_file(
    component: Dict[str, Any],
    category_dir: Path,
    current_category: str,
    component_map: Dict[str, str],
) -> str:
    """生成单个组件的文档文件

    Args:
        component: 组件信息字典
        category_dir: 分类目录路径
        current_category: 当前分类
        component_map: 组件名到docPath的映射字典

    Returns:
        生成的组件名称
    """
    name = component["name"]
    file_path = os.path.join(category_dir, f"{name}.md")

    doc = clean_escape_sequences(component["doc"])
    doc = process_internal_links(doc, current_category, component_map)
    doc_title = doc.split("\n")[0].replace("# ", "").replace("\\n", "")
    if not doc_title:
        doc_title = name
    doc_content = "\n".join(doc.split("\n")[1:])

    content = "[← 返回主目录](../index.md)\n\n"
    content += "[← 返回本类别目录](./index.md)\n\n"
    content += f"# {doc_title}\n\n"
    content += f"{doc_content}\n\n<br/>\n\n"

    examples = component.get("examples", [])
    if examples:
        content += "## 代码演示\n\n"
        for i, example in enumerate(examples, 1):
            content += f"### 示例 {i}"

            if example.get("title"):
                title = clean_escape_sequences(example["title"])
                content += f" - {title}\n\n"
            else:
                content += "\n\n"

            if example.get("description"):
                desc = clean_escape_sequences(example["description"])
                desc = process_internal_links(desc, current_category, component_map)
                content += f"{desc}\n\n"

            if example.get("code"):
                code = clean_escape_sequences(example["code"], preserve_newlines=True)
                code = remove_leading_indent(code)
                content += f"```qml\n{code}\n```\n\n"

            if i < len(examples):
                content += "---\n\n"

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

    return name


def generate_index_file(categories: Dict[str, List[Dict[str, Any]]]) -> None:
    """生成index.md文件"""
    content = "# HuskarUI 组件文档\n\n## 目录\n\n"

    for category, comps in sorted(categories.items()):
        content += f"## [{category}](./{category}/index.md)\n"
        for comp in comps:
            name = comp["name"]
            doc_title = comp["doc"].split("\n")[0].replace("# ", "").replace("\\n", "")
            if not doc_title:
                doc_title = name
            content += f" - [{doc_title}](./{category}/{name}.md)\n"

    with open("docs/index.md", "w", encoding="utf-8") as f:
        f.write(content)


def generate_category_index(
    category: str, components: List[Dict[str, Any]], category_dir: Path
) -> None:
    """生成分类目录下的index.md文件"""
    content = "[← 返回主目录](../index.md)\n\n"
    content += f"# {category}\n\n"
    content += f"{category}分类包含以下组件：\n\n"

    for comp in components:
        name = comp["name"]
        doc_title = comp["doc"].split("\n")[0].replace("# ", "").replace("\\n", "")
        if not doc_title:
            doc_title = name
        content += f"- [{doc_title}](./{name}.md)\n"

    with open(os.path.join(category_dir, "index.md"), "w", encoding="utf-8") as f:
        f.write(content)


def generate_markdown(meta_file_path: Path) -> None:
    """生成完整的文档结构

    Args:
        meta_file_path: 元数据JSON文件路径
    """
    with open(meta_file_path, "r", encoding="utf-8") as f:
        components = json.load(f)

    # 按分类组织组件
    categories: Dict[str, List[Dict[str, Any]]] = {}
    for comp in components:
        category = extract_category(comp["docPath"])
        if category not in categories:
            categories[category] = []
        categories[category].append(comp)

    # 构建组件名到filePath的映射
    component_map = {comp["name"]: comp["docPath"] for comp in components}

    # 创建文档目录结构
    docs_dir = Path("docs")
    docs_dir.mkdir(exist_ok=True)

    # 生成主index.md文件
    generate_index_file(categories)

    # 为每个分类生成文件
    for category, comps in sorted(categories.items()):
        category_dir = docs_dir / category
        category_dir.mkdir(exist_ok=True)
        generate_category_index(category, comps, category_dir)
        for comp in comps:
            generate_component_file(comp, category_dir, category, component_map)

    logger.info(f"文档已生成到docs目录")
    logger.info(f"共包含 {len(components)} 个组件")
    logger.info(f"分类: {', '.join(sorted(categories.keys()))}")
