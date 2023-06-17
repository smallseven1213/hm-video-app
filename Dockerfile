# Builder stage
# FROM cirrusci/flutter:3.7.5 AS builder
FROM ghcr.io/cirruslabs/flutter:3.10.2 AS builder
ARG env
ENV ENV=${env}
WORKDIR /app
COPY . /app

# Install Melos
RUN flutter pub global activate melos 2.9.0

# Set PATH for melos executable
ENV PATH="/root/.pub-cache/bin:$PATH"

# Clear .pub-cache temp directory
RUN rm -rf /root/.pub-cache/_temp/*

# Clear Flutter cache
RUN rm -rf /sdks/flutter/.pub-cache

# Install sentry-cli
RUN curl -sL https://sentry.io/get-cli/ | bash

# Set DATE_VERSION
RUN DATE_VERSION=$(date +"%Y_%m_%d_%H_%M")

# Modify pubspec.yaml file
RUN sed -i "s|release:.*|release: ${DATE_VERSION}|g" /app/apps/app_gs/pubspec.yaml

# Build web app using Melos with a specific scope
RUN melos exec --scope="app_gs" -- flutter build web --web-renderer canvaskit --release --source-maps --dart-define=VERSION=${DATE_VERSION} --dart-define=ENV=${env} && \
    melos exec --scope="app_gs" -- flutter packages pub run sentry_dart_plugin && \
    echo "Current DATE_VERSION is: ${DATE_VERSION}"

# Production stage
FROM nginx:stable-alpine
RUN apk add bash && \
    ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo Asia/Taipei > /etc/timezone
# COPY --from=builder /app/ /app/
# RUN ls -la /app/
COPY --from=builder /app/apps/app_gs/build/web /usr/share/nginx/html
ENTRYPOINT nginx -g "daemon off;"

RUN echo "Current DATE_VERSION is: ${DATE_VERSION}"