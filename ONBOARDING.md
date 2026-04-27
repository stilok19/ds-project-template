# How to Start a New end-to-end Data Science Project 
### A Step-by-Step Guide for Beginner Data Scientists
**Template:** `ds-project-template` by May Tilokruangchai  
**Last Updated:** April 2026

---

## Before You Start — What You Need

Make sure you have all of these installed and ready before starting a new project.

| Tool | What it does | Check if installed |
|------|-------------|-------------------|
| VS Code | Code editor | Open VS Code on your computer |
| Git + SSH | Save and share code | `git --version` in terminal |
| Python 3.11 | Programming language | `python --version` in terminal |
| gcloud CLI | Talk to Google Cloud | `gcloud --version` in terminal |
| dbt | Transform data in BigQuery | `dbt --version` in terminal |
| Cookiecutter | Generate project from template | `cookiecutter --version` in terminal |
| Kaggle CLI | Download datasets | `kaggle --version` in terminal |

> 💡 **What is a terminal?** In VS Code press **Ctrl + `** (backtick key, top left of keyboard) to open a terminal. This is where you type commands.

---

## 🗺️ Overview — What You Will Do

Here is the full picture of what you will set up for every new project:

```
Step 1:  Create a config file          (tells the template your project details)
Step 2:  Create GitHub repository      (online home for your code)
Step 3:  Generate project folders      (cookiecutter creates everything automatically)
Step 4:  Create GCP project            (Google Cloud — where your data lives)
Step 5:  Link billing to GCP           (required to use GCP services)
Step 6:  Run setup scripts             (creates GCS bucket + BigQuery automatically)
Step 7:  Set up dbt                    (connects SQL transforms to BigQuery)
Step 8:  First commit to GitHub        (save everything online)
Step 9:  You are ready to code!
```

---

## STEP 1 — Create Your Project Config File

This is a simple text file that stores all your project details. You fill it in once and the template uses it to generate everything automatically — no typing long names in terminal.

### 1.1 Open the configs folder in VS Code

In VS Code terminal type:

```bash
code ~/cookiecutter-configs
```

If you see the error `No such file or directory` run this first:

```bash
mkdir -p ~/cookiecutter-configs
code ~/cookiecutter-configs
```

### 1.2 Create a new YAML file

In VS Code Explorer panel (left side):
1. Click the **New File** icon at the top of the panel
2. Name it: `your-project-name.yaml` (use dashes, no spaces)
   - Example: `walmart-demand.yaml`
   - Example: `customer-churn.yaml`
3. Press **Enter**

### 1.3 Copy and fill in the template

Paste this into your new file and fill in **every value** between the quotes:

```yaml
default_context:
  project_name: "your-project-name"
  project_slug: "your_project_name"
  project_description: "One sentence describing what this project does"
  author_name: "Your Full Name"
  github_username: "your-github-username"
  gcp_project_id: "your-gcp-project-id"
  gcs_bucket_name: "your-project-raw-your-github-username"
  bq_dataset_name: "your_project_dataset"
  gcp_region: "us-central1"
  python_version: "3.11"
  industry: "retail"
```

> **Important rules:**
> - `project_name` → use dashes: `walmart-demand-intelligence`
> - `project_slug` → use underscores: `walmart_demand_intelligence`
> - `gcp_project_id` → you will get this in Step 4 — leave it for now
> - `bq_dataset_name` → use underscores only, no dashes
> - `industry` → choose one: `ecommerce`, `retail`, `research`, `fintech`, `healthcare`

### 1.4 Save the file

Press **Cmd + S** to save.

---

## STEP 2 — Create GitHub Repository

GitHub is where all your code lives online. Every project needs its own repository (repo).

### 2.1 Go to GitHub

Open your browser and go to: [github.com/new](https://github.com/new)

Sign in if asked.

### 2.2 Fill in the form

```
Repository name:  your-project-name        ← same as project_name in your yaml
Description:      your project description ← same as project_description in yaml
Visibility:       Public
Add README:       Do NOT check this
.gitignore:       None
License:          None
```

> **Do NOT check "Add README"** — the template already creates one for you. If you check it, you will get an error when pushing later.

### 2.3 Click "Create repository"

GitHub shows you a page with setup instructions — you can ignore those, the template handles it.

---

## STEP 3 — Generate Project from Template

Now you use cookiecutter to automatically create all your project folders and files.

### 3.1 Open a terminal in VS Code

Press **Ctrl + `** to open the terminal.

Make sure you are in your home directory:

```bash
cd ~
pwd
# Should print: /Users/yourname
```

### 3.2 Run cookiecutter

```bash
cookiecutter gh:stilok19/ds-project-template \
  --config-file ~/cookiecutter-configs/your-project-name.yaml \
  --no-input
```

Replace `your-project-name.yaml` with the actual filename you created in Step 1.

Example:
```bash
cookiecutter gh:stilok19/ds-project-template \
  --config-file ~/cookiecutter-configs/walmart-demand.yaml \
  --no-input
```

This takes about 10 seconds. When done you will see a new folder in your home directory.

### 3.3 Verify the folder was created

```bash
ls ~
```

You should see your new project folder in the list.

### 3.4 Open the project in VS Code

```bash
code ~/your-project-name
```

Example:
```bash
code ~/walmart-demand-intelligence
```

### 3.5 Verify folder structure

Click the Explorer icon in VS Code (left panel) — you should see:

```
your-project-name/
├── setup_gcp.sh                ← GCP setup script
├── setup_project.sh            ← project setup script  
├── setup_all.sh                ← runs both scripts above
├── requirements.txt            ← Python packages list
├── .gitignore                  ← files to never commit
├── README.md                   ← project documentation
├── data/                       ← raw data (never committed)
├── ingestion/
│   └── upload_to_gcs.py        ← script to upload data to GCS
├── your_project_slug_dbt/      ← dbt SQL transforms
│   └── models/
│       ├── staging/
│       ├── marts/
│       └── features/
├── notebooks/                  ← Jupyter notebooks
└── dashboard/                  ← Looker Studio docs
```

> If something went wrong (wrong project name, typo etc.) — the fix is simple:
> ```bash
> rm -rf ~/wrong-project-name   # delete wrong folder
> # fix your yaml file
> # rerun cookiecutter
> ```

---

## STEP 4 — Create GCP Project

GCP (Google Cloud Platform) is where your data warehouse and storage live. You need to create a new project for each data science project.

### 4.1 Go to Google Cloud Console

Open your browser and go to: [console.cloud.google.com](https://console.cloud.google.com)

Sign in with your Google account.

### 4.2 Create a new project

1. Click the **project dropdown** at the very top left of the page (it might say "My First Project" or the name of your last project)
2. Click **"New Project"** button (top right of the popup)
3. Fill in:
   ```
   Project name: your-project-name
   ```
4. Click **Create**
5. Wait about 30 seconds for GCP to create it

### 4.3 Find your Project ID

> **Important:** The Project ID may NOT the same as the Project Name. GCP sometimes adds numbers to make it unique.

1. Click the project dropdown again
2. Find your new project in the list
3. Look at the right column — you will see something like:
   ```
   Project name          Project ID
   walmart-demand        walmart-demand-483920   ← copy this
   ```
4. Copy the **Project ID** (with the numbers)

### 4.4 Update your yaml config file

Go back to VS Code and open your yaml file:

```bash
code ~/cookiecutter-configs/your-project-name.yaml
```

Update the `gcp_project_id` with the real Project ID:

```yaml
gcp_project_id: "walmart-demand-483920"    # ← paste your real ID here
```

Save with **Cmd + S**

### 4.5 Set the project in terminal

```bash
gcloud config set project your-project-id
gcloud auth application-default set-quota-project your-project-id
```

Example:
```bash
gcloud config set project walmart-demand-483920
gcloud auth application-default set-quota-project walmart-demand-483920
```

Verify it worked:
```bash
gcloud config get-value project
# Should print your project ID
```

---

## STEP 5 — Link Billing Account

GCP requires a billing account to use services like GCS and BigQuery. You will NOT be charged for normal usage — GCP has a generous free tier.

### 5.1 Go to billing page

Go to: [console.cloud.google.com/billing/linkedaccount](https://console.cloud.google.com/billing/linkedaccount)

Make sure your new project is selected in the top dropdown.

### 5.2 Link billing account

If you see **"This project has no billing account"**:
1. Click **"Link a billing account"**
2. Select **"My Billing Account"** (or your free trial account)
3. Click **"Set Account"**

If you already see a billing account name → you are already linked, skip to Step 6.

### 5.3 Verify billing is linked

In your terminal:

```bash
gcloud billing projects describe your-project-id \
  --format="value(billingEnabled)"
# Should print: True
```

> **If you get a permission error:** Go to [console.cloud.google.com/iam-admin/iam](https://console.cloud.google.com/iam-admin/iam) → make sure your email has the **Owner** role on this project.

---

## STEP 6 — Run Setup Scripts

Now you run the setup scripts that the template created for you. These automatically create your GCS bucket (data storage) and BigQuery dataset (data warehouse).

### 6.1 Navigate to your project

```bash
cd ~/your-project-name
```

Example:
```bash
cd ~/walmart-demand-intelligence
```

### 6.2 Update setup_gcp.sh with your project details

Open `setup_gcp.sh` in VS Code. Find these lines at the top and make sure they match your yaml config:

```bash
PROJECT_ID="your-project-id"          # ← should match gcp_project_id
BUCKET_NAME="your-bucket-name"        # ← should match gcs_bucket_name
BQ_DATASET="your_dataset_name"        # ← should match bq_dataset_name
REGION="us-central1"
```

Save with **Cmd + S**

### 6.3 Run the GCP setup script

```bash
bash setup_gcp.sh
```

This will:
- Enable BigQuery and Storage APIs
- Create your GCS bucket (data lake)
- Create your BigQuery dataset (data warehouse)
- Authenticate Python to connect to GCP

Wait for it to finish. You should see:

```
╔══════════════════════════════════════════╗
║            GCP Setup Complete!         ║
╚══════════════════════════════════════════╝
```

> **If you see a permission error** — go back to Step 5 and make sure billing is linked.

### 6.4 Verify in GCP Console

Go to [console.cloud.google.com/storage](https://console.cloud.google.com/storage) — you should see your new bucket.

Go to [console.cloud.google.com/bigquery](https://console.cloud.google.com/bigquery) — you should see your new dataset on the left panel.

---

## STEP 7 — Set Up dbt

dbt (data build tool) is how we transform raw data in BigQuery into clean, analysis-ready tables. Every project uses dbt.

### 7.1 Activate the dbt environment

```bash
source ~/dbt-env/bin/activate
```

You will see `(dbt-env)` appear at the start of your terminal prompt. This means the environment is active.

> **You need to do this every time you open a new terminal and want to use dbt.** Add this alias so you only have to type `dbt-work`:
> ```bash
> echo 'alias dbt-work="source ~/dbt-env/bin/activate"' >> ~/.zshrc
> source ~/.zshrc
> ```

### 7.2 Go into the dbt folder

```bash
cd ~/your-project-name/your_project_slug_dbt
```

Example:
```bash
cd ~/walmart-demand-intelligence/walmart_demand_intelligence_dbt
```

### 7.3 Initialize dbt

```bash
dbt init .
```

Answer the prompts:

```
Which database adapter would you like to use?
→ Type: 1  (bigquery)  then press Enter

Authentication method:
→ Type: 1  (oauth)  then press Enter

Project ID:
→ Type your GCP project ID (e.g. walmart-demand-483920) then press Enter

Dataset:
→ Type your dataset name (e.g. walmart_forecasting) then press Enter

Threads:
→ Type: 4  then press Enter

Timeout:
→ Type: 300  then press Enter

Location:
→ Type: US  then press Enter
```

### 7.4 Update dbt_project.yml

Open `dbt_project.yml` in VS Code and replace the entire content with:

```yaml
name: 'your_project_slug_dbt'
version: '1.0.0'
config-version: 2

profile: 'your_project_slug_dbt'

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:
  - "target"
  - "dbt_packages"

models:
  your_project_slug_dbt:
    staging:
      +materialized: table
    marts:
      +materialized: table
    features:
      +materialized: table
```

Replace `your_project_slug_dbt` with your actual project slug + `_dbt`.

Example for walmart:
```yaml
name: 'walmart_demand_intelligence_dbt'
profile: 'walmart_demand_intelligence_dbt'
...
models:
  walmart_demand_intelligence_dbt:
```

Save with **Cmd + S**

### 7.5 Update profiles.yml

`profiles.yml` stores connection settings for all your dbt projects. It lives at `~/.dbt/profiles.yml`.

Open it in VS Code:

```bash
# Open VS Code first, then:
# File → Open File → /Users/yourname/.dbt/profiles.yml
```

Add your new project at the bottom:

```yaml
your_project_slug_dbt:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: your-gcp-project-id
      dataset: your_dataset_name
      threads: 4
      timeout_seconds: 300
      location: US
```

Example for walmart:
```yaml
walmart_demand_intelligence_dbt:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: walmart-demand-483920
      dataset: walmart_forecasting
      threads: 4
      timeout_seconds: 300
      location: US
```

Save with **Cmd + S**

### 7.6 Delete the example models

dbt creates example models you don't need:

```bash
rm -rf models/example
```

### 7.7 Test dbt connection

```bash
dbt debug
```

You should see all checks pass:

```
Configuration:
  profiles.yml file [OK found and valid]
  dbt_project.yml file [OK found and valid]

Required dependencies:
  git [OK found]

Connection test:
  Connection test: [OK connection ok]

All checks passed!
```

> **If you see "Could not find profile"** → check that the profile name in `profiles.yml` exactly matches the `profile:` value in `dbt_project.yml`. They must be identical.

---

## STEP 8 — Connect to GitHub and Push

Now you save everything to GitHub so your code is backed up and version controlled.

### 8.1 Initialize git in your project

```bash
cd ~/your-project-name
git init
```

### 8.2 Connect to your GitHub repository

```bash
git remote add origin git@github.com:your-github-username/your-project-name.git
```

Example:
```bash
git remote add origin git@github.com:stilok19/walmart-demand-intelligence.git
```

### 8.3 Add all files

```bash
git add .
```

### 8.4 Make your first commit

```bash
git commit -m "chore: initialize project from ds-project-template"
```

### 8.5 Push to GitHub

```bash
git branch -M main
git push -u origin main
```

### 8.6 Verify on GitHub

Go to `https://github.com/your-github-username/your-project-name`

You should see all your project files online.

---

## STEP 9 — Set Up Python Environment

This creates a clean Python environment with all the packages your project needs.

### 9.1 Go back to your project root

```bash
cd ~/your-project-name
```

### 9.2 Create virtual environment

```bash
python -m venv ~/your-project-slug-env
```

Example:
```bash
python -m venv ~/walmart-demand-env
```

### 9.3 Activate it

```bash
source ~/your-project-slug-env/bin/activate
```

You will see `(your-project-slug-env)` at the start of your terminal.

### 9.4 Install packages

```bash
pip install -r requirements.txt
```

This installs all the packages listed in `requirements.txt`. Takes 2-3 minutes.

### 9.5 Register Jupyter kernel

This makes your environment available in VS Code notebooks:

```bash
python -m ipykernel install \
  --user \
  --name=your-project-slug-env \
  --display-name="Python (your-project-name)"
```

Example:
```bash
python -m ipykernel install \
  --user \
  --name=walmart-demand-env \
  --display-name="Python (walmart-demand-intelligence)"
```

### 9.6 Add a shortcut alias

So you never forget how to activate your environment:

```bash
echo 'alias walmart-work="source ~/walmart-demand-env/bin/activate"' >> ~/.zshrc
source ~/.zshrc
```

Now just type `walmart-work` to activate it anytime.

---

## Final Checklist

Go through every item before you start coding:

```
□ Config yaml file created in ~/cookiecutter-configs/
□ GitHub repository created at github.com
□ Project folder generated with cookiecutter
□ GCP project created with correct Project ID
□ GCP Project ID updated in yaml config file
□ Billing linked to GCP project
□ setup_gcp.sh ran successfully
□ GCS bucket visible in GCP Console
□ BigQuery dataset visible in GCP Console
□ dbt initialized inside project dbt folder
□ dbt_project.yml updated with correct project name
□ profiles.yml updated with new project profile
□ dbt debug shows all checks passed
□ Git initialized and connected to GitHub
□ First commit pushed to GitHub
□ Python virtual environment created
□ requirements.txt packages installed
□ Jupyter kernel registered in VS Code
```

---

## 🔄 Your Daily Workflow

Every day when you sit down to work:

```bash
# 1. Navigate to project
cd ~/your-project-name

# 2. Pull latest changes from GitHub
git pull origin main

# 3. Activate Python environment
source ~/your-project-slug-env/bin/activate

# 4. Activate dbt (if doing SQL work)
source ~/dbt-env/bin/activate

# ... do your work ...

# 5. Save your work to GitHub
git add .
git commit -m "description of what you did"
git push origin main
```

---

## Common Errors and Fixes

---

### Error: "Repository not found"
```
ERROR: Repository not found.
fatal: Could not read from remote repository.
```
**Fix:** The GitHub repo doesn't exist yet. Go to [github.com/new](https://github.com/new) and create it first.

---

### Error: "Authentication failed"
```
Authentication failed for 'https://github.com/...'
```
**Fix:** Set up SSH key. Run:
```bash
ssh -T git@github.com
# Should print: Hi username! You've successfully authenticated.
```
If not, ask a senior team member to help set up your SSH key.

---

### Error: "Updates were rejected (fetch first)"
```
! [rejected] main -> main (fetch first)
```
**Fix:** Always pull before pushing:
```bash
git pull origin main --rebase
git push origin main
```

---

### Error: "Could not find profile"
```
Runtime Error: Could not find profile named 'project_name'
```
**Fix:** Open `~/.dbt/profiles.yml` and check that the profile name exactly matches what's in `dbt_project.yml`. They must be identical including underscores.

---

### Error: "Billing account disabled"
```
AccessDeniedException: 403 The billing account for the owning project is disabled
```
**Fix:** Go to [console.cloud.google.com/billing/linkedaccount](https://console.cloud.google.com/billing/linkedaccount) and link a billing account to your project.

---

### Error: "Does not have permission"
```
The caller does not have permission
```
**Fix:** Make sure the account in your terminal matches the account that owns the GCP project:
```bash
gcloud auth list   # check which account is active
gcloud auth login  # login with the correct account
```

---

### Error: "dbt_project.yml not found"
```
Could not find dbt_project.yml
```
**Fix:** You are not in the dbt folder. Navigate to it:
```bash
cd ~/your-project-name/your_project_slug_dbt
```

---

## Where Everything Lives

```
Your Mac:
/Users/yourname/
├── cookiecutter-configs/          ← yaml config files for each project
├── ds-project-template/           ← the template (don't edit this)
├── dbt-env/                       ← shared dbt environment
├── your-project-1/                ← project 1
├── your-project-2/                ← project 2
└── ~/.dbt/profiles.yml            ← dbt connection settings for ALL projects

Google Cloud:
├── GCS Bucket                     ← raw data files (CSV, etc.)
└── BigQuery Dataset               ← SQL tables and transforms

GitHub:
└── github.com/your-username/
    ├── ds-project-template        ← template repo
    ├── your-project-1             ← project 1 code
    └── your-project-2             ← project 2 code
```

---

## Tips for Beginner

**Tip 1 — Always pull before you push**
```bash
git pull origin main   ← always do this first
# do your work
git push origin main   ← then push
```

**Tip 2 — Never commit data files**
Raw data lives in GCS, not GitHub. Your `.gitignore` already handles this but double check with:
```bash
git status   ← make sure no .csv files appear here
```

**Tip 3 — Commit often with clear messages**
```bash
# Good commit messages:
git commit -m "feat: add customer segmentation notebook"
git commit -m "fix: fix null handling in stg_orders.sql"
git commit -m "chore: update requirements.txt"

# Bad commit messages:
git commit -m "update"
git commit -m "fix stuff"
git commit -m "asdfgh"
```

**Tip 4 — One project = one GCP project**
Never share a GCP project between two different data science projects. Always create a new one.

**Tip 5 — If something breaks — ask!**
It is always faster to ask a senior team member than to spend 2 hours debugging alone.

---

## 📞 Need Help?

Contact the data team:

| Person | Contact | For help with |
|--------|------|---------------|
| May Tilokruangchai | LinkedIn.com/in/stilok | Template, GCP, dbt |
| | | |

---

*Document maintained by May Tilokruangchai · ds-project-template v1.0*
