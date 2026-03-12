# ── Stage 1: Dependency resolution (cached layer) ────────────────────────────
# Separating dependency download from test execution means Docker cache is
# invalidated only when pom.xml changes — not every time test code changes.
FROM maven:3.9-eclipse-temurin-21-alpine AS deps

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B --no-transfer-progress


# ── Stage 2: Test execution ───────────────────────────────────────────────────
FROM deps AS test

COPY src/ src/

# Build arguments — override at docker build time:
# docker build --build-arg ENV=staging --build-arg SUITE=regression .
ARG ENV=qa
ARG SUITE=regression
ARG THREADS=5

ENV ENV=${ENV}

# Run tests; copy reports to /output for docker run -v extraction
RUN mvn test -B --no-transfer-progress \
      -Denv=${ENV} \
      -Dtestng.suite=src/test/resources/testng-suites/${SUITE}.xml \
      -Dthreads=${THREADS} \
      -Dlog.level=INFO ; \
    EXIT_CODE=$? ; \
    mkdir -p /output ; \
    cp -r allure-results /output/ 2>/dev/null || true ; \
    cp -r target/logs    /output/ 2>/dev/null || true ; \
    exit $EXIT_CODE

# Extract reports after run:
# docker run --rm -v $(pwd)/output:/output api-tests
CMD ["sh", "-c", "cp -r allure-results /output/ && cp -r target/logs /output/"]