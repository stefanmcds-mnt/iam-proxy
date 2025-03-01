FROM alpine:3.21.2

# Metadata params
ARG BUILD_DATE="2025-02-26"
ARG VERSION="1.0.0"
ARG VCS_URL="https://github.com/stefanmcds-mnt/iam-proxy.git"
ARG VCS_REF="1.0.0"
ARG AUTHORS="STEFAN MCDS S.a.s."
ARG VENDOR="STEFAN MCDS S.a.s."

# Metadata : https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.authors=$AUTHORS \
      org.opencontainers.image.vendor=$VENDOR \
      org.opencontainers.image.title="iam-proxy" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.source=$VCS_URL \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.description="Docker Image di iam-proxy-italia."

ENV BASEDIR="/satosa_proxy"
RUN mkdir $BASEDIR

RUN addgroup -S satosa && adduser -S satosa -G satosa && chown satosa:satosa $BASEDIR


# "tzdata"  package is required to set timezone with TZ environment
# "mailcap" package is required to add mimetype support
RUN apk add --update --no-cache tzdata mailcap xmlsec libffi-dev openssl-dev python3-dev py3-pip openssl build-base gcc wget bash pcre-dev

COPY poetry.lock /
COPY pyproject.toml /

RUN python3 -m venv .venv && . .venv/bin/activate
RUN pip3 install --upgrade pip --break-system-packages
RUN pip3 install flake8 pipx poetry --break-system-packages
RUN poetry self update
RUN poetry config virtualenvs.in-project true
RUN poetry install
RUN poetry add setuptools

WORKDIR $BASEDIR/
