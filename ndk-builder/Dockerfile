FROM opensuse/leap:16.0

ARG ANDROID_API=36
ARG BUILD_TOOLS_VERSION=36.0.0
ARG NDK_VERSION=30.0.16248370
ARG TASK_VERSION=3.54.0

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${NDK_VERSION}
ENV PATH=/usr/local/bin:${ANDROID_HOME}/platform-tools:${PATH}


RUN set -euo pipefail \
    && zypper -n  ar https://download.opensuse.org/repositories/devel:tools:compiler/16.0/devel:tools:compiler.repo \
    && zypper -n --gpg-auto-import-keys ref \
    && zypper -n in --no-recommends -t pattern 'devel_C_C++' \
    && zypper -n in --no-recommends \
# LLVM
        llvm22-devel \
        clang22-devel \
        lld22 \
# C/C++
        cmake \
        ninja \
# Rust
        rustup \
# Java
        java-17-openjdk-devel \
# Python
        python313-pip \
        python313-Jinja2 \
# Others
        ca-certificates \
        git-core \
        protobuf-devel \
        curl \
        jq \
        glab \
        oras \
        ripgrep \
        tar \
        unzip \
        zstd \
        xz \
        xxd \
    && zypper clean --all

# Install go-task
RUN set -euo pipefail \
    && python3.13 -m venv /opt/task \
    && /opt/task/bin/python -m pip install --no-cache-dir \
        "go-task-bin==${TASK_VERSION}" \
    && ln -s /opt/task/bin/task /usr/local/bin/task \
    && task --version

# Install Android CLI
RUN set -euo pipefail \
    && test "$(uname -m)" = x86_64 \
    && install -d -m 0755 "${ANDROID_HOME}" \
    && curl --fail --show-error --location --retry 3 \
        https://dl.google.com/android/cli/latest/linux_x86_64/android \
        --output /usr/local/bin/android \
    && chmod 0755 /usr/local/bin/android \
    && android --version

# Install Android SDK/NDK
RUN set -euo pipefail \
    && android --no-metrics --sdk="${ANDROID_HOME}" sdk install \
        platform-tools \
        "platforms/android-${ANDROID_API}" \
        "build-tools/${BUILD_TOOLS_VERSION}" \
        "ndk/${NDK_VERSION}" \
    && android --no-metrics --sdk="${ANDROID_HOME}" sdk list \
    && "${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/clang" --version
