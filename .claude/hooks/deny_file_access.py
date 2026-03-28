#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""
PreToolUse hook that enforces file access deny rules for Read, Write, Edit, and related tools.
Mirrors the deny patterns in settings.json permissions that are currently bugged.
"""

import json
import sys
import fnmatch
import os
from pathlib import Path

# fnmatch patterns, not regex
DENY_EXTENSION_PATTERNS = [
  ".env*",
  "credentials",
  "credentials.json",
]

# fnmatch patterns, not regex
ALLOW_EXTENSION_PATTERNS = [
  ".envrc",
  ".env.sample",
  ".env.example",
]

# Paths that should never be written to (absolute patterns)
# fnmatch patterns, not regex
DENY_WRITE_PATTERNS = [
    str(Path.home()) + "/*",
]

# Paths that should never be read (absolute patterns)
# fnmatch patterns, not regex
DENY_READ_PATTERNS = [
    str(Path.home()) + "/*",
]

# Exceptions - paths that ARE allowed despite matching deny patterns above
# Only allow cwd if it is not the home directory itself or a parent of home
def _safe_cwd_allow_patterns() -> list[str]:
    home = Path.home().resolve()
    cwd = Path.cwd().resolve()
    # Disallow if cwd IS home, or cwd is a parent of home (e.g. /)
    if cwd == home or home.is_relative_to(cwd):
        return []
    return [str(cwd) + "/*"]

ALLOW_WRITE_PATTERNS: list[str] = _safe_cwd_allow_patterns()
ALLOW_READ_PATTERNS: list[str] = _safe_cwd_allow_patterns()

# Tools that read files
READ_TOOLS = {"Read", "Grep", "Glob"}
# Tools that write/edit files
WRITE_TOOLS = {"Write", "Edit", "MultiEdit", "NotebookEdit"}


def matches_any(path: str, patterns: list[str]) -> bool:
    for pattern in patterns:
        if fnmatch.fnmatch(path, pattern):
            return True
    return False


def expand_path(raw: str) -> str:
    """Expand ~ and resolve to absolute path."""
    return str(Path(raw).expanduser().resolve())


def deny(reason: str) -> None:
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        },
    }))
    sys.exit(2) # block the call


def main():
    data = json.load(sys.stdin)
    tool_name = data.get("tool_name", "")
    tool_input = data.get("tool_input", {})

    raw_path = tool_input.get("file_path") or tool_input.get("path", "")
    if not raw_path:
        sys.exit(0) # allow the call

    path = expand_path(raw_path)

    if tool_name in WRITE_TOOLS:
        if matches_any(path, DENY_WRITE_PATTERNS) and not matches_any(path, ALLOW_WRITE_PATTERNS):
            deny(f"Write access denied: {path} matches a deny pattern")

    if tool_name in READ_TOOLS:
        if matches_any(path, DENY_READ_PATTERNS) and not matches_any(path, ALLOW_READ_PATTERNS):
            deny(f"Read access denied: {path} matches a deny pattern")

    name = Path(path).name
    if matches_any(name, DENY_EXTENSION_PATTERNS) and not matches_any(name,ALLOW_EXTENSION_PATTERNS):
        deny(f"Access denied: {path} matches a denied extension pattern")

    sys.exit(0) # allow the call


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Hook error: {e}", file=sys.stderr)
        exit(2) # block the call
