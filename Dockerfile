FROM debian:jessie
# https://docs.github.com/ja/free-pro-team@latest/actions/creating-actions/dockerfile-support-for-github-actions

ENV RUBY_VERSION 1.8.7-p374
ENV PATH /usr/local/rvm/gems/ruby-${RUBY_VERSION}/bin:/usr/local/rvm/gems/ruby-${RUBY_VERSION}@global/bin:/usr/local/rvm/rubies/ruby-${RUBY_VERSION}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/rvm/bin

RUN set -ex \
 && apt-get update && apt-get install -y curl git build-essential \
 && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
 && gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
ADD https://curl.haxx.se/ca/cacert.pem /etc/ssl/certs/cacert.pem

RUN curl -sSL https://get.rvm.io | bash -s stable
RUN rvm install ${RUBY_VERSION}
COPY .gemrc /root/.gemrc
# RUN gem update --system 2.7.11 --no-ri --no-rdoc
RUN gem cert --add /etc/ssl/certs/cacert.pem
RUN gem install bundler -v 1.17.3 --no-ri --no-rdoc

ENV BUNDLE_SSL_CA_CERT /etc/ssl/certs/cacert.pem
ENV BUNDLE_SSL_VERIFY_MODE 0
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
