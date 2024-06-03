# Builder stage
FROM growerp/flutter-sdk-image:3.22.1 AS builder
ARG env
ENV ENV=${env}
ARG scope

WORKDIR /app
COPY . /app

# Clear .pub-cache temp directory (if any)
RUN rm -rf /root/.pub-cache/_temp/*

# Clear Flutter cache (if any)
RUN rm -rf /sdks/flutter/.pub-cache

# Install Melos
RUN flutter pub global activate --no-cache melos 3.1.1

# Set PATH for melos executable
ENV PATH="/root/.pub-cache/bin:$PATH"

# Install sentry-cli
RUN curl -sL https://sentry.io/get-cli/ | bash

RUN echo "TESTING is: $PWD"
RUN echo $(ls -1 /app/apps/)
RUN echo $(ls -1 /app/apps/${scope})

# Build web app using Melos with a specific scope
RUN DATE_VERSION=$(date +"%Y_%m_%d_%H_%M") && \
    sed -i "s|release: RELEASE_CHANGE_ME|release: ${DATE_VERSION}|g" /app/apps/${scope}/pubspec.yaml && \
    melos exec --scope="$scope" -- flutter build web --web-renderer html --release --source-maps --dart-define=VERSION=${DATE_VERSION} --dart-define=ENV=${env}

RUN echo "PWD is: $PWD"
RUN echo $(ls -1 /app/apps/app_gs)

# Production stage
FROM nginx:stable-alpine
ARG scope
RUN apk add bash && \
    ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && \
    echo Asia/Taipei > /etc/timezone

RUN echo "PWD is: $PWD"
RUN echo $(ls -1 ./app/apps/)
COPY --from=builder /app/apps/${scope}/build/web /usr/share/nginx/html
ENTRYPOINT ["nginx", "-g", "daemon off;"]
