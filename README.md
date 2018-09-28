# iOS App for Field Technicians

## Overview
This iOS reference application shows how the SAP Cloud Platform mobile services and the SAP Cloud Platform SDK for iOS enable Customers and Partners to build mobile solutions. This application is a sample implementation of a mobile app for a service technician to exchange data with a sample cloud service. With this mobile solution the service technician can see his open tickets, change the status on the tickets and view customers and products.

<img width="250" alt="Screen1" src="https://user-images.githubusercontent.com/28980634/45613988-4910c100-ba68-11e8-8a4a-941663e34bdf.png"><img width="250" alt="Screen2" src="https://user-images.githubusercontent.com/28980634/45613994-4ca44800-ba68-11e8-8f78-549031fe55b6.png"><img width="250" alt="Screen3" src="https://user-images.githubusercontent.com/28980634/45614004-562db000-ba68-11e8-94de-99ad846855fc.png">


### Business story
This reference application show cases that values for the mobile workers can be created with little development. This App allows to process data and look up records which is a very common mobile use case. The initial development after the design was finished took less than 3 days. Key for such a rapid development is that the Backend data is available in OData.

### Architecture overview 
![alt text](https://cloudplatform.sap.com/content/dam/website/skywalker/en_us/Blueprints/09_OnePager_Mobile_iOSSDK.jpg "Architecture Overview")


## Requirements
Use of the reference application is dependent upon the following:

 1. [SAP Cloud Platform SDK for iOS](https://www.sap.com/developer/trials-downloads/additional-downloads/sap-cloud-platform-sdk-for-ios-14485.html), version 2.0 SP02 
 2. Apple Xcode 9.3
     - New versions of Xcode
 3. iOS 10 or 11
 
## Setup
In Order to get this Sample to work follow the steps below  
1. Install the [SAP Cloud Platform SDK for iOS](https://www.sap.com/developer/tutorial-navigator/mobile-interactive-tutorials/sdk-tools/ios-assistant/basic.html)
2. Clone the this repository 
3. Export SAP SDK Frameworks   
    1. Launch the iOS Assistant which is part of the SAP Cloud Platform SDK for iOS.
    2. From the SAP Cloud Platform SDK for iOS Assistant menu, choose the Export Frameworks item to install the SDK frameworks to the /frameworks directory in the local repository. <img alt="Screen1" src="https://user-images.githubusercontent.com/28980634/45614263-377be900-ba69-11e8-9c83-eaa6c11aced1.png">
4. Then, build & run the project Xcode.

## Additional Information

if you want to learn more you follow the links

[SAP Cloud Platform mobile services](https://www.sap.com/developer/topics/mobile.html)

[Blueprint: Empower Field Technicians by Building Apps Using the SDK for iOS](https://cloudplatform.sap.com/scenarios/usecases/sdk-ios.html)

[SAP Mobile Tutorials](https://www.sap.com/developer/tutorial-navigator/mobile-interactive-tutorials.html)

the sample cloud service used is a read only service.

## How to obtain support
If you need any support, have any question or have found a bug, please report it as an issue in the repository.

## Known Issues
iOS 12 not yet supported

## Authors
[Sami Lechner](https://github.com/SamiLechner)

## Copyright and License
Copyright (c) 2018 SAP SE

Except as provided below, this software is licensed under the Apache License, Version 2.0 (the "License"); you may not use this software except in compliance with the License.You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
