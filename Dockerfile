# Builder stage
# FROM cirrusci/flutter:3.7.5 AS builder
FROM ghcr.io/cirruslabs/flutter:3.12.0 AS builder
ARG env
ENV ENV=${env}
WORKDIR /app
COPY . /app

# Install Melos
RUN flutter pub global activate melos 3.1.0

# Set PATH for melos executable
ENV PATH="/root/.pub-cache/bin:$PATH"

# Clear .pub-cache temp directory
RUN rm -rf /root/.pub-cache/_temp/*

# Clear Flutter cache
RUN rm -rf /sdks/flutter/.pub-cache

# Install sentry-cli
RUN curl -sL https://sentry.io/get-cli/ | bash

# Build web app using Melos with a specific scope
RUN DATE_VERSION=$(date +"%Y_%m_%d_%H_%M") && \
    sed -i "s|release: RELEASE_CHANGE_ME|release: ${DATE_VERSION}|g" /app/apps/app_gs/pubspec.yaml && \
    melos exec --scope="app_gs" -- flutter build web --web-renderer canvaskit --release --source-maps --dart-define=VERSION=${DATE_VERSION} --dart-define=ENV=${env}
    # melos exec --scope="app_gs" -- flutter build web --web-renderer canvaskit --release --source-maps --dart-define=VERSION=${DATE_VERSION} --dart-define=ENV=${env} && \
    # melos exec --scope="app_gs" -- flutter packages pub run sentry_dart_plugin

# Production stage
FROM nginx:stable-alpine
RUN apk add bash && \
    ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo Asia/Taipei > /etc/timezone
# COPY --from=builder /app/ /app/
# RUN ls -la /app/
COPY --from=builder /app/apps/app_gs/build/web /usr/share/nginx/html
ENTRYPOINT nginx -g "daemon off;"
