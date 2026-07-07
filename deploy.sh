#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

if ! gh auth status >/dev/null 2>&1; then
  echo "GitHub CLI is not logged in. Run: gh auth login"
  exit 1
fi

OWNER=$(gh api user -q .login)
REPO=stone-baby-joseph

if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  echo "Repository already exists: https://github.com/$OWNER/$REPO"
else
  gh repo create "$REPO" --public --source=. --remote=origin
fi

git push -u origin main

if ! gh api "repos/$OWNER/$REPO/pages" >/dev/null 2>&1; then
  gh api "repos/$OWNER/$REPO/pages" -X POST \
    -f "source[branch]=main" \
    -f "source[path]=/"
fi

echo ""
echo "Repository: https://github.com/$OWNER/$REPO"
echo "Live site:  https://$OWNER.github.io/$REPO/"
echo "(Pages may take 1–2 minutes to become available.)"
