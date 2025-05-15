# Use an official lightweight image as a parent image
FROM debian:bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Noesis system
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    make \
    fish \
    git \
    curl \
    libssl-dev \
    pkg-config \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies for quantum modules
RUN pip3 install qiskit numpy matplotlib

# Set the working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Set proper permissions for scripts
RUN chmod +x ./run.fish ./test.fish ./install.fish

# Environment setup
ENV NOESIS_ROOT=/app
ENV NOESIS_QUANTUM_BACKEND=stub
ENV PYTHONPATH=${PYTHONPATH}:/app/system/memory/quantum
# Optional: Set your IBM Quantum API key here or mount as a secret
# ENV IBM_QUANTUM_KEY=your_api_key_here

# Expose port (if your application needs network access)
EXPOSE 8080

# Volume for persistent data
VOLUME ["/app/data"]

# Command to run the application
ENTRYPOINT ["fish"]
CMD ["./run.fish"]
