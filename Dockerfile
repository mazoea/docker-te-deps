FROM public.ecr.aws/lambda/python:3.8

COPY ./assets/requirements*.txt /tmp

# default pip user directory - if we use something else to install pip, the pip will not recognise already installed packages
ENV MAZPYTHONCACHE=/root/.local/lib/python3.8/site-packages/

RUN if [[ -s "/tmp/requirements-yum.txt" ]]; then yum install -y $(cat /tmp/requirements-yum.txt); fi && \
    rm /tmp/requirements-yum.txt && \
    yum clean all && (rm -rf /var/cache/yum || true) && \
    \
    pip3 install --no-cache-dir --user -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    (rm -rf $MAZPYTHONCACHE/torch/include/ $MAZPYTHONCACHE/torch/test || true) && \
    \
    pip3 install --no-cache-dir --user -r /tmp/requirements-extra.txt && \
    rm /tmp/requirements-extra.txt && \
    \
    ls -lah /tmp/


