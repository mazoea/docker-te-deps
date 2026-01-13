FROM public.ecr.aws/lambda/python:3.12

# default pip user directory - if we use something else to install pip, the pip will not recognise already installed packages
ENV SYSPYTHONCACHE=/root/.local/lib/python3.12/site-packages/
ENV MAZPYTHONCACHE=/var/runtime/

# make sure pip will find already installed packages
ENV PYTHONPATH="${MAZPYTHONCACHE}"
ENV PYTHONDONTWRITEBYTECODE=0

COPY ./assets/requirements*.txt /tmp

RUN echo $PYTHONPATH && \
    \
    if [[ -s "/tmp/requirements-os.txt" ]]; then dnf install -y $(cat /tmp/requirements-os.txt); fi && \
    rm -f /tmp/requirements-os.txt && \
    dnf clean all && (rm -rf /var/cache/dnf || true) && \
    \
    echo "Installing Python dependencies ..." && \
    pip3 install --no-cache-dir --user -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    (rm -rf $SYSPYTHONCACHE/torch/include/ $SYSPYTHONCACHE/torch/test || true) && \
    \
    echo "Installing Extra Python dependencies ..." && \
    pip3 install --no-cache-dir --user -r /tmp/requirements-extra.txt && \
    rm /tmp/requirements-extra.txt && \
    \
    python -m compileall -q /var/runtime /var/lang/lib/python3.12/site-packages/ && \
    \
    mv -f $SYSPYTHONCACHE/* $MAZPYTHONCACHE && \
    ls -lahR $SYSPYTHONCACHE && \
    rm -rf $SYSPYTHONCACHE && \
    \
    ls -lah /tmp/ && \
    ls -lah /root/.local/ || true && \
    ls -lahR /root/.local/lib/ || true

