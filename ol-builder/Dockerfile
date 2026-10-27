FROM ghcr.io/crazy-max/osxcross:26.1-r0-ubuntu AS osxcross

# ============================================= #
FROM opensuse/leap:16.0 AS intermediate

WORKDIR /tmp

RUN set -euo pipefail \
    && test "$(uname -m)" = x86_64 \
    && zypper -n --gpg-auto-import-keys refresh \
    && zypper -n install --no-recommends ca-certificates oras unzip tar gzip \
    && zypper clean --all

COPY --from=osxcross /osxcross/ /opt/osxcross/

RUN set -euo pipefail \
    && rm -rf /opt/osxcross/SDK \
    && mkdir -p /opt/osxcross/SDK /tmp/ios-sdks \
    && oras pull ghcr.io/zengxs/apple-ios-sdks:26.1-xcode26.1.1-17b100-40333668404-1 \
        --output /tmp/ios-sdks \
    && tar -xzf /tmp/ios-sdks/iPhoneOS26.1.sdk.tar.gz -C /opt/osxcross/SDK \
    && tar -xzf /tmp/ios-sdks/iPhoneSimulator26.1.sdk.tar.gz -C /opt/osxcross/SDK \
    && test -f /opt/osxcross/SDK/iPhoneOS26.1.sdk/SDKSettings.json \
    && test -f /opt/osxcross/SDK/iPhoneSimulator26.1.sdk/SDKSettings.json \
    && chmod -R a+rX /opt/osxcross \
    && rm -rf /tmp/ios-sdks

RUN set -euo pipefail \
    && mkdir -p /tmp/ohos-tools /opt/ohos \
    && oras pull docker.io/zengxs/ohos-commandline-tools:26.0.0.821 \
        --output /tmp/ohos-tools \
    && unzip -q /tmp/ohos-tools/commandline-tools-linux-x64-26.0.0.821.zip -d /opt/ohos \
    && test -x /opt/ohos/command-line-tools/bin/hvigorw \
    && test -x /opt/ohos/command-line-tools/bin/ohpm \
    && test -x /opt/ohos/command-line-tools/tool/node/bin/node \
    && test -d /opt/ohos/command-line-tools/sdk/default \
    && chmod -R a+rX /opt/ohos \
    && rm -rf /tmp/ohos-tools

# ============================================= #
FROM opensuse/leap:16.0 AS final

ARG ANDROID_API=35
ARG BUILD_TOOLS_VERSION=34.0.0
ARG TASK_VERSION=3.54.0

ENV ANDROID_HOME=/opt/android-sdk
ENV JAVA_HOME=/usr/lib64/jvm/java-17-openjdk
ENV JAVA_HOME_21=/usr/lib64/jvm/java-21-openjdk
ENV OHOS_COMMAND_LINE_TOOLS_HOME=/opt/ohos/command-line-tools
ENV PATH=/usr/local/bin:${JAVA_HOME}/bin:${OHOS_COMMAND_LINE_TOOLS_HOME}/bin:${ANDROID_HOME}/platform-tools:/opt/osxcross/bin:${PATH}

RUN set -euo pipefail \
    && test "$(uname -m)" = x86_64 \
    && zypper -n ar https://download.opensuse.org/repositories/devel:tools:compiler/16.0/devel:tools:compiler.repo \
    && zypper -n --gpg-auto-import-keys ref \
    && zypper -n in --no-recommends -t pattern 'devel_C_C++' \
    && zypper -n in --no-recommends \
        llvm-devel \
        clang-devel \
        lld \
        libbz2-1 \
        liblzma5 \
        libopenssl3 \
        libxml2-2 \
        libncurses6 \
        libstdc++6 \
        libz1 \
        libglvnd \
        java-17-openjdk-devel \
        java-21-openjdk-devel \
        python313 \
        python313-pip \
        python313-Jinja2 \
        python313-PyYAML \
        ca-certificates \
        git-core \
        git-lfs \
        protobuf-devel \
        curl \
        jq \
        glab \
        oras \
        ripgrep \
        tar \
        gzip \
        unzip \
        zstd \
        xz \
        which \
    && zypper clean --all

# Install go-task
RUN set -euo pipefail \
    && python3.13 -m venv /opt/task \
    && /opt/task/bin/python -m pip install --no-cache-dir \
        "go-task-bin==${TASK_VERSION}" \
    && ln -s /opt/task/bin/task /usr/local/bin/task \
    && task --version

# Install Quarto
ARG QUARTO_VER=1.10.19
RUN set -euo pipefail \
    && mkdir -p /opt/quarto \
    && curl -sSLo /tmp/quarto.tar.gz \
        https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VER}/quarto-${QUARTO_VER}-linux-amd64.tar.gz \
    && tar --strip-components=1 -xf /tmp/quarto.tar.gz -C /opt/quarto \
    && rm -rf /tmp/quarto.tar.gz \
    && ln -s /opt/quarto/bin/quarto /usr/local/bin/quarto \
    && quarto --version

# Install Android CLI
RUN set -euo pipefail \
    && test "$(uname -m)" = x86_64 \
    && install -d -m 0755 "${ANDROID_HOME}" \
    && curl --fail --show-error --location --retry 3 \
        https://dl.google.com/android/cli/latest/linux_x86_64/android \
        --output /usr/local/bin/android \
    && chmod 0755 /usr/local/bin/android \
    && android --version

# Install Android SDK
RUN set -euo pipefail \
    && android --no-metrics --sdk="${ANDROID_HOME}" sdk install \
        platform-tools \
        "platforms/android-${ANDROID_API}" \
        "build-tools/${BUILD_TOOLS_VERSION}" \
    && android --no-metrics --sdk="${ANDROID_HOME}" sdk list

COPY --from=intermediate /opt/ohos/ /opt/ohos/
COPY --from=intermediate /opt/osxcross/ /opt/osxcross/

RUN /opt/ohos/command-line-tools/bin/ohpm --version

RUN /opt/osxcross/bin/osxcross

RUN printf '%s\n' /opt/osxcross/lib > /etc/ld.so.conf.d/osxcross.conf \
    && ldconfig
