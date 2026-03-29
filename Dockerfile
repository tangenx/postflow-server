FROM dart:3.11.2 AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart build cli bin/server.dart

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/build/cli/linux_x64/bundle/ /app/

# Start server.
EXPOSE 5555
CMD ["/app/bin/server"]
