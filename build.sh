#!/usr/bin/env bash
set -euo pipefail

WORKDIR="${WORKDIR:-$HOME/src}"
REPO_URL="https://github.com/ClassiCube/ClassiCube.git"
BRANCH="master"
JOBS="$(nproc)"

echo "== ClassiCube build for RISC-V with Zink Wrapper Configuration =="

# --- Dependency Installation ---
echo "--- Installing Dependencies ---"
# Installing all necessary dependencies, including development headers for EGL/GLES/X
sudo apt update
sudo apt install -y \
  git build-essential pkg-config \
  libx11-dev libxi-dev libxrandr-dev libxinerama-dev libxss-dev \
  libegl1-mesa-dev libgles2-mesa-dev \
  libopenal-dev libcurl4-openssl-dev \
  libpng-dev libfreetype6-dev zlib1g-dev \
  libsdl2-dev libenet-dev \
  mesa-utils-extra

# --- Source Code Management ---
echo "--- Managing Source Code ---"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

if [ -d ClassiCube/.git ]; then
  cd ClassiCube
  echo "Pulling latest changes..."
  git pull --ff-only
else
  echo "Cloning repository..."
  git clone "$REPO_URL"
  cd ClassiCube
fi

# hard clean (critical)
make clean || true
git clean -xfd

# --- Makefile Modification (Change 1: Add -lm) ---
# Goal: Ensure -lm is linked for math functions
echo "--- Patching Makefile to include -lm ---"
# Finds the LIBS line under the linux platform block and appends ' -lm'
sed -i '/ifeq ($(PLAT),linux)/!b;n;/LIBS\s*=/ s/$/ -lm/' Makefile
echo "--- Makefile patched successfully. ---"

# --- Build ---
echo "--- Building ClassiCube (make linux) ---"
make linux

# --- Verification ---
echo "== Verifying binary existence =="

# Define the location of the newly built binary
BIN_DIR="$WORKDIR/ClassiCube"
BIN="$BIN_DIR/ClassiCube"

if [ ! -f "$BIN" ]; then
    echo "ERROR: ClassiCube binary not found at $BIN"
    exit 1
fi

echo "== Build Verified: ClassiCube binary exists =="

# --- Create Zink Wrapper (Change 2) ---
echo "--- Creating Zink Wrapper Script ---"

# 1. Rename the original binary
ORIG_BIN_NAME="ClassiCube.bin"
mv "$BIN" "$BIN_DIR/$ORIG_BIN_NAME"
echo "Renamed actual binary to: $ORIG_BIN_NAME"

# 2. Create the wrapper script named 'ClassiCube'
WRAPPER_SCRIPT="$BIN_DIR/ClassiCube"

# Use cat to write the wrapper script content
cat << EOF > "$WRAPPER_SCRIPT"
#!/usr/bin/env bash
# This wrapper script forces the use of the Zink Vulkan driver for OpenGL/OpenGL ES acceleration.

# Ensure we are in the correct directory for relative paths
cd "\$(dirname "\$0")"

# Set the MESA override and execute the original binary, passing all arguments (\$@)
# 
MESA_LOADER_DRIVER_OVERRIDE=zink ./$ORIG_BIN_NAME "\$@"
EOF

# 3. Make the wrapper executable
chmod +x "$WRAPPER_SCRIPT"
echo "Created executable wrapper: $WRAPPER_SCRIPT"

echo "== Final Configuration Complete =="
echo
echo "Success! ClassiCube built and configured to automatically use the Zink driver."
echo "To run the application, use:"
echo "  cd $BIN_DIR"
echo "  ./ClassiCube --debug"
