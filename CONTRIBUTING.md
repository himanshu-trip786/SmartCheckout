# 🤝 Contributing to SmartCheckout

Thank you for your interest in contributing to SmartCheckout! We welcome contributions from the community and are excited to collaborate with you. Please take a moment to read through these guidelines before submitting any changes.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Branch Naming Convention](#branch-naming-convention)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Features](#suggesting-features)

---

## 📜 Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone. Please be kind, constructive, and professional in all interactions.

---

## 🚀 Getting Started

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/SmartCheckout.git
   cd SmartCheckout
   ```
3. **Install dependencies:**
   ```bash
   cd SmartCheckout
   pod install
   ```
4. **Open the workspace:**
   ```bash
   open SmartCheckout.xcworkspace
   ```
5. **Create a new branch** for your changes (see [Branch Naming Convention](#branch-naming-convention))

---

## 🛠 How to Contribute

### Bug Fixes
- Check the [Issues](https://github.com/himanshu-trip786/SmartCheckout/issues) tab to see if the bug is already reported
- If not, open a new issue describing the bug before submitting a fix
- Reference the issue number in your pull request

### New Features
- Open an issue first to discuss the feature with the maintainer
- Wait for approval before starting development to avoid wasted effort
- Keep features focused and minimal — one feature per pull request

### Documentation
- Improvements to `README.md`, `CONTRIBUTING.md`, or inline code comments are always welcome
- No issue required for minor documentation fixes

---

## 🌿 Branch Naming Convention

Use the following prefixes when creating branches:

| Type | Pattern | Example |
|------|---------|----------|
| Feature | `feature/short-description` | `feature/add-loyalty-points` |
| Bug Fix | `fix/short-description` | `fix/cart-total-calculation` |
| Documentation | `docs/short-description` | `docs/update-readme` |
| Refactor | `refactor/short-description` | `refactor/network-layer` |
| Test | `test/short-description` | `test/cart-unit-tests` |

```bash
# Example
git checkout -b feature/add-loyalty-points
```

---

## ✍️ Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) standard:

```
<type>: <short description>
```

**Types:**

| Type | When to use |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation changes |
| `style` | Formatting, missing semicolons, etc. |
| `refactor` | Code refactoring without feature/fix |
| `test` | Adding or updating tests |
| `chore` | Build process or tooling changes |

**Examples:**
```
feat: add loyalty points display in cart
fix: resolve barcode scanner crash on iOS 15
docs: update README with new setup steps
refactor: simplify network request handling
```

---

## 🔀 Pull Request Process

1. Ensure your branch is **up to date** with `master`:
   ```bash
   git fetch origin
   git rebase origin/master
   ```
2. Make sure the app **builds without errors** in Xcode
3. Run all **tests** and confirm they pass (`Cmd + U`)
4. Submit your pull request with:
   - A clear **title** following commit conventions
   - A **description** of what changed and why
   - Reference to any related **issue numbers** (e.g. `Closes #12`)
5. Wait for review — the maintainer may request changes
6. Once approved, your PR will be merged 🎉

---

## 🧑‍💻 Coding Standards

- Write code in **Swift 5** following Apple's [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Follow **MVC** architecture consistent with the existing codebase
- Use `ReactiveSwift` / `ReactiveCocoa` for reactive bindings — avoid mixing with Combine
- Keep view controllers lean — move business logic to separate classes/services
- Add **comments** for complex logic; use `// MARK:` to organise code sections
- Avoid force unwrapping (`!`) — use `guard let` or `if let` safely
- Run **SwiftLint** if configured before submitting

---

## 🐛 Reporting Bugs

When reporting a bug, please include:

- **Device & iOS version** (e.g. iPhone 13, iOS 16.2)
- **Xcode version** used to build
- **Steps to reproduce** the issue
- **Expected behaviour** vs **actual behaviour**
- **Screenshots or logs** if available

Open a new issue here: [GitHub Issues](https://github.com/himanshu-trip786/SmartCheckout/issues)

---

## 💡 Suggesting Features

Have an idea to improve SmartCheckout? We'd love to hear it!

1. Check [existing issues](https://github.com/himanshu-trip786/SmartCheckout/issues) to avoid duplicates
2. Open a new issue with the label `enhancement`
3. Describe the feature, its use case, and any implementation ideas

---

## 👤 Author

**Himanshu Tripathi** — [@himanshu-trip786](https://github.com/himanshu-trip786)

Thank you for helping make SmartCheckout better! 🛒✨
