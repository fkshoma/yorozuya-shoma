FROM ruby:2.6.3

# 必要なパッケージのインストール（基本的に必要になってくるものだと思うので削らないこと）
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs \
                       default-mysql-client \
                       graphviz \
 && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの作成、設定
RUN mkdir /yorozuya
##作業ディレクトリ名をAPP_ROOTに割り当てて、以下$APP_ROOTで参照
ENV APP_ROOT /yorozuya
WORKDIR $APP_ROOT

# ホスト側（ローカル）のGemfileを追加する（ローカルのGemfileは【３】で作成）
ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

# bundleのpathを設定
ENV BUNDLE_PATH=$APP_ROOT/vendor/bundle
RUN bundle config path $BUNDLE_PATH

# Gemfileのbundle install
RUN bundle install
ADD . $APP_ROOT
