# Enterprise API Automation Suite
 
<div align="center">
 
[![CI — Build & Test](https://github.com/Vinoth-SDET/Enterprise-API-Automation-Suite/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/Vinoth-SDET/Enterprise-API-Automation-Suite/actions/workflows/ci.yml)
[![Nightly Regression](https://github.com/Vinoth-SDET/Enterprise-API-Automation-Suite/actions/workflows/nightly.yml/badge.svg)](https://github.com/Vinoth-SDET/Enterprise-API-Automation-Suite/actions/workflows/nightly.yml)
[![Allure Report](https://img.shields.io/badge/Allure-Live%20Report-brightgreen)](https://Vinoth-SDET.github.io/Enterprise-API-Automation-Suite)
[![Java 21](https://img.shields.io/badge/Java-21-blue?logo=openjdk&logoColor=white)](https://adoptium.net/)
[![RestAssured](https://img.shields.io/badge/RestAssured-5.4.0-orange)](https://rest-assured.io/)
[![TestNG](https://img.shields.io/badge/TestNG-7.9.0-red)](https://testng.org/)
[![WireMock](https://img.shields.io/badge/WireMock-3.x-blueviolet)](https://wiremock.org/)
[![Tests](https://img.shields.io/badge/Tests-30%20Passing-success)](https://github.com/Vinoth-SDET/Enterprise-API-Automation-Suite/actions)
[![Coverage](https://img.shields.io/badge/Coverage-CRUD%20%7C%20Contract%20%7C%20Negative-blue)](https://github.com/Vinoth-SDET/Enterprise-API-Automation-Suite)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](Dockerfile)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
 
**A production-grade REST API test automation framework** built to enterprise engineering standards —
parallel execution, dual reporting, multi-environment CI/CD, offline contract testing, and zero test-layer coupling to HTTP.
 
📊 **[Live Allure Report](https://Vinoth-SDET.github.io/Enterprise-API-Automation-Suite)** &nbsp;|&nbsp;
⚡ **[CI Pipeline](https://github.com/Vinoth-SDET/Enterprise-API-Automation-Suite/actions)** &nbsp;|&nbsp;
📖 **[Architecture Decisions](docs/architecture.md)**
 
</div>
 
---
 
## What this framework demonstrates
 
| Skill area | Implementation | What it signals |
|---|---|---|
| Framework architecture | Ports & Adapters — tests have zero HTTP coupling | Understands separation of concerns |
| Thread safety | `ThreadLocal<ApiClient>`, 5 concurrent threads, zero flakiness | Parallel execution design |
| Contract testing | JSON Schema draft-07 + WireMock offline stubs | Tests API drift, not just status codes |
| Dual reporting | Allure (GitHub Pages) + ExtentReports (CI artifact) | Stakeholder-aware engineering |
| Multi-environment | `dev` / `qa` / `staging` via JVM flag, zero code changes | Production deployment mindset |
| CI/CD | Matrix strategy, Pages auto-publish, nightly cross-env schedule | CI as a first-class citizen |
| Negative testing | Dedicated `negative/` package, boundary-value `@DataProvider` | Completeness beyond happy path |
| Resilience | `RetryFilter` (5xx backoff) + `RetryAnalyzer` (failure-only retry) | Distributed systems awareness |
| Security | Auth tokens from CI secrets — zero hardcoded credentials | Secure engineering practices |
| Observability | Correlation IDs on every request, async Log4j2 rolling logs | Ops and debugging readiness |
| Test data | `TestDataFactory` (JavaFaker) + externalised JSON fixtures | Realistic, maintainable data strategy |
| Framework packaging | Framework code in `src/main` — publishable as Maven dependency | Organisational reuse mindset |
 
---
 
## Architecture
 
```
┌─────────────────────────────────────────────────────────────────┐
│                         TEST LAYER                               │
│  Smoke · Regression · Contract · Negative · Data-Driven         │
│  Business intent only — zero HTTP concern in any test class      │
└──────────────────────────┬──────────────────────────────────────┘
                           │  calls
┌──────────────────────────▼──────────────────────────────────────┐
│                      SERVICE LAYER                               │
│  UserService · PostService · AuthService                         │
│  @Step annotated — every call is a named step in Allure          │
└──────────────────────────┬──────────────────────────────────────┘
                           │  delegates to
┌──────────────────────────▼──────────────────────────────────────┐
│                    API CLIENT LAYER                               │
│  ApiClient (ThreadLocal)    RequestBuilder (immutable)           │
│  RetryFilter (5xx backoff)  AuthFilter  LoggingFilter            │
│  CorrelationIdProvider      SecretResolver                       │
└──────────────────────────┬──────────────────────────────────────┘
                           │  configured by
┌──────────────────────────▼──────────────────────────────────────┐
│                  INFRASTRUCTURE LAYER                             │
│  ConfigManager (env-aware)  SchemaValidator (draft-07)           │
│  WireMock (contract stubs)  TestDataFactory  Log4j2              │
└─────────────────────────────────────────────────────────────────┘
```
 
The `src/main` package contains the entire framework — independently publishable as a Maven dependency for other test teams. `src/test` contains only test intent, never framework mechanics.
 
---
 
## Tech stack
 
| Tool | Version | Purpose |
|---|---|---|
| Java | 21 | Language — records, text blocks, sealed classes |
| RestAssured | 5.4.0 | HTTP client DSL with filter chain |
| TestNG | 7.9.0 | Test runner, parallel execution, `@DataProvider` |
| Allure | 2.27.0 | Rich HTML report — published to GitHub Pages |
| ExtentReports | 5.1.1 | Self-contained dark-theme HTML dashboard |
| WireMock | 3.x | Offline stub server for contract tests |
| Log4j2 | 2.23.1 | Async rolling-file logging with correlation IDs |
| Jackson | 2.17.1 | JSON serialisation and POJO mapping |
| Lombok | 1.18.32 | `@Builder`, `@Data`, `@RequiredArgsConstructor` |
| AssertJ | 3.25.3 | Fluent assertions with descriptive failure messages |
| JavaFaker | 1.0.2 | Realistic randomised test data generation |
| JSON Schema Validator | 5.4.0 | Draft-07 contract validation |
| GitHub Actions | — | CI/CD: matrix strategy, Pages publish, nightly schedule |
| Docker | — | Hermetic test execution |
 
---
 
## Project structure
 
```
enterprise-api-automation-suite/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── test_gap.md
│   ├── pull_request_template.md
│   └── workflows/
│       ├── ci.yml              # Every PR + push: smoke → regression matrix → Allure
│       └── nightly.yml         # 05:30 AM IST daily: 9-job matrix (3 envs × 3 suites)
│
├── docs/
│   └── architecture.md         # Architecture Decision Records (ADRs)
│
├── src/
│   ├── main/java/com/vinoth/automation/
│   │   ├── client/             # ApiClient, RequestBuilder, RetryFilter,
│   │   │                       # AuthFilter, LoggingFilter, CorrelationIdProvider
│   │   ├── config/             # ConfigManager, EnvironmentConfig, SecretResolver
│   │   ├── constants/          # Endpoints, HttpStatus, Headers
│   │   ├── models/             # Request + Response POJOs (Lombok + Jackson)
│   │   ├── services/           # UserService, PostService, AuthService
│   │   └── utils/              # ResponseValidator, SchemaValidator, RetryAnalyzer,
│   │                           # TestDataFactory, TestDataLoader,
│   │                           # ExtentManager, AllureAttachmentUtil
│   │
│   └── test/
│       ├── java/com/vinoth/automation/
│       │   ├── base/           # BaseTest (ThreadLocal), WireMockBase
│       │   ├── dataproviders/  # UserDataProvider, PostDataProvider
│       │   ├── helpers/        # UserPayloadHelper
│       │   ├── listeners/      # AllureListener, ExtentListener, RetryListener
│       │   └── tests/
│       │       ├── users/      # GetUser, CreateUser, UpdateUser,
│       │       │               # DeleteUser, UserNegative
│       │       ├── posts/      # PostCrud, PostNegative
│       │       └── contract/   # UserContract, PostContract (WireMock)
│       │
│       └── resources/
│           ├── config/         # dev.properties, qa.properties, staging.properties
│           ├── schemas/        # 5 JSON Schema draft-07 files
│           ├── testdata/       # Externalised JSON test fixtures
│           ├── wiremock/       # WireMock stub mappings
│           └── testng-suites/  # smoke, regression, parallel, negative, contract
│
├── .gitignore                  # target/, .idea/, *.iml — all excluded
├── CHANGELOG.md
├── CONTRIBUTING.md
├── Dockerfile
├── Makefile
├── LICENSE
├── pom.xml
└── README.md
```
 
---
 
## Quick start
 
**Prerequisites:** Java 21, Maven 3.8+
 
```bash
# Clone
git clone https://github.com/Vinoth-SDET/Enterprise-API-Automation-Suite
cd Enterprise-API-Automation-Suite
 
# Smoke suite — fastest feedback (~30s)
mvn test -Denv=qa -Dtestng.suite=src/test/resources/testng-suites/smoke.xml
 
# Full regression with parallel execution
mvn test -Denv=qa -Dtestng.suite=src/test/resources/testng-suites/regression.xml -Dthreads=5
 
# Contract tests — runs fully offline, no network needed
mvn test -Dtestng.suite=src/test/resources/testng-suites/contract.xml
 
# Negative tests only
mvn test -Denv=qa -Dtestng.suite=src/test/resources/testng-suites/negative.xml
 
# Full parallel suite — 5 concurrent threads
mvn test -Denv=qa -Dtestng.suite=src/test/resources/testng-suites/parallel.xml -Dthreads=5
 
# Generate and open Allure report locally
mvn allure:serve
```
 
---
 
## Test coverage
 
| Suite | What it covers | Groups | Threads |
|---|---|---|---|
| `smoke.xml` | Core CRUD happy paths | `smoke` | 1 |
| `regression.xml` | Full positive + negative | `regression` | 5 |
| `contract.xml` | WireMock offline schema contracts | `contract` | 1 |
| `negative.xml` | 4xx handling, boundary values | `negative` | 3 |
| `parallel.xml` | Full suite, maximum concurrency | all | 5 |
 
### Test classes — 30 tests across 9 classes
 
| Class | Suites | Tests | Covers |
|---|---|---|---|
| `GetUserTests` | smoke, regression | 4 | List all, get by id, multi-id, 404 |
| `CreateUserTests` | smoke, regression | 3 | Full payload, minimal payload, PUT update |
| `UpdateUserTests` | regression | 3 | Full update, random data, email field |
| `DeleteUserTests` | smoke, regression | 2 | Happy path, response content-type |
| `UserNegativeTests` | regression, negative | 5 | 404, boundary ids, SLA, empty/null fields |
| `PostCrudTests` | smoke, regression | 6 | List, get, create (data-driven), update, delete, filter |
| `PostNegativeTests` | regression, negative | 4 | 404, boundary ids, SLA, invalid filter |
| `UserContractTests` | contract | 4 | GET / POST / DELETE schema contracts (WireMock) |
| `PostContractTests` | contract | 4 | GET / POST / DELETE schema contracts (WireMock) |
 
---
 
## Sample test
 
Full vertical slice — business-readable, schema-validated, Allure-annotated, POJO-deserialised:
 
```java
@Epic("User Management API")
@Feature("GET /users")
public class GetUserTests extends BaseTest {
 
    private UserService userService;
 
    @BeforeMethod(alwaysRun = true)
    public void initService(Method method) {
        userService = new UserService(client()); // fresh ApiClient per invocation
    }
 
    @Test(groups = {"smoke", "regression"})
    @Story("Get user by ID — happy path")
    @Severity(SeverityLevel.BLOCKER)
    public void getUserById_returns200WithValidSchema() {
        Response response = userService.getUserById(1);
 
        UserResponse user = ResponseValidator.of(response)
            .hasStatus(HttpStatus.OK)          // named constant, not magic 200
            .hasContentTypeJson()
            .bodyFieldEquals("id", 1)
            .bodyFieldNotNull("name")
            .bodyMatchesSchema("user-response-schema.json")  // contract check
            .respondsWithin(8000)                             // SLA assertion
            .as(UserResponse.class);                          // typed deserialisation
 
        assertThat(user.getName()).isNotBlank();
        assertThat(user.getEmail()).contains("@");
    }
}
```
 
---
 
## Key design decisions
 
| Decision | Why it matters |
|---|---|
| `ThreadLocal<ApiClient>` | Each parallel thread owns its HTTP client — eliminates race conditions without synchronisation overhead |
| Service layer + `@Step` | Tests read as business specs; every service call is a named step in Allure — full audit trail |
| Immutable `RequestBuilder` | New instance per method call — safe for parallel execution, no shared mutable state |
| `RetryFilter` in `ApiClient` | Transient 5xx handled at framework level — zero retry boilerplate across all test classes |
| `RetryAnalyzer` (FAILURE-only) | Only retries genuine failures — prevents passing tests being retried and `@BeforeMethod` being skipped |
| `@BeforeMethod(alwaysRun = true)` | Service reinitialised on every invocation including retries — prevents NPE on retry path |
| JSON Schema validation | Catches field removals and type changes that status-code checks miss entirely |
| WireMock contract tests | Contracts run fully offline — deterministic, fast CI, no external network dependency |
| `src/main` for framework code | Framework is independently publishable as a Maven dependency for other test teams |
| `ConfigManager` singleton | Environment is a JVM flag — identical test code runs across `dev` / `qa` / `staging` |
| `RetryListener` not annotation | Retry policy configured once in `testng.xml` — zero `retryAnalyzer=` boilerplate on any `@Test` |
| `SecretResolver` interpolation | `${QA_AUTH_TOKEN}` in `.properties` resolved from CI env vars — no secrets ever touch source files |
| `TestDataFactory` (JavaFaker) | Unique realistic data per run — prevents parallel collision and stale fixture drift |
| `EXTERNAL_API_SLA_MS` constant | SLA thresholds named and documented — not magic numbers scattered across test classes |
 
---
 
## Reports
 
Two independent reports are produced on every CI run.
 
### Allure — live on GitHub Pages
 
- Epic / Feature / Story grouping via `@Epic`, `@Feature`, `@Story` annotations
- Full HTTP request + response body captured per step via `@Step` service methods
- Historical trend graph across every CI run
 
🔗 **[https://Vinoth-SDET.github.io/Enterprise-API-Automation-Suite](https://Vinoth-SDET.github.io/Enterprise-API-Automation-Suite)**
 
### ExtentReports — self-contained HTML dashboard
 
- Dark-themed dashboard; open the file directly — no server needed
- PASS / FAIL / SKIP per test with duration, environment, and thread info
- Download from **Actions → Artifacts** after any CI run
 
---
 
## CI/CD pipeline
 
### `ci.yml` — runs on every PR and push to `main`
 
```
Push / PR
    │
    ├── Compile + Smoke (qa)          ~46s
    │       │
    │       ├── Regression (qa)       full test suite
    │       ├── Contract (qa)         WireMock offline
    │       └── Negative (qa)         boundary + 4xx
    │               │
    │               └── Publish Allure → GitHub Pages
```
 
### `nightly.yml` — runs at 05:30 AM IST (23:30 UTC) every day
 
```
Schedule: 05:30 AM IST
    │
    ├── dev  × regression
    ├── dev  × contract
    ├── dev  × negative
    ├── qa   × regression
    ├── qa   × contract
    ├── qa   × negative
    ├── staging × regression
    ├── staging × contract
    └── staging × negative   →  Publish combined Allure report
```
 
9 parallel matrix jobs across 3 environments and 3 suites. `fail-fast: false` ensures all combinations complete even if one fails.
 
---
 
## Environment configuration
 
```properties
# src/test/resources/config/qa.properties
base.url       = https://jsonplaceholder.typicode.com
auth.token     = ${QA_AUTH_TOKEN}    # resolved from CI secret at runtime
max.retries    = 2
retry.delay.ms = 1000
```
 
| JVM flag | Description | Default |
|---|---|---|
| `-Denv` | Active environment (`dev` / `qa` / `staging`) | `qa` |
| `-Dtestng.suite` | Path to TestNG suite XML | `regression.xml` |
| `-Dthreads` | Parallel thread count | `5` |
 
---
 
## Run in Docker
 
```bash
# Build and run
docker build -t api-automation-suite .
docker run -e ENV=qa -e QA_AUTH_TOKEN=$QA_AUTH_TOKEN api-automation-suite
 
# Makefile shortcut
make docker-test ENV=qa SUITE=regression
```
 
---
 
## Contributing
 
See [CONTRIBUTING.md](CONTRIBUTING.md) for branch strategy, commit conventions, and the PR checklist.
 
Use GitHub issue templates:
- **Bug report** — for test failures or framework defects
- **Test gap** — to propose coverage for an untested scenario
 
---
 
## Changelog
 
See [CHANGELOG.md](CHANGELOG.md) for a full history of framework changes by version.
 
---
 
## Author
 
**Vinoth M** — Staff SDET | Test Automation Architect | 11+ years across BFSI, Healthcare, SaaS
 
[![GitHub](https://img.shields.io/badge/GitHub-Vinoth--SDET-181717?logo=github)](https://github.com/Vinoth-SDET)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-vinoth--m--qa-0A66C2?logo=linkedin)](https://linkedin.com/in/vinoth-m-qa)
 
---
 
> *Every design decision in this framework is documented in [`docs/architecture.md`](docs/architecture.md) and defensible in a technical interview. Each one maps to a real engineering trade-off encountered in production automation at scale.*
 
