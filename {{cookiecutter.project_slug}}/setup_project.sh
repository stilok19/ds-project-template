#!/bin/bash
# ============================================================
# Full Project Setup Script
# Author: {{ cookiecutter.author_name }}
# Project: {{ cookiecutter.project_name }}
# ============================================================

set -e

PROJECT_SLUG="{{ cookiecutter.project_slug }}"
PYTHON_VERSION="{{ cookiecutter.python_version }}"

echo "============================================"
echo "Setting up project: {{ cookiecutter.project_name }}"
echo "============================================"

# Step 1 — Create virtual environment
echo "→ Creating virtual environment..."
python -m venv ~/${PROJECT_SLUG}-env
source ~/${PROJECT_SLUG}-env/bin/activate

# Step 2 — Install dependencies
echo "→ Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Step 3 — Register Jupyter kernel
echo "→ Registering Jupyter kernel..."
python -m ipykernel install \
    --user \
    --name=${PROJECT_SLUG}-env \
    --display-name="Python (${PROJECT_SLUG})"

# Step 4 — Initialize dbt
echo "→ Setting up dbt..."
cd ${PROJECT_SLUG}_dbt
dbt deps
cd ..

# Step 5 — Set up git hooks (optional but professional)
echo "→ Setting up git..."
git init
git add .
git commit -m "chore: initialize project from ds-project-template"

echo ""
echo "============================================"
echo "✅ Project Setup Complete!"
echo ""
echo "Next steps:"
echo "  1. Run: source ~/${PROJECT_SLUG}-env/bin/activate"
echo "  2. Run: bash setup_gcp.sh"
echo "  3. Start coding!"
echo "============================================"
