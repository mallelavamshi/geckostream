# Use Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose port 8501 for Streamlit
EXPOSE 8501

# Set environment variables
ENV ANTHROPIC_API_KEY=""
ENV SEARCH_API_KEY=""

# Command to run the application
CMD ["streamlit", "run", "app.py", "--server.address", "0.0.0.0"]