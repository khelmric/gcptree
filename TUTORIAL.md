# Google Cloud Resource Tree Viewer - Cloud Shell Tutorial

## Overview
This guide will show you how to view the Google Cloud Resource Tree in your Organization.

**Time to complete**: <walkthrough-tutorial-duration duration="3"></walkthrough-tutorial-duration>

**Prerequisites**: 
- **Google Cloud Asset Inventory API**: Enable it for your project.
   - [Enable the API](https://console.cloud.google.com/apis/library/cloudasset.googleapis.com)
- **Permissions**: Ensure your Google Cloud account has the necessary roles:
   - `roles/resourcemanager.organizationViewer`
   - `roles/resourcemanager.folderViewer`
   - `roles/resourcemanager.projectViewer`

Click the **Start** button to move to the first step.

## View the Resource Tree
Execute the gcptree.sh script

### Set the Resource ID (Organization ID or Folder ID), where you want to see the child resources
```bash
RESOURCE_ID=
```

### Execute the gcptree.sh script
```bash
./gcptree.sh $RESOURCE_ID
```

Click the **Next** button to move to the next step.

## Congratulations
<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You're all set!

You can now see your Google Cloud Resource Tree.

Done!