FROM python:3.11-bullseye

# Install sphinx
RUN pip install -U sphinx \
  && pip install sphinx_rtd_theme

# Set up our docs
RUN mkdir /tripal_doc
COPY . /tripal_doc/
WORKDIR /tripal_doc/docs
