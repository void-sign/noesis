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

# Build the project
RUN chmod +x ./build.fish && \
    fish ./build.fish

# Command to run the application
CMD ["fish", "./run.fish"]
