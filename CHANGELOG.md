# 📋 Changelog

All notable changes to **SmartCheckout** will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`) and the [Conventional Commits](https://www.conventionalcommits.org/) standard.

---

## [Unreleased]

> Changes that are in development and not yet released.

- Planned: Payment gateway integration (Razorpay)
- Planned: Push notifications for order updates
- Planned: Loyalty points system

---

## [1.0.0] — Initial Release

### ✨ Features Added
- **Barcode & QR Code Scanning** using `MTBBarcodeScanner` and `ZXingObjC`
- **Smart Cart** — add, update, and remove scanned items in real time
- **Product Detail View** — view product name, price, and image before adding to cart
- **Checkout Flow** — review cart totals and confirm purchase
- **Digital Receipt** — auto-generated receipt displayed after successful checkout
- **Receipts List** — browse all past receipts within the app
- **Store Locator** — map-based store finder powered by Google Maps
- **Spinner / Loading Indicator** — reusable `SpinnerView` component across all screens
- **Image Caching** — fast product image loading via `SDWebImage`
- **Reactive Architecture** — event-driven UI powered by `ReactiveSwift` and `ReactiveCocoa`
- **Logging** — structured debug logging with `CocoaLumberjack/Swift`

### 🏗 Project Setup
- iOS 11.0+ deployment target
- CocoaPods dependency management
- Xcode workspace configured with all pod integrations
- Unit test target: `SmartCheckoutTests`
- UI test target: `SmartCheckoutUITests`
- `Info.plist` configured with camera usage description for barcode scanning

---

## How to Read This Changelog

Each version entry may contain the following sections:

| Section | Meaning |
|---------|---------|
| ✨ `Features Added` | New functionality introduced |
| 🐛 `Bug Fixes` | Issues that have been resolved |
| 🔄 `Changed` | Changes to existing functionality |
| ⚠️ `Deprecated` | Features that will be removed in a future release |
| 🗑 `Removed` | Features removed in this release |
| 🔒 `Security` | Security-related fixes or improvements |

---

## Versioning Guide

```
MAJOR.MINOR.PATCH

  MAJOR — Breaking changes or significant rewrites
  MINOR — New features, backwards-compatible
  PATCH — Bug fixes and minor improvements
```

---

*For a full list of changes, see the [commit history](https://github.com/himanshu-trip786/SmartCheckout/commits/master).*
