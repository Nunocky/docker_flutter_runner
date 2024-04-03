# for ARM Mac
FROM --platform=linux/x86_64 ghcr.io/cirruslabs/flutter:3.19.5

# for Windows (x86_64)
#FROM ghcr.io/cirruslabs/flutter:3.19.5

ARG userid=1000
ARG groupid=1000

ENV userid=$userid
ENV groupid=$groupid
ENV username=runner

ENV PATH="/home/${username}/.pub-cache/bin:/home/${username}/.local/bin:${PATH}"
ENV GRADLE_HOME="/home/${username}/.gradle"
ENV PUB_CACHE_HOME="/home/${username}/.pub-cache"

#
# Run as root
#
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa
RUN apt-get install -y \
    tzdata iputils-ping net-tools vim \
    python3-pip \
    build-essential gcc g++ make libtool dpkg-dev \
    clang cmake \
    ninja-build pkg-config \
    libgtk-3-dev liblzma-dev \
    libstdc++-12-dev \
    libpng-dev libjpeg-dev
RUN apt-get autoremove -y 
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/*

RUN sdkmanager "emulator" 

# Add user $username
RUN groupadd -g $groupid $username 
RUN useradd -m -u $userid --groups sudo -g $groupid $username 
RUN echo "${username}:${username}" | chpasswd

RUN chown -R $username:$username $ANDROID_HOME 
RUN chown -R $username:$username $FLUTTER_HOME

COPY entrypoint.sh /home/${username}/entrypoint.sh
RUN chmod +x /home/${username}/entrypoint.sh

RUN mkdir -p $GRADLE_HOME
RUN chown -R $username:$username $GRADLE_HOME

RUN mkdir -p $PUB_CACHE_HOME
RUN chown -R $username:$username $PUB_CACHE_HOME

#
# From now, run as a user
#
USER $username

RUN pip install -U pip 
RUN pip install --no-cache-dir lcov_cobertura 
RUN dart pub global activate junitreport
RUN dart pub global activate fvm

CMD bash /home/${username}/entrypoint.sh

VOLUME ${GRADLE_HOME}
VOLUME ${PUB_CACHE_HOME}
