#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
IMAGE="${PLM_SERVICE_IMAGE:-aibiz/plmservice:local}"
MAVEN_IMAGE="${PLM_MAVEN_IMAGE:-maven:3.9-eclipse-temurin-11}"
JAR="$SCRIPT_DIR/plm-provider.jar"

docker run --rm \
  --network host \
  -v "$ROOT_DIR:/workspace" \
  -v "$ROOT_DIR/.m2:/root/.m2" \
  -w /workspace/plm/backend \
  "$MAVEN_IMAGE" \
  mvn -f pom.xml \
    -P runtime \
    -DskipTests \
    -Dmaven.test.skip=true \
    -Dmaven.javadoc.skip=true \
    clean package

test -s "$JAR"
docker build \
  --build-arg JRE_IMAGE="${PLM_JRE_IMAGE:-eclipse-temurin:11-jre}" \
  -t "$IMAGE" \
  "$SCRIPT_DIR"

printf 'Built %s\n' "$IMAGE"
