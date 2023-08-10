# Builder stage
# FROM cirrusci/flutter:3.7.5 AS builder
FROM ghcr.io/cirruslabs/flutter:3.12.0 AS builder
ARG env
ENV ENV=${env}
ARG scope

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

RUN echo "TESTING is: $PWD"
RUN echo $(ls -1 /app/apps/)
RUN echo $(ls -1 /app/apps/${scope})

# Build web app using Melos with a specific scope
RUN DATE_VERSION=$(date +"%Y_%m_%d_%H_%M") && \
    sed -i "s|release: RELEASE_CHANGE_ME|release: ${DATE_VERSION}|g" /app/apps/${scope}/pubspec.yaml && \
    melos exec --scope="$scope" -- flutter build web --web-renderer html --release --source-maps --dart-define=VERSION=${DATE_VERSION} --dart-define=ENV=${env}
    # melos exec --scope="app_gs" -- flutter build web --web-renderer canvaskit --release --source-maps --dart-define=VERSION=${DATE_VERSION} --dart-define=ENV=${env} && \
    # melos exec --scope=\"${scope}\" -- flutter packages pub run sentry_dart_plugin

RUN echo "PWD is: $PWD"
RUN echo $(ls -1 /app/apps/app_gs)

# Production stage
FROM nginx:stable-alpine
ARG scope
RUN apk add bash && \
    ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo Asia/Taipei > /etc/timezone
# COPY --from=builder /app/ /app/
# RUN ls -la /app/
RUN echo "PWD is: $PWD"
RUN echo $(ls -1 ./app/apps/)
COPY --from=builder /app/apps/${scope}/build/web /usr/share/nginx/html
ENTRYPOINT nginx -g "daemon off;"
