import os
import sys

print("=== debug start ===", file=sys.stderr)
print("=== debug start ===", file=sys.stderr)
print("=== debug start ===", file=sys.stderr)
print("=== debug start ===", file=sys.stderr)
print("=== debug start ===", file=sys.stderr)
print("cwd:", os.getcwd(), file=sys.stderr)
print("__file__:", __file__, file=sys.stderr)
print("sys.path before:", sys.path, file=sys.stderr)

# 把 script 所在目录 / server 目录加入 sys.path
script_dir = os.path.dirname(__file__)
if script_dir not in sys.path:
    sys.path.insert(0, script_dir)
pkg_root = os.path.abspath(os.path.join(script_dir, ".."))
if pkg_root not in sys.path:
    sys.path.insert(0, pkg_root)

print("sys.path after:", sys.path, file=sys.stderr)

from fastmcp import FastMCP

app = FastMCP(name="example_mcp")

@app.tool()
def greetings(name:str):

    """
    :param name:
    :return: Hello + name
    """

    return f"Hello {name}"

if __name__ == "__main__":
    app.run(transport="stdio")
