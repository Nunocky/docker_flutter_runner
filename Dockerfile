# for ARM Mac
#FROM --platform=linux/x86_64 ghcr.io/cirruslabs/flutter:3.19.5

# for Windows (x86_64)
FROM ghcr.io/cirruslabs/flutter:3.19.5

ARG userid=1000
ARG groupid=1000
ARG username=alice

ENV username=$username
ENV DEBIAN_FRONTEND=noninteractive

#
# Run as root
#
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

#
# From now, run as a user
#
USER $username

ENV PATH="/home/${username}/.pub-cache/bin:/home/${username}/.local/bin:${PATH}"
ENV GRADLE_HOME="/home/${username}/.gradle"
ENV PUB_CACHE_HOME="/home/${username}/.pub-cache"

#
RUN pip install -U pip 
RUN pip install --no-cache-dir lcov_cobertura 
RUN dart pub global activate junitreport

# run as a jenkins node
ENV JENKINS_URL="http://host.docker.internal:8081/"
ENV JENKINS_SECRET="*****"
ENV AGENT_JAR_PATH=/home/$username/agent.jar
ENV AGENT_WORK_DIR=/home/$username/work

COPY agent.jar ${AGENT_JAR_PATH}
RUN sudo chown $username:$username ${AGENT_JAR_PATH}
RUN mkdir ${AGENT_WORK_DIR}

ENTRYPOINT java -jar ${AGENT_JAR_PATH} -url ${JENKINS_URL} -secret ${JENKINS_SECRET} -name "flutter_runner" -workDir ${AGENT_WORK_DIR}

