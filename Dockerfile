FROM ruby:3.4.4

WORKDIR /app

COPY . .

RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

