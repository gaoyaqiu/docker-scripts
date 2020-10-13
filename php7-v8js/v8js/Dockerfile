FROM php:7.3.1-fpm

# Update & install essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
  mysql-client \
  git \
  build-essential \
  curl \
  python \
  libglib2.0-dev \
  patchelf \
  && docker-php-ext-install pdo_mysql bcmath \
  && cd /tmp \
  && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git \
  && export PATH="$PATH:/tmp/depot_tools" \
  \
  && fetch v8 \
  && cd v8 \
  && git checkout 8.0.426.30 \
  && gclient sync \
  && tools/dev/v8gen.py -vv x64.release -- \
  is_component_build=true \
  use_custom_libcxx=false \
  \
  && ninja -C out.gn/x64.release/ \
  # Install to /opt/v8/
  && mkdir -p /opt/v8/{lib,include} \
  && cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin \
  out.gn/x64.release/icudtl.dat /opt/v8/lib/ \
  && sudo cp -R include/* /opt/v8/include/ \
  && for A in /opt/v8/lib/*.so; do patchelf --set-rpath '$ORIGIN' $A;done \
  \
  && cd /tmp \
  && git clone https://github.com/phpv8/v8js.git \
  && cd v8js \
  && git checkout php7 \
  && phpize \
  && ./configure --with-v8js=/opt/v8 LDFLAGS="-lstdc++" CPPFLAGS="-DV8_COMPRESS_POINTERS" \
  && export NO_INTERACTION=1 \
  && make \
  && make test \
  && make install \
  && docker-php-ext-enable v8js \
  \
  && rm -rf /tmp/* \
  && apt-get remove -y git build-essential curl python libglib2.0-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*