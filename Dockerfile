FROM public.ecr.aws/lambda/python:3.8

COPY ./assets/requirements-yum.txt /tmp
RUN if [[ -s "/tmp/requirements-yum.txt" ]]; then yum install -y $(cat /tmp/requirements-yum.txt); fi && \
    rm /tmp/requirements-yum.txt && \
    yum clean all && (rm -rf /var/cache/yum || true)

COPY ./requirements.txt /tmp
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt --target "${LAMBDA_TASK_ROOT}/pylibs" && \
    rm /tmp/requirements.txt && \
    (rm -rf /var/task/pylibs/torch/include/ /var/task/pylibs/torch/test || true)

COPY ./requirements-extra.txt /tmp
RUN pip3 install --no-cache-dir -r /tmp/requirements-extra.txt --target "${LAMBDA_TASK_ROOT}/pylibs" && \
    rm /tmp/requirements-extra.txt
