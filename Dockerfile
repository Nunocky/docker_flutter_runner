# for ARM Mac
FROM --platform=linux/x86_64 ghcr.io/cirruslabs/flutter:3.19.5

# for Windows (x86_64)
#FROM ghcr.io/cirruslabs/flutter:3.19.5

ARG userid=1000
ARG groupid=1000
ARG username=alice

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

RUN sdkmanager "emulator" 

# run as a jenkins node
#COPY agent.jar /home/${username}/agent.jar
#RUN sudo chown $username:$username /home/${username}/agent.jar
#RUN mkdir /home/${username}/work
#CMD java -jar /home/${username}/agent.jar -url http://jenkins.local/ -secret ***** -name "flutter_runner" -workDir "/home/$username/work"

CMD /bin/bash -i

VOLUME ${GRADLE_HOME}
VOLUME ${PUB_CACHE_HOME}