FROM julia:1.1.0-stretch

WORKDIR /app

COPY packages.jl /app

RUN julia /app/packages.jl

RUN rm /app/packages.jl

ENTRYPOINT ["julia"]
