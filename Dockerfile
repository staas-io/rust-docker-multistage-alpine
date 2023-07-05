##### Builder
FROM rust:1.61.0-slim as builder

WORKDIR /usr/src

# Create blank project
RUN USER=root cargo new rust-main

# We want dependencies cached, so copy those first.
COPY Cargo.toml Cargo.lock /usr/src/rust-main/

# Set the working directory
WORKDIR /usr/src/rust-main

## Install target platform (Cross-Compilation) --> Needed for Alpine target
RUN rustup target add x86_64-unknown-linux-musl

# This is a dummy build to get the dependencies cached. 
RUN cargo build --target x86_64-unknown-linux-musl --release

# Now copy in the rest of the sources
COPY src /usr/src/rust-main/src/

## Touch main.rs to prevent cached release build
RUN touch /usr/src/rust-main/src/main.rs

# This is the actual application build.
RUN cargo build --target x86_64-unknown-linux-musl --release

##### Runtime 
FROM alpine:3.16.0 AS runtime 

# Copy application binary from builder image
COPY --from=builder /usr/src/rust-main/target/x86_64-unknown-linux-musl/release/rust-main /usr/local/bin

EXPOSE 3030

# Run the application
CMD ["/usr/local/bin/rust-main"]



