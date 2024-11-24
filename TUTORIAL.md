# Google Cloud Resource Tree Viewer - Cloud Shell Tutorial

## Overview
This guide will show you how to view the Google Cloud Resource Tree in your Organization.

**Time to complete**: <walkthrough-tutorial-duration duration="5"></walkthrough-tutorial-duration>

**Prerequisites**: 
Before starting, ensure the following:

1. **Enable the Google Cloud Asset Inventory API**:  
   Click the button below to enable it for your project:  
   <walkthrough-enable-apis apis="cloudasset.googleapis.com"></walkthrough-enable-apis>

2. **IAM Permissions**:  
   Verify your account has the necessary roles:  
   - `roles/resourcemanager.organizationViewer`  
   - `roles/resourcemanager.folderViewer`  
   - `roles/resourcemanager.projectViewer`  

   If you don't have these roles, click below to open the IAM page and grant them:  
   [Open IAM Page](https://console.cloud.google.com/iam-admin/iam)

Click the **Start** button to proceed.

## View the Resource Tree
Execute the gcptree.sh script

**Set the Resource ID**:  
   The `RESOURCE_ID` should be either:  
   - Your **Organization ID**: `123456789012` (without the 'organizations/' prefix)
   - A **Folder ID**: `345678901234` (without the 'folders/' prefix)

Run the following command to define the resource ID:

```bash
RESOURCE_ID= # Replace with your Organization or Folder ID
```

### Execute the gcptree.sh script
```bash
./gcptree.sh $RESOURCE_ID
```

Click **Next** to proceed.

## Congratulations!

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You're all set! 🎉  

You’ve successfully displayed your Google Cloud Resource Tree. If you encounter any issues, double-check the following:  
- **API is enabled**  
- **IAM roles are correctly assigned**  
