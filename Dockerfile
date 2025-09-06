# Use a lightweight base image
FROM alpine:3.18

# Install bash, jq, and ttyd (for web terminal access)
RUN apk add --no-cache bash jq ttyd

# Set working directory
WORKDIR /app

# Copy your script into the image
COPY app/shift.sh /app/shift.sh
RUN chmod +x /app/shift.sh

# Create a directory for persistent JSON storage
VOLUME ["/data"]

# Set environment variable for data file
ENV DATA_FILE=/data/shifts.json

# Expose ttyd on port 7681
EXPOSE 7681

# Run ttyd, which wraps your script in a web terminal
CMD ["ttyd", "-p", "7681", "/app/shift.sh"]
