FROM swiftdocker/swift:3.0.2

MAINTAINER muukii <m@muukii.me>

WORKDIR /local
ENV BRANCH json

RUN git clone --depth=1 -b $SWIFT_PROTOBUF_TAG https://github.com/muukii/L10n.swift.git

