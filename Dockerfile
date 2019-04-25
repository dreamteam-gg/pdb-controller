FROM golang:1.12.4-alpine3.9 as builder

ENV PDB_CONTROLLER_VERSION 83feac8889390f11af1fbb951b7bb39c3b09b5da

WORKDIR /go/src/

RUN apk --no-cache add git

RUN git clone https://github.com/mikkeloscar/pdb-controller && \
    cd pdb-controller && \
    git checkout ${PDB_CONTROLLER_VERSION} && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-extldflags '-static'" -o pdb-controller

FROM alpine:3.9 as runner

COPY --from=builder /go/src/pdb-controller/pdb-controller /usr/bin/pdb-controller

ENTRYPOINT ["pdb-controller"]
