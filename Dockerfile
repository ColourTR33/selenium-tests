# Use the official Ubuntu image as the base
FROM ubuntu:20.04

# Set the timezone (optional, adjust as needed)
ENV TZ=Europe/London
ENV USER root

RUN apt-get update && apt-get install -y tzdata

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    unzip \
    xvfb \
    openbox \
    chromium-browser \
    chromium-chromedriver \
    firefox \
    tightvncserver \
    novnc \
    websockify \
    curl \
    && apt-get clean

# Install geckodriver (for Firefox)
RUN GECKODRIVER_VERSION=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest | grep 'tag_name' | cut -d '"' -f 4) && \
    wget https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    tar -xvzf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    mv geckodriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/geckodriver && \
    rm geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz

# Install Selenium and Pylint
RUN pip3 install selenium pylint

# Set the display port to avoid errors
ENV DISPLAY=:1

# Set the working directory
WORKDIR /app

# Create a logs directory
RUN mkdir logs

# Copy your test code into the container
COPY . /app

# Set a valid VNC password
ENV VNC_PASSWORD=MyPass123!

# Start VNC server, websockify, and the window manager
CMD ["sh", "-c", "mkdir -p ~/.vnc && echo \"$VNC_PASSWORD\" | vncpasswd -f && mv ~/.vnc/passwd ~/.vnc/passwd.bak && echo \"$VNC_PASSWORD\" | vncpasswd -f ~/.vnc/passwd && chmod 600 ~/.vnc/passwd && vncserver :1 -geometry 1920x1080 -depth 24 && websockify --web /usr/share/novnc 6080 localhost:5901 && tail -f /dev/null"]
