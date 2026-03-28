FROM --platform=linux/amd64 ghcr.io/cirruslabs/flutter:3.13.9

# Create non-root user
RUN useradd -ms /bin/bash flutteruser

# Set working directory
WORKDIR /app

# Copy project
COPY . .

# Change ownership
RUN chown -R flutteruser:flutteruser /app

# Switch user
USER flutteruser

# Accept licenses
RUN yes | sdkmanager --licenses || true

# Build
RUN flutter pub get
RUN flutter build apk --release

CMD ["bash"]