FROM public.ecr.aws/lambda/python:3.13

# default pip user directory - if we use something else to install pip, the pip will not recognise already installed packages
ENV SYSPYTHONCACHE=/root/.local/lib/python3.13/site-packages/
ENV MAZPYTHONCACHE=/var/runtime/

# make sure pip will find already installed packages
ENV PYTHONPATH="${MAZPYTHONCACHE}:$PYTHONPATH"

COPY ./assets/requirements*.txt /tmp

RUN echo $PYTHONPATH && \
    \
    if [[ -s "/tmp/requirements-yum.txt" ]]; then dnf install -y $(cat /tmp/requirements-yum.txt); fi && \
    rm /tmp/requirements-yum.txt && \
    dnf clean all && (rm -rf /var/cache/dnf || true) && \
    \
    pip3 install --no-cache-dir --user -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    (rm -rf $SYSPYTHONCACHE/torch/include/ $SYSPYTHONCACHE/torch/test || true) && \
    \
    pip3 install --no-cache-dir --user -r /tmp/requirements-extra.txt && \
    rm /tmp/requirements-extra.txt && \
    \
    cp -rf $SYSPYTHONCACHE/* $MAZPYTHONCACHE && \
    rm -rf $SYSPYTHONCACHE && \
    \
    ls -lah /tmp/
