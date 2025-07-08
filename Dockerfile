FROM perl:5.42.0

RUN cpm install -g Starman JSON::XS Image::ExifTool@13.30 && rm -rf ~/.perl-cpm

WORKDIR /usr/src/app
COPY app.psgi /usr/src/app

ENTRYPOINT ["starman"]
