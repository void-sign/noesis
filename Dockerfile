# Use an official lightweight image as a parent image
FROM debian:bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    make \
    fish \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Check if we're using the new structure
RUN if [ -d "/app/noesis-core" ] && [ -d "/app/noesis-extensions" ]; then \
        # Build using the new structure \
        chmod +x ./build_all.fish; \
        fish ./build_all.fish; \
    else \
        # Use legacy build \
        make; \
    fi

# Command to run the application
CMD ["fish", "./run_noesis.fish", "core"]
