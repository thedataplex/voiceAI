# Use the latest stable Flutter image with the correct Dart SDK version
FROM cirrusci/flutter:latest

# Install dependencies required for Flutter and Chrome
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    wget \
    gnupg \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable

# Create a non-root user called flutteruser
RUN useradd -ms /bin/bash flutteruser

# Set the working directory to /app
WORKDIR /app

# Copy the application code to the working directory
COPY . .

# Change ownership of the application directory to flutteruser
RUN chown -R flutteruser:flutteruser /app

# Change ownership of the Flutter SDK to flutteruser
RUN chown -R flutteruser:flutteruser /sdks/flutter

# Switch to the non-root user
USER flutteruser

# Ensure the Flutter tool is in the path for flutteruser
ENV PATH="/sdks/flutter/bin:/sdks/flutter/bin/cache/dart-sdk/bin:/usr/bin/google-chrome:${PATH}"

# Set the Flutter SDK directory as a safe repository
RUN git config --global --add safe.directory /sdks/flutter

# Ensure the flutter and dart directories are writable
RUN chmod -R u+w /sdks/flutter

# Run flutter pub get
RUN flutter pub get

# Verify Chrome installation
RUN google-chrome --version

# Command to run the Flutter app in Chrome
CMD ["flutter", "run", "-d", "chrome", "--web-port=5000"]
