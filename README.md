# pdf_a4_two_months

This is a simple script to create pdf file with 2 months.

![Pdf screenshot][https://upload.bessarabov.ru/bessarabov/Q2T5GyXtwro_pKrNbZLhbVhvqJw.png]

## How to use it

You need to [install Docker](https://docs.docker.com/installation/).

Then you need to build image:

    docker build --tag pdf_a4_two_months .

And then start it, specifying the start year and month:

    docker run \
        --rm \
        --env "START_YEAR_MONTH=2015-05" \
        --volume `pwd`:/data \
        pdf_a4_two_months

And you will get file `2015-05.pdf` in your working directory.
