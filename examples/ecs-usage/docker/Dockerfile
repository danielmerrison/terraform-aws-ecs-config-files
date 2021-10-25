FROM amazonlinux:2

RUN yum update -y; \
  yum install -y \
  jq; \
  yum clean all;

COPY ./app /usr/local/bin
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh; \
  chmod +x /usr/local/bin/app;

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]
