# te-server's dependencies on the AWS Lambda Python 3.12 image, one image per architecture.
# ci.yml builds it natively on each architecture and a tag push publishes <tag>-amd64 and
# <tag>-arm64.
#
# assets/requirements.txt and assets/requirements-os.txt are byte-for-byte copies of
# te-server's files. Do not edit them here: re-lock in te-server, then copy both files over.
# The image keeps them in /opt/te-deps; te-server's CI compares /opt/te-deps/requirements.txt
# with its own requirements.txt.
FROM public.ecr.aws/lambda/python:3.12

LABEL org.opencontainers.image.source="https://github.com/mazoea/docker-te-deps"
LABEL org.opencontainers.image.description="te-server dependencies from its hashed lockfile on public.ecr.aws/lambda/python:3.12"

# Packages go to the system site-packages, where pip in derived images sees them as installed.
# MAZPYTHONCACHE / PYTHONPATH stay for derived images that reference them (te-doc-rotator
# appends to PYTHONPATH).
ENV MAZPYTHONCACHE=/var/runtime/
ENV PYTHONPATH="${MAZPYTHONCACHE}"

COPY ./assets/requirements.txt ./assets/requirements-os.txt /opt/te-deps/

RUN if [[ -s /opt/te-deps/requirements-os.txt ]]; then dnf install -y $(cat /opt/te-deps/requirements-os.txt); fi && \
    dnf clean all && (rm -rf /var/cache/dnf || true) && \
    \
    echo "Installing Python dependencies ..." && \
    pip3 install --no-cache-dir --require-hashes -r /opt/te-deps/requirements.txt && \
    TORCH_DIR=$(python3 -c 'import torch, pathlib; print(pathlib.Path(torch.__file__).parent)') && \
    (rm -rf "$TORCH_DIR/include" "$TORCH_DIR/test" || true) && \
    pip3 check
