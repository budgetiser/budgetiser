FROM ubuntu:noble

# Inspired by: Developing Flutter Applications Inside a DevContainer:
# - https://blog.devops.dev/developing-flutter-applications-inside-a-devcontainer-4b13de5369e2

###############################
# Stage 1 — Base Dependencies #
###############################
FROM ubuntu:noble AS base-deps

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        # mentioned in official flutter install docs (https://docs.flutter.dev/install/manual)
        curl git unzip xz-utils zip libglu1-mesa \
        # required android sdk dependencies
        android-sdk wget openjdk-17-jdk \
        # mentioned as required on first run of flutter doctor
        clang cmake ninja-build pkg-config libgtk-3-dev \
        # general stuff
        git-all && \
    rm -rf /var/lib/apt/lists/*


###################################
# Stage 2 — Android SDK + Flutter #
###################################
FROM base-deps AS android-flutter

# use `sdkmanager --list` to get available packages
ARG ANDROID_PLATFORM_PACKAGE="platforms;android-36"
ARG ANDROID_BUILD_TOOLS_PACKAGE="build-tools;36.0.0"

ARG ANDROID_SDK_ROOT=/usr/lib/android-sdk
# URL found at: https://developer.android.com/studio?hl=de
ARG CMDLINE_TOOLS_DOWNLOAD_URL="https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip"

ARG FLUTTER_SDK_VERSION=3.38.4-stable
# URL found at: https://docs.flutter.dev/install/manual
ARG FLUTTER_SDK_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz"
ARG FLUTTER_SDK_ROOT=/usr/lib/flutter

# Add to PATH
ENV PATH="${PATH}:${FLUTTER_SDK_ROOT}/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Install Android command line tools, required to install other Android SDK components
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -O /tmp/cmdtools.zip ${CMDLINE_TOOLS_DOWNLOAD_URL} && \
    unzip /tmp/cmdtools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdtools.zip

# Accept licenses + install Android components
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses && \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager \
        ${ANDROID_PLATFORM_PACKAGE} \
        ${ANDROID_BUILD_TOOLS_PACKAGE} \
        # always install platform-tools
        "platform-tools"

# Install Flutter SDK
RUN mkdir -p ${FLUTTER_SDK_ROOT} && \
    cd /usr/lib && \
    curl -OL ${FLUTTER_SDK_DOWNLOAD_URL} && \
    tar -xf flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz && \
    rm flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz

# Flutter requires its SDK directory to be a "safe" git directory
RUN git config --global --add safe.directory /usr/lib/flutter

#################################
# Stage 3 — Final Runtime Image #
#################################

FROM ubuntu:noble AS runtime
ENV DEBIAN_FRONTEND=noninteractive

COPY --from=android-flutter /usr/lib/flutter /usr/lib/flutter
COPY --from=android-flutter /usr/lib/android-sdk /usr/lib/android-sdk
ENV PATH="${PATH}:/usr/lib/flutter/bin:/usr/lib/android-sdk/cmdline-tools/latest/bin:/usr/lib/android-sdk/platform-tools"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl unzip xz-utils libglu1-mesa openjdk-17-jdk git-all \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global --add safe.directory /usr/lib/flutter
RUN flutter --disable-analytics

SHELL ["/bin/bash", "-c"]