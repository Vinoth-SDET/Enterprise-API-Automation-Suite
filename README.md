# 🚀 API Automation Framework

![API Automation Tests](https://github.com/Vinoth-AutomationQA/api-automation-restassured-ci/actions/workflows/api-tests.yml/badge.svg)
![Java](https://img.shields.io/badge/Java-21-orange?logo=java)
![RestAssured](https://img.shields.io/badge/RestAssured-5.4.0-green)
![TestNG](https://img.shields.io/badge/TestNG-7.9.0-red)
![Maven](https://img.shields.io/badge/Maven-3.9.x-blue?logo=apachemaven)
![Allure](https://img.shields.io/badge/Allure-2.25.0-yellow)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

> Professional REST API Test Automation Framework built with
> RestAssured, TestNG, Maven and GitHub Actions CI/CD pipeline.

---

## 📋 Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Test Coverage](#test-coverage)
- [How to Run](#how-to-run)
- [CI/CD Pipeline](#cicd-pipeline)
- [Allure Report](#allure-report)

---

## 🎯 Overview

This framework demonstrates **enterprise-grade API test automation** skills including:

- ✅ REST API testing with RestAssured fluent DSL
- ✅ JSON Schema validation (contract testing)
- ✅ Page Object / Specification pattern (BaseTest)
- ✅ Configuration management (no hardcoded values)
- ✅ CI/CD pipeline with GitHub Actions
- ✅ Beautiful HTML reports with Allure
- ✅ Professional Git workflow

**Target API:** [JSONPlaceholder](https://jsonplaceholder.typicode.com) — Free REST API for testing

---

## 🛠️ Tech Stack

| Technology | Version | Purpose |
|---|---|---|
| Java | 21 (LTS) | Programming language |
| RestAssured | 5.4.0 | API testing library |
| TestNG | 7.9.0 | Test framework & runner |
| Maven | 3.9.x | Build & dependency management |
| Allure | 2.25.0 | Test reporting |
| GitHub Actions | Latest | CI/CD pipeline |
| Jackson | 2.16.1 | JSON serialization |

---

## 📁 Project Structure
```
api-automation-restassured-ci/
├── .github/
│   └── workflows/
│       └── api-tests.yml          # CI/CD pipeline
├── src/
│   ├── main/java/
│   │   └── utils/
│   │       ├── ConfigManager.java  # Config reader (Singleton)
│   │       └── Constants.java      # All constants & endpoints
│   └── test/
│       ├── java/
│       │   ├── base/
│       │   │   └── BaseTest.java   # RestAssured setup
│       │   ├── helpers/
│       │   │   └── UserPayloadHelper.java  # Request builders
│       │   └── tests/
│       │       ├── GetUserTest.java     # GET tests
│       │       ├── PostUserTest.java    # POST tests
│       │       └── DeleteUserTest.java  # DELETE tests
│       └── resources/
│           ├── schemas/
│           │   ├── get_post_schema.json    # GET schema
│           │   └── create_post_schema.json # POST schema
│           ├── config.properties.template  # Config template
│           └── testng.xml                  # Test suite
└── pom.xml                                 # Maven config
```

---

## ✅ Test Coverage

| Test Class | Endpoint | Tests | Validations |
|---|---|---|---|
| `GetUserTest` | `GET /posts/2` | 4 | Status, Body, Schema, Fields |
| `PostUserTest` | `POST /posts` | 4 | Status, Echo, ID, Schema |
| `DeleteUserTest` | `DELETE /posts/2` | 3 | Status, Body, Performance |
| **Total** | **3 endpoints** | **11** | **100% passing** |

### Validation Types
- 🔵 **Status Code** — HTTP response code verification
- 🟢 **Response Body** — Field value assertions
- 🟡 **JSON Schema** — Contract/structure validation
- 🔴 **Performance** — Response time under 3000ms

---

## ▶️ How to Run

### Prerequisites
```bash
Java 21+
Maven 3.9+
Git
```

### Setup
```bash
# Clone the repository
git clone https://github.com/Vinoth-AutomationQA/api-automation-restassured-ci.git
cd api-automation-restassured-ci

# Copy config template
cp src/test/resources/config.properties.template \
   src/test/resources/config.properties
```

### Run Tests
```bash
# Run all tests
mvn clean test

# Run specific test class
mvn clean test -Dtest=GetUserTest

# Run with verbose output
mvn clean test -X
```

### Generate Allure Report
```bash
# Generate and open report in browser
allure serve target/allure-results
```

---

## ⚙️ CI/CD Pipeline

Every push to `main` branch automatically:
```
1. ✅ Checkout code
2. ✅ Setup Java 21
3. ✅ Create config.properties
4. ✅ Run all 11 tests via Maven
5. ✅ Upload Allure results artifact
6. ✅ Upload Surefire reports artifact
```

Pipeline file: [`.github/workflows/api-tests.yml`](.github/workflows/api-tests.yml)

---

## 📊 Allure Report

The framework generates rich Allure reports showing:
- Test execution timeline
- Pass/fail rate by feature
- Full request & response details
- Epic → Feature → Story hierarchy

**Local report:**
```bash
mvn clean test
allure serve target/allure-results
```

---

## 🏗️ Framework Architecture
```
BaseTest (Setup)
    │
    ├── RequestSpecification  ← Base URL, Headers, Filters
    ├── ResponseSpecification ← Content-Type validation
    └── AllureRestAssured     ← Request/Response logging
         │
         ▼
    Test Classes
         │
         ├── GetUserTest    → given/when/then → assertions
         ├── PostUserTest   → payload → assertions
         └── DeleteUserTest → delete → verify empty body
```

---

## 👨‍💻 Author

**Vinoth M**
- 10+ years QA experience
- SDET | API Automation | CI/CD
- GitHub: [@Vinoth-AutomationQA](https://github.com/Vinoth-AutomationQA)

---

## 📄 License

This project is licensed under the MIT License.