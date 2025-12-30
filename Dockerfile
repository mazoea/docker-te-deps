FROM public.ecr.aws/lambda/python:3.12

# default pip user directory - if we use something else to install pip, the pip will not recognise already installed packages
ENV SYSPYTHONCACHE=/root/.local/lib/python3.12/site-packages/
ENV MAZPYTHONCACHE=/var/runtime/

# make sure pip will find already installed packages
ENV PYTHONPATH="${MAZPYTHONCACHE}"

COPY ./assets/requirements*.txt /tmp

RUN echo $PYTHONPATH && \
    \
    if [[ -s "/tmp/requirements-os.txt" ]]; then dnf install -y $(cat /tmp/requirements-os.txt); fi && \
    rm -f /tmp/requirements-os.txt && \
    dnf clean all && (rm -rf /var/cache/dnf || true) && \
    \
    pip3 install -q --no-cache-dir --user -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    (rm -rf $SYSPYTHONCACHE/torch/include/ $SYSPYTHONCACHE/torch/test || true) && \
    \
    pip3 install -q --no-cache-dir --user -r /tmp/requirements-extra.txt && \
    rm /tmp/requirements-extra.txt && \
    \
    cp -rf $SYSPYTHONCACHE/* $MAZPYTHONCACHE && \
    rm -rf $SYSPYTHONCACHE && \
    \
    ls -lah /tmp/
