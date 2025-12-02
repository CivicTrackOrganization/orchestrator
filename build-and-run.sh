FRONTEND_REPO_URL="https://github.com/CivicTrackOrganization/frontend.git"
BACKEND_REPO_URL="https://github.com/anaradzetski/civic-track.git"
FRONTEND_DIR="temp_frontend"
BACKEND_DIR="temp_backend"
ENV_FILE=".env"

echo "1. Cloning repositories..."

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: Required environment file '$ENV_FILE' not found. Please create it locally."
    exit 1
fi

rm -rf $FRONTEND_DIR $BACKEND_DIR

git clone $FRONTEND_REPO_URL $FRONTEND_DIR
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to fetch frontend repository. Exiting."
    exit 1
fi

git clone $BACKEND_REPO_URL $BACKEND_DIR
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to fetch backend repository. Exiting."
    exit 1
fi

echo "2. Building images and running containers..."

docker-compose --env-file "$ENV_FILE" up --build  -d

if [ $? -ne 0 ]; then
    echo "ERROR: Docker Compose failed to build or run. Exiting without cleanup."
    exit 1
fi

echo "Images build and containers are running in the background"

echo "3. Cleaning up temporary source code directories..."

rm -rf $FRONTEND_DIR $BACKEND_DIR

echo "Deployment complete. Containers are running."
echo "Use 'docker-compose logs' to view output."
echo "Use 'docker-compose down' to stop and remove containers."