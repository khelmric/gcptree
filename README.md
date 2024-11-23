# Google Cloud Resource Tree Viewer

This script generates a visual representation of Google Cloud resources (Organizations, Folders, and Projects) in a tree structure. It uses the **Google Cloud SDK** and **Asset Inventory API** to fetch and display active resources in a hierarchical format.

## Features

- Displays a tree structure of Google Cloud resources starting from an **Organization** or a **Folder**.
- Supports active resources:
  - **Organizations**: 🌐
  - **Folders**: 📁
  - **Projects**: 📦
- Uses **`gcloud`** commands to query resources, ensuring live data from your Google Cloud environment.

---

## Prerequisites

1. **Google Cloud SDK**: Install and configure the `gcloud` CLI.
   - [Install the Cloud SDK](https://cloud.google.com/sdk/docs/install)
2. **Google Cloud Asset Inventory API**: Enable it for your project.
   - [Enable the API](https://console.cloud.google.com/apis/library/cloudasset.googleapis.com)
3. **Permissions**: Ensure your Google Cloud account has the necessary roles:
   - `roles/resourcemanager.organizationViewer`
   - `roles/resourcemanager.folderViewer`
   - `roles/resourcemanager.projectViewer`

---

## Installation

1. Clone or download this repository:
    ```bash
    git clone https://github.com/khelmric/gcptree.git
    cd gcptree
2. Make the script executable:
   ```bash
   chmod +x gcptree.sh

## Usage
`gcptree.sh` allows you to display the hierarchical structure of Google Cloud resources starting from an **Organization** or **Folder**.

### Basic Syntax
```bash
./gcptree.sh <ORGANIZATION_ID or FOLDER_ID>
```

### Required Argument
- <ORGANIZATION_ID>: The unique numeric identifier of your Google Cloud Organization.
- <FOLDER_ID>: The unique numeric identifier of a Google Cloud Folder.

### Examples

#### Display all resources under an organization:
Replace 123456789012 with your Organization ID.

```bash
./gcptree.sh 123456789012
```

Output:
```
Google Cloud Resource Tree
.
└── 🌐 My Organization (123456789012)
    ├── 📁 Folder A (folders/111)
    │   ├── 📦 Project A1 (projects/333)
    │   └── 📦 Project A2 (projects/444)
    └── 📦 Project B (projects/555)
```

#### Display all resources under a folder:
Replace 987654321098 with your Folder ID.

```bash
./gcptree.sh 987654321098
```

Output:
```
Google Cloud Resource Tree
.
└── 📁 Folder X (folders/987654321098)
    ├── 📁 Subfolder Y (folders/222)
    │   └── 📦 Project Y1 (projects/777)
    └── 📦 Project X1 (projects/888)
```