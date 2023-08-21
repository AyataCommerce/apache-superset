FROM apache/superset
# We switch to root
USER root

ENV TINI_VERSION v0.19.0
RUN curl --show-error --location --output /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64
RUN chmod +x /tini

RUN 	apt-get update \
        && apt-get install -qq -y --no-install-recommends \
        sudo \
        make \
        unzip \
        curl \
        jq \
        && rm -rf /var/lib/apt/lists/* \
        && usermod -aG sudo superset \
        && echo "superset ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# We install the Python interface for Redis
COPY local_requirements.txt .
RUN pip install -r local_requirements.txt
# We add the superset_config.py file to the container
COPY /superset/superset_config.py /app/
# We tell Superset where to find it
ENV SUPERSET_CONFIG_PATH /app/superset_config.py
COPY /docker/superset-entrypoint.sh /app/docker/
COPY /docker/docker-bootstrap.sh /app/docker/
COPY /docker/docker-init.sh /app/docker
COPY /docker/docker-entrypoint.sh /app/docker/

# We give permissions to different files
RUN chmod +x /app/docker/superset-entrypoint.sh
RUN chmod +x /app/docker/docker-entrypoint.sh
RUN chmod +x /app/docker/docker-init.sh
RUN chmod +x /app/docker/docker-bootstrap.sh

# We switch back to the `superset` user
USER superset
ENTRYPOINT ["/tini", "-g", "--","/app/docker/docker-entrypoint.sh"]