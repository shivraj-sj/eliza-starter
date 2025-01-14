#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {build|run|start|bash}"
    exit 1
fi

# Execute the corresponding command based on the argument
case "$1" in
    build)
        docker build --platform linux/amd64 -t eliza-starter .
        ;;
    run)
        # Ensure the container is not already running
        if [ "$(docker ps -q -f name=eliza-starter)" ]; then
            echo "Container 'eliza-starter' is already running. Stopping it first."
            docker stop eliza-starter
            docker rm eliza-starter
        fi

        # Define base directories to mount
        BASE_MOUNTS=(
            "characters:/app/characters"
            ".env:/app/.env"
            "src:/app/src"
            "scripts:/app/scripts"
        )

        # Start building the docker run command
        CMD="docker run --platform linux/amd64 -p 3000:3000 -it"

        # Add base mounts
        for mount in "${BASE_MOUNTS[@]}"; do
            CMD="$CMD -v \"$(pwd)/$mount\""
        done

        # # Add core types mount separately (special case)
        # CMD="$CMD -v \"$(pwd)/packages/core/types:/app/packages/core/types\""

        # Add container name and image
        CMD="$CMD --name eliza-starter eliza-starter"

        # Execute the command
        eval $CMD
        ;;
    start)
        docker start eliza-starter
        ;;
    bash)
        # Check if the container is running before executing bash
        if [ "$(docker ps -q -f name=eliza-starter)" ]; then
            docker exec -it eliza-starter bash
        else
            echo "Container 'eliza-starter' is not running. Please start it first."
            exit 1
        fi
        ;;
    *)
        echo "Invalid option: $1"
        echo "Usage: $0 {build|run|start|bash}"
        exit 1
        ;;
esac