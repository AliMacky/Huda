# Huda
![iOS 26+](https://img.shields.io/badge/iOS-26.0%2B-blue) ![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange) ![Xcode 26](https://img.shields.io/badge/Xcode-26.1%2B-blue)

**Huda** is a comprehensive, all-in-one Islamic application designed to be the daily companion for Muslims.

## Requirements 
To build and run this project, you need: 
* **Xcode 26.1** or later. 
* **iOS 26.0** or later (Target Deployment). 
* A valid Apple ID (for signing).

## Development Setup
**Clone the repository**:
 ```bash
git clone [https://github.com/AliMacky/Huda.git](https://github.com/AliMacky Huda.git) 
 cd Huda
``` 
2. **Configuration (Secrets):** This project uses an `.xcconfig` file to secure API keys. You must create this file manually as it is ignored by Git. 
* Create a file named `Secrets.xcconfig` in the root project folder. 
* Add the following keys (replace with your actual API credentials):
 ```text 
 // Secrets.xcconfig 
 // Note: Do not include "https://" in the Base URL to avoid xcconfig comment issues.
API_KEY = your_api_key_here
MASJIDI_API_BASE_URL = https://api.masjidiapp.com/dev-v2
``` 
3. **Open Project:** Open `Huda.xcodeproj` in Xcode. 
4. **Build & Run:** Select your target simulator (e.g., iPhone 15 Pro) and press `Cmd + R`. 
> Note: If running on the Simulator, ensure you simulate a location via **Features > Location** in the Simulator menu bar to test Prayer Times.
5. See `CONTRIBUTING.md` for a guide on how to contribute to this project.



## License

Huda is free and open-source software licensed under the  
**GNU General Public License (GPL) version 3 or later**.

This means:

- You are free to **use**, **modify**, and **redistribute** the code.
- If you distribute a modified version of Huda (or build an app using its code),
  you **must also release your version under the GPL**.
- Any derivative work must remain **open-source** under the same license.
- You may sell your version, but you **must still provide the full source code**
  to your users.

A full copy of the GNU GPL-3.0 license is available in the `LICENSE` file or at:  
https://www.gnu.org/licenses/gpl-3.0.html

