# Use a base image with a newer version of Flutter and Dart
FROM debian:stable-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget gnupg2 ca-certificates unzip xz-utils git python3 --no-install-recommends && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz && \
    tar xf flutter_linux_3.22.2-stable.tar.xz && \
    mv flutter /opt/ && \
    rm flutter_linux_3.22.2-stable.tar.xz

# Create a non-root user
RUN useradd -ms /bin/bash flutteruser

# Set environment variables
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Set the working directory and change ownership
WORKDIR /home/flutteruser/app
RUN chown -R flutteruser:flutteruser /home/flutteruser/app /opt/flutter

# Switch to the non-root user
USER flutteruser

# Pre-download the Flutter dependencies
RUN flutter config --no-analytics && \
    flutter doctor && \
    flutter precache

# Copy the current directory contents into the container at /home/flutteruser/app
COPY --chown=flutteruser:flutteruser . .

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run the Flutter web application
# CMD ["flutter", "run", "-d", "chrome", "--web-port", "3000", "--web-browser-flag", "--headless", "--web-browser-flag", "--disable-gpu", "--web-browser-flag", "--no-sandbox"]
# CMD ["flutter", "run", "-d", "web-server", "--web-port", "3000"]
CMD ["flutter", "run", "-d", "web-server", "--web-port", "3000", "--web-hostname", "0.0.0.0"]
