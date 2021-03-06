FROM ubuntu:14.04

ADD setproxyforaptget.sh /etc/
RUN chmod +x /etc/setproxyforaptget.sh
RUN /etc/setproxyforaptget.sh

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get upgrade -y && \
    echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing sudo software-properties-common git libxext-dev libxrender-dev libxslt1.1 \
        libxtst-dev libgtk2.0-0 libcanberra-gtk-module unzip nano curl && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update -qq && \
    echo 'Installing JAVA 7 & 8' && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -qq -y --fix-missing oracle-java7-installer && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -qq -y --fix-missing oracle-java8-installer && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ENV MAVEN_VERSION 3.3.9

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo

RUN mkdir -p /home/developer/.IdeaIC15/config/options && \
    mkdir -p /home/developer/.IdeaIC15/config/plugins

# ADD ./jdk.table.xml /home/developer/.IdeaIC15/config/options/jdk.table.xml
# ADD ./jdk.table.xml /home/developer/.jdk.table.xml

ADD ./run /usr/local/bin/intellij

RUN chmod +x /usr/local/bin/intellij && \
    chown developer:developer -R /home/developer/.IdeaIC15

RUN echo 'Downloading IntelliJ IDEA' && \
    wget https://download.jetbrains.com/idea/ideaIC-15.0.2.tar.gz -O /tmp/intellij.tar.gz -q && \
    echo 'Installing IntelliJ IDEA' && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz

RUN echo 'Installing .ignore plugin' && \
    wget https://plugins.jetbrains.com/files/7495/20861/idea-gitignore.jar -O /home/developer/.IdeaIC15/config/plugins/idea-gitignore.jar -q

RUN echo 'Installing Markdown plugin' && \
    wget https://plugins.jetbrains.com/files/7793/22165/markdown.zip -O /home/developer/.IdeaIC15/config/plugins/markdown.zip -q && \
    cd /home/developer/.IdeaIC15/config/plugins/ && \
    unzip -q markdown.zip && \
    rm markdown.zip

RUN echo 'Installing Scala plugin' && \
    wget https://plugins.jetbrains.com/files/1347/23664/scala-intellij-bin-2.2.0.zip -O /home/developer/.IdeaIC15/config/plugins/scala.zip -q && \
    cd /home/developer/.IdeaIC15/config/plugins/ && \
    unzip -q scala.zip && \
    rm scala.zip

RUN mkdir /home/freshinstall && cp -r /home/developer/.IdeaIC15 /home/freshinstall

#install docker client
RUN curl -sSL https://get.docker.com/ | sh && usermod -aG docker developer

#install scala and sbt
RUN apt-get remove -qq -y scala-library scala && \
    cd /tmp && \
    apt-get install -y --fix-missing libjansi-java && \
    wget www.scala-lang.org/files/archive/scala-2.10.4.deb && \
    dpkg -i scala-2.10.4.deb && \
    apt-get update -qq && \
    apt-get install -y --fix-missing scala && \
    wget https://dl.bintray.com/sbt/debian/sbt-0.13.8.deb && \
    dpkg -i sbt-0.13.8.deb && \
    apt-get update -qq && \
    apt-get install -y --fix-missing sbt && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

USER developer
ENV HOME /home/developer
# ENV GOPATH /home/developer/go
# ENV PATH $PATH:/home/developer/go/bin:/usr/local/go/bin
WORKDIR /home/developer
CMD /usr/local/bin/intellij
