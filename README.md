**Battery Level and Charging Status Monitoring**
This Flutter application implements an EventChannel to monitor battery level and charging status in real-time for both Android and iOS platforms.


**Features:**
Real-Time Updates: The application listens for changes in battery level and charging status and updates the UI accordingly.
Cross-Platform Support: Utilizes native APIs for Android and iOS to ensure compatibility and performance.

**Implementation:**

**Android:**
Uses BroadcastReceiver to listen for Intent.ACTION_BATTERY_CHANGED, which provides updates whenever the battery status changes.
Sends battery level (as a percentage) and charging status (charging or not) to the Flutter side via an EventChannel.


**Usage:**
Set up the EventChannel in the Flutter application to receive battery updates.
Display the battery level and charging status in the UI.
Automatically updates when the device is plugged in or unplugged.

**Screen Shoot **
![image](https://github.com/user-attachments/assets/7b7786a4-dfcb-44e5-92bf-b3305fad7faf)
![image](https://github.com/user-attachments/assets/ada3cfce-f99f-4164-9766-e252a08568f6)
