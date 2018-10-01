FROM alpine:3.8
RUN apk -v --update add \
        python \
        py-pip \
        py-setuptools \
        groff \
        less \
        && \
    pip install --upgrade okta-awscli python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG CODEOWNERS
ARG PROFILE_FILE

COPY $PROFILE_FILE /root/.okta-aws

LABEL org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors=$CODEOWNERS \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.title=mongo-backup \
      org.opencontainers.image.source="https://github.com/qlik-trial/mongo-backup-docker" \
      org.opencontainers.image.vendor=Qlik

ENTRYPOINT ["okta-awscli"]
