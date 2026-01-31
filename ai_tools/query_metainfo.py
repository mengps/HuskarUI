import json
import argparse
import sys
import os

def load_metainfo(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error reading file {file_path}: {e}")
        sys.exit(1)

def find_component(data, name):
    for component in data:
        if component.get('name') == name:
            return component
    return None

def search_components(data, keyword):
    results = []
    keyword = keyword.lower()
    for component in data:
        name = component.get('name', '').lower()
        doc = component.get('doc', '').lower()
        if keyword in name or keyword in doc:
            results.append(component['name'])
    return results

def format_component(component):
    output = []
    output.append(f"# {component.get('name')}")
    output.append(component.get('doc', 'No documentation available.'))
    
    examples = component.get('examples', [])
    if examples:
        output.append("\n## Examples")
        for ex in examples:
            output.append(f"\n### {ex.get('title', 'Example')}")
            output.append(ex.get('description', ''))
            output.append("```qml")
            output.append(ex.get('code', ''))
            output.append("```")
    
    return "\n".join(output)

def main():
    parser = argparse.ArgumentParser(description="Query component metadata.")
    parser.add_argument('file', help="Path to the metainfo.json file")
    parser.add_argument('query', help="Component name, 'list', or search keyword")
    parser.add_argument('--exact', action='store_true', help="Match component name exactly")

    args = parser.parse_args()

    if not os.path.exists(args.file):
        print(f"File not found: {args.file}")
        sys.exit(1)

    data = load_metainfo(args.file)

    if args.query == 'list':
        names = [c.get('name') for c in data]
        print("\n".join(names))
        return

    # Try exact match first if requested or if it looks like a component name
    component = find_component(data, args.query)
    if component:
        print(format_component(component))
        return

    if args.exact:
        print(f"Component '{args.query}' not found.")
        return

    # Search
    results = search_components(data, args.query)
    if results:
        print(f"Found {len(results)} matching components:")
        for name in results:
            print(f"- {name}")
        
        if len(results) == 1:
            print("\nDisplaying details for the single match:")
            print(format_component(find_component(data, results[0])))
    else:
        print(f"No components found matching '{args.query}'.")

if __name__ == "__main__":
    main()
