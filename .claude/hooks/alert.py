#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///

import argparse
import os
import random
import re
import subprocess
import sys
from typing import Optional

# No longer need utils imports

def get_project_name() -> str:
    return os.path.basename(os.getcwd())

def get_git_branch() -> Optional[str]:
    """
    Get the current git branch name.

    Returns:
        Branch name or None if not in a git repository
    """
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--abbrev-ref", "HEAD"],
            capture_output=True,
            text=True,
            timeout=2
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except (subprocess.TimeoutExpired, subprocess.SubprocessError, FileNotFoundError):
        pass
    return None


def display_osx_notification(title: str, message: str) -> bool:
    """Display menu bar notification in OSX"""
    args = ["osascript", "-e", f"display notification \"{message}\" with title \"{title}\""]
    result = subprocess.run(args)
    return result.returncode == 0


def display_task_complete(project: str, branch: str) -> bool:
    """Display menu bar notification for task completion"""
    return display_osx_notification(project, f"{branch} complete")


def display_notification(project: str, branch: str) -> bool:
    """Display menu bar notification for input needed"""
    return display_osx_notification(project, f"{branch} needs input")


def format_names(project: str, branch: str, include_branch_prefix: str = "on"):
    """
    Clean up project and branch names for better readability.

    Returns:
        Tuple of (formatted_project, formatted_branch_text)
    """
    project = re.sub(r'[-_]', ' ', project)
    branch = re.sub(r'[-_]', ' ', branch) if branch else ""
    branch_text = f" {include_branch_prefix} {branch}" if branch and branch != "main" else ""
    return project, branch_text


def generate_completion_message(project: str, branch: str):
    """
    Generate a fallback completion message using random selection.

    Returns:
        str: A randomly selected completion message
    """
    project, branch_text = format_names(project, branch, "on branch")

    messages = [
        f"{project}{branch_text} is done!",
        f"{project}{branch_text} finished!",
        f"Completed {project}{branch_text}!",
        f"{project}{branch_text} is ready!",
    ]

    return random.choice(messages)


def generate_notification_message(project: str, branch: str):
    """
    Generate a notification message using random selection.

    Returns:
        str: A randomly selected notification message
    """
    project, branch_text = format_names(project, branch, "on branch")

    messages = [
        f"{project}{branch_text} needs input",
        f"{project}{branch_text} is waiting",
        f"{project}{branch_text} requires attention",
    ]

    return random.choice(messages)

def speak_text(text: str) -> bool:
    """Speak text using macOS say command"""
    result = subprocess.run(["say", text])
    return result.returncode == 0

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('command', type=str, nargs='?', help='Command (e.g., "stop", "notification")')
    args = parser.parse_args()
    if args.command is None:
        parser.print_help()
        sys.exit(0)
    project = get_project_name()
    branch = get_git_branch()

    if args.command == "stop":
        display_task_complete(project, branch)
        completion_message = generate_completion_message(project, branch)
        speak_text(completion_message)
    elif args.command == "notification":
        display_notification(project, branch)
        notification_message = generate_notification_message(project, branch)
        speak_text(notification_message)
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
