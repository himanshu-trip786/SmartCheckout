# 🛒 SmartCheckout

SmartCheckout is an iOS application that enables a seamless **Scan & Go** retail shopping experience. Customers can scan product barcodes or QR codes, manage their shopping cart, and complete checkout — all from their iPhone, without waiting in traditional queues.

---

## 📱 Features

- **Barcode & QR Code Scanning** — Powered by `MTBBarcodeScanner` and `ZXingObjC` for fast, accurate product scanning
- **Smart Cart Management** — Add, update, and remove items in real time
- **Product Detail View** — Browse product information before adding to cart
- **Checkout Flow** — Streamlined payment and order confirmation
- **Digital Receipt** — View and manage past receipts directly in the app
- **Store Locator** — Find nearby stores using Google Maps integration
- **Image Loading** — Fast and cached product images via `SDWebImage`
- **Reactive Architecture** — Built with `ReactiveSwift` / `ReactiveCocoa` for clean, event-driven UI updates

---

## 🏗️ Project Structure

```
SmartCheckout/
├── AppDelegate.swift               # App entry point & lifecycle
├── SceneDelegate.swift             # Scene-based lifecycle (iOS 13+)
├── ViewControllers/
│   ├── CartViewController.swift           # Shopping cart screen
│   ├── CheckoutViewController.swift       # Payment & checkout screen
│   ├── ProductDetailViewController.swift  # Product info screen
│   ├── ReceiptViewController.swift        # Individual receipt view
│   ├── ReceiptsListViewController.swift   # List of past receipts
│   └── StoreLocator/                      # Store map & locator
├── SmartCartCell/                  # Custom UITableViewCell for cart items
├── SpinnerView/                    # Reusable loading indicator
├── Category+UIImage/               # UIImage extension/utilities
├── Network/                        # Network layer & API calls
├── Assets.xcassets/                # App icons & image assets
└── Base.lproj/                     # Storyboards & localization
```

---

## 🔧 Requirements

| Requirement | Version |
|-------------|----------|
| iOS | 11.0+ |
| Xcode | 12.0+ |
| Swift | 5.0+ |
| CocoaPods | 1.9+ |

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/himanshu-trip786/SmartCheckout.git
cd SmartCheckout
```

### 2. Install Dependencies

Make sure you have [CocoaPods](https://cocoapods.org/) installed, then run:

```bash
cd SmartCheckout
pod install
```

### 3. Open the Workspace

> ⚠️ Always open the `.xcworkspace` file, **not** the `.xcodeproj`.

```bash
open SmartCheckout.xcworkspace
```

### 4. Build & Run

- Select your target device or simulator in Xcode
- Press `Cmd + R` to build and run

---

## 📦 Dependencies

| Pod | Purpose |
|-----|---------|
| [GoogleMaps](https://developers.google.com/maps/documentation/ios-sdk) | Store locator & map display |
| [ZXingObjC](https://github.com/zxingify/zxingify-objc) | Barcode & QR code scanning |
| [MTBBarcodeScanner](https://github.com/mikebuss/MTBBarcodeScanner) | Additional barcode scanning support |
| [SDWebImage](https://github.com/SDWebImage/SDWebImage) | Async image loading & caching |
| [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) | Reactive programming framework |
| [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) | UIKit bindings for ReactiveSwift |
| [ReactiveObjC](https://github.com/ReactiveCocoa/ReactiveObjC) | Objective-C reactive extensions |
| [CocoaLumberjack/Swift](https://github.com/CocoaLumberjack/CocoaLumberjack) | Logging framework |

---

## 🖥️ App Flow

```
[Launch] 
   └──▶ [Store Locator] 
            └──▶ [Scan Product Barcode/QR]
                     └──▶ [Product Detail]
                               └──▶ [Cart]
                                        └──▶ [Checkout]
                                                 └──▶ [Receipt]
                                                          └──▶ [Receipts List]
```

---

## 🧪 Testing

The project includes two test targets:

- **SmartCheckoutTests** — Unit tests
- **SmartCheckoutUITests** — UI/integration tests

To run tests in Xcode:
```
Cmd + U
```

---

## 📸 Camera Permission

The app requires camera access for barcode/QR scanning. The `Info.plist` includes the required `NSCameraUsageDescription` key. Users will be prompted for permission on first launch.

---

## 🤝 Contributing

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a Pull Request

---

## 👤 Author

**Himanshu Tripathi**  
GitHub: [@himanshu-trip786](https://github.com/himanshu-trip786)

---

## 📄 License

This project is available for personal and educational use. Please contact the author for commercial licensing.
