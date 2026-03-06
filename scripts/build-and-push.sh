#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-}"
DOCKER_HUB_TOKEN="${DOCKER_HUB_TOKEN:-}"
DOCKER_HUB_REPO="${DOCKER_HUB_REPO:-copperlib/opencode-x-devcontainer}"

SUBDIRS=(
    "opencode-python"
    "opencode-nodejs"
    "opencode-go"
    "opencode-rust"
    "opencode-ubuntu22.04-cuda12.4.1"
    "opencode-ubuntu22.04-cuda12.8.1"
    "opencode-ubuntu22.04-cuda12.9.1"
    "opencode-ubuntu22.04-cuda13.1.0"
    "opencode-ubuntu24.04-cuda12.8.1"
    "opencode-ubuntu24.04-cuda12.9.1"
    "opencode-ubuntu24.04-cuda13.1.0"
)

usage() {
    echo "Usage: DOCKER_HUB_USERNAME=user DOCKER_HUB_TOKEN=token DOCKER_HUB_REPO=repo $0 [command] [image-name]"
    echo ""
    echo "Commands:"
    echo "  all         Build and push all images"
    echo "  list        List available images"
    echo "  build       Build specific image (no Docker credentials needed)"
    echo "  push        Push specific image (requires Docker credentials)"
    echo "  push-all    Push all images (requires Docker credentials)"
    echo "  build-all   Build all images (no Docker credentials needed)"
    echo ""
    echo "Examples:"
    echo "  $0 all"
    echo "  $0 build opencode-python"
    echo "  $0 push opencode-python"
    echo "  $0 push-all"
    echo "  $0 build-all"
    echo ""
    echo "Environment variables:"
    echo "  DOCKER_HUB_USERNAME  Docker Hub username (required for push/all)"
    echo "  DOCKER_HUB_TOKEN     Docker Hub access token (required for push/all)"
    echo "  DOCKER_HUB_REPO      Docker Hub repository name (default: copperlib/opencode-x-devcontainer)"
}

list_images() {
    echo "Available images:"
    for dir in "${SUBDIRS[@]}"; do
        echo "  - $dir"
    done
}

get_image_name() {
    local dir="$1"
    local tag="${dir#opencode-}"
    echo "opencode-x-devcontainer:${tag}"
}

docker_login() {
    if [ -z "$DOCKER_HUB_USERNAME" ] || [ -z "$DOCKER_HUB_TOKEN" ]; then
        echo "Error: DOCKER_HUB_USERNAME and DOCKER_HUB_TOKEN are required"
        usage
        exit 1
    fi
    echo "Logging in to Docker Hub..."
    echo "$DOCKER_HUB_TOKEN" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
}

build_image() {
    local dir="$1"
    local image_name
    image_name="$(get_image_name "$dir")"

    echo "========================================"
    echo "Building: $image_name"
    echo "Directory: $dir"
    echo "========================================"

    docker build -t "$image_name" -f "$dir/Dockerfile" "$PROJECT_ROOT" --build-arg HTTPS_PROXY=$https_proxy --build-arg HTTP_PROXY=$https_proxy

    echo "Built successfully: $image_name"
    echo ""
}

push_image() {
    local dir="$1"
    local image_name
    image_name="$(get_image_name "$dir")"

    echo "Pushing: ${DOCKER_HUB_USERNAME}/$image_name"
    docker push "${DOCKER_HUB_USERNAME}/$image_name"
    echo "Pushed successfully: ${DOCKER_HUB_USERNAME}/$image_name"
    echo ""
}

build_all_images() {
    for dir in "${SUBDIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            build_image "$dir"
        fi
    done

    echo "========================================"
    echo "All images built successfully!"
    echo "========================================"
}

push_all_images() {
    if [ -z "$DOCKER_HUB_USERNAME" ]; then
        echo "Error: DOCKER_HUB_USERNAME is required for push-all"
        usage
        exit 1
    fi
    docker_login

    for dir in "${SUBDIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            push_image "$dir"
        fi
    done

    echo "========================================"
    echo "All images pushed successfully!"
    echo "========================================"
}

build_and_push_all() {
    docker_login

    for dir in "${SUBDIRS[@]}"; do
        if [ -d "$PROJECT_ROOT/$dir" ]; then
            build_image "$dir"
            push_image "$dir"
        fi
    done

    echo "========================================"
    echo "All images built and pushed successfully!"
    echo "========================================"
}

build_specific() {
    local dir="$1"

    local found=0
    for existing in "${SUBDIRS[@]}"; do
        if [ "$existing" = "$dir" ]; then
            found=1
            break
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "Error: Unknown image '$dir'"
        list_images
        exit 1
    fi

    if [ ! -d "$PROJECT_ROOT/$dir" ]; then
        echo "Error: Directory '$dir' does not exist"
        exit 1
    fi

    build_image "$dir"
    echo "Done!"
}

push_specific() {
    local dir="$1"

    local found=0
    for existing in "${SUBDIRS[@]}"; do
        if [ "$existing" = "$dir" ]; then
            found=1
            break
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "Error: Unknown image '$dir'"
        list_images
        exit 1
    fi

    docker_login
    push_image "$dir"
    echo "Done!"
}

COMMAND="${1:-all}"
IMAGE_NAME="${2:-}"

case "$COMMAND" in
    all)
        build_and_push_all
        ;;
    list)
        list_images
        ;;
    build)
        if [ -z "$IMAGE_NAME" ]; then
            echo "Error: Image name required for build command"
            usage
            exit 1
        fi
        build_specific "$IMAGE_NAME"
        ;;
    push)
        if [ -z "$IMAGE_NAME" ]; then
            echo "Error: Image name required for push command"
            usage
            exit 1
        fi
        push_specific "$IMAGE_NAME"
        ;;
    build-all)
        build_all_images
        ;;
    push-all)
        push_all_images
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        echo "Error: Unknown command '$COMMAND'"
        usage
        exit 1
        ;;
esac
