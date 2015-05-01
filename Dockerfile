FROM ubuntu:14.04

ENV UPDATED_AT 2015-05-01

RUN apt-get update

RUN apt-get install -y \
    curl \
    gcc \
    make

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN cpanm PDF::Create
RUN cpanm Moment
RUN cpanm boolean

RUN mkdir /data

COPY bin/ /app

CMD /app/pdf_a4_two_months.pl
