FROM public.ecr.aws/lambda/python:3.12

# Packages go to the system site-packages, where pip in derived images sees them as installed.
# MAZPYTHONCACHE / PYTHONPATH stay for derived images that reference them (te-doc-rotator
# appends to PYTHONPATH).
ENV MAZPYTHONCACHE=/var/runtime/
ENV PYTHONPATH="${MAZPYTHONCACHE}"

COPY ./assets/requirements*.txt /tmp

RUN if [[ -s "/tmp/requirements-os.txt" ]]; then dnf install -y $(cat /tmp/requirements-os.txt); fi && \
    rm -f /tmp/requirements-os.txt && \
    dnf clean all && (rm -rf /var/cache/dnf || true) && \
    \
    echo "Installing Python dependencies ..." && \
    pip3 install --no-cache-dir --require-hashes -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    TORCH_DIR=$(python3 -c 'import torch, pathlib; print(pathlib.Path(torch.__file__).parent)') && \
    (rm -rf "$TORCH_DIR/include" "$TORCH_DIR/test" || true) && \
    pip3 check
