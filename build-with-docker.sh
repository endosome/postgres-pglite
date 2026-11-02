# although we could use any path inside docker, using the same path as on the host
# allows the DWARF info (when building in DEBUG) to contain the correct file paths
DOCKER_WORKSPACE=$(pwd)
echo "PGLITE_VERSION=${PGLITE_VERSION}"
echo "DEBUG=${DEBUG}"

# electricsql/pglite-builder plus Rust, for the extensions written in Rust (timescaledb_toolkit)
BUILDER_IMAGE=pglite-builder-rust:6.0.5-1
docker build -q -t ${BUILDER_IMAGE} pglite/other_extensions/timescaledb_toolkit/pglite > /dev/null || exit 1
  
docker run $@ \
  --rm \
  -e DEBUG=${DEBUG:-false} \
  -e PGLITE_VERSION=${PGLITE_VERSION} \
  --workdir=${DOCKER_WORKSPACE} \
  -v .:${DOCKER_WORKSPACE}:rw \
  -v ./dist:/pglite:rw \
  ${BUILDER_IMAGE}  \
  ./build-pglite.sh
