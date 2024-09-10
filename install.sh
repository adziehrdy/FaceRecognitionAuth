#!/bin/bash

# Enable error handling
set -e

# Define variables
URL="https://github.com/am15h/tflite_flutter_plugin/releases/download/"
TAG="v0.2.0"

ANDROID_DIR="android/app/src/main/jniLibs/"
ANDROID_LIB="libtensorflowlite_c.so"

ARM_DELEGATE="libtensorflowlite_c_arm_delegate.so"
ARM_64_DELEGATE="libtensorflowlite_c_arm64_delegate.so"
ARM="libtensorflowlite_c_arm.so"
ARM_64="libtensorflowlite_c_arm64.so"
X86="libtensorflowlite_c_x86.so"
X86_64="libtensorflowlite_c_x86_64.so"

d=0

# Parse options
while getopts ":d" opt; do
case $opt in
    d)
      d=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Function to download and move libraries
download() {
local file_name="$1"
local arch_dir="$2"

curl -L -o "$file_name" "${URL}${TAG}/${file_name}"
mkdir -p "${ANDROID_DIR}${arch_dir}/"
mv -f "$file_name" "${ANDROID_DIR}${arch_dir}/${ANDROID_LIB}"
}

# Download libraries based on the selected mode
if [ "$d" -eq 1 ]; then
download "$ARM_DELEGATE" "armeabi-v7a"
download "$ARM_64_DELEGATE" "arm64-v8a"
else
download "$ARM" "armeabi-v7a"
download "$ARM_64" "arm64-v8a"
fi

download "$X86" "x86"
download "$X86_64" "x86_64"

echo "Download and installation completed!"