FROM ruby:2.3.0

RUN apt-get update && apt-get -y install git build-essential
RUN gem install bundler --no-document

RUN git clone https://github.com/e10dokup/wada_with_fw.git
WORKDIR /wada_with_fw

RUN bundle install