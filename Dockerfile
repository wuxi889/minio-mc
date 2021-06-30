FROM golang:1.15-alpine as builder

LABEL maintainer="Wuxi <wuxi@wufeng-network.com>"

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GO111MODULE on

RUN  \
     apk update && \
     apk add --no-cache zip && \
     apk add --no-cache git && \
     apk add --no-cache curl && \
     git clone https://github.com/minio/mc && cd mc && \
     go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)"

FROM alpine

ARG TARGETARCH

COPY --from=builder /go/bin/mc /usr/bin/mc
COPY --from=builder /go/mc/CREDITS /licenses/CREDITS
COPY --from=builder /go/mc/LICENSE /licenses/LICENSE

# RUN  \
#      microdnf update --nodocs && \
#      microdnf install ca-certificates --nodocs && \
#      microdnf clean all
     
# CMD ['sh']
ENTRYPOINT ["mc"]
