FROM ubuntu:22.04

ARG pip_mirror

COPY ./cnap /cnap

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*_*

RUN pip3 install ${pip_mirror} --upgrade --no-cache-dir pip && \
    pip3 install ${pip_mirror} --no-cache-dir -r /cnap/requirements.txt

USER someone
