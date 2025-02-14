# uno_host_ios
Steps to integrate a Flutter module into Swift project using Frameworks and CocoaPods:
1. Clone this flutter module: https://github.com/kmss-quan-nguyen/kms_emi_calculator_sdk
2. Run:
    flutter pub get
    flutter build ios-framework --output=/path/to/MyApp/Flutter/
3. Create Ios native app 
4. Go to IOS native app run:
    pod init
5. Modify the podfile the same with the sample ios or doc (https://docs.flutter.dev/add-to-app/ios/project-setup)
    OR: get the pod file in this repo
6. Run: 
    pod install
7. Follow the instruction to add flutter module to native
    https://docs.flutter.dev/add-to-app/ios/project-setup#method-c
    *NOTE:
   - Remember to switch to "Use Frameworks and Cocoapods" tab
   - These frameworks are required to use kms_emi_calculator_sdk
     <img width="716" alt="frameworks" src="https://github.com/user-attachments/assets/12610366-4fda-4c4e-b67f-05878a4d0c32" />
8. Build
