FROM public.ecr.aws/lambda/python:3.8

COPY ./assets/requirements-yum.txt /tmp
RUN if [[ -s "/tmp/requirements-yum.txt" ]]; then yum install -y $(cat /tmp/requirements-yum.txt); fi && \
    rm /tmp/requirements-yum.txt && \
    yum clean all && (rm -rf /var/cache/yum || true)

# default pip user directory
ENV MAZPYTHONCACHE=/root/.local/lib/python3.8/site-packages/

COPY ./assets/requirements.txt /tmp
RUN pip3 install --no-cache-dir --user -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    (rm -rf $MAZPYTHONCACHE/torch/include/ $MAZPYTHONCACHE/torch/test || true)

COPY ./assets/requirements-extra.txt /tmp
RUN pip3 install --no-cache-dir --user -r /tmp/requirements-extra.txt && \
    rm /tmp/requirements-extra.txt


RUN pip3 install --no-cache-dir --user "urllib3<2.0" Transformers

COPY ./assets/models.py /tmp
RUN cd /tmp && python3 models.py