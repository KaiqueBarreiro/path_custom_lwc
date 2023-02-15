# Path Custom in LWC for SalesForce

This project is an application for override the Path in Objects from Salesforce, in that case was developmented for Opportunity and Lead.

For you to aplicate in your org, you must edit page layout and add the component in a page standard.

## How the steps of the path are done according to the Status?

Was raised a Custom Metadata call PathCustom__mdt, where this metadata contains: object specific, status, message hover, key fields, guidance.

Through this metadata the Path is find by Object and created the Path by Status his.

This project was raised patterns like repository, filter, mock for test and single responsability principles.

