---
name: add-github-skill
description: Add a skill from a GitHub repository using npx skills add. Use when you want to install a skill from an external GitHub repo.
---

# Add Skill from GitHub

## When to Use
- When you have a GitHub repository that contains a skill you want to add.
- To install community or custom skills.

## Procedure
1. Find the GitHub repository URL that contains the skill.
2. Identify the skill name within that repo.
3. Run the command: `npx skills add <repo-url> --skill <skill-name>`

For example: `npx skills add https://github.com/remotion-dev/skills --skill remotion-best-practices`

This will add the skill to your local skills collection.

Then, the skill can be used in your projects.