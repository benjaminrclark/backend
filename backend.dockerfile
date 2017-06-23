FROM alpine
RUN apk add --no-cache ruby make gcc g++ ruby-dev
RUN gem install sinatra json --no-document

ENV APP_PATH /var/opt/sinatra/src

RUN mkdir -p $APP_PATH
COPY backend.rb $APP_PATH/app.rb
COPY app.conf /etc/app.conf 

CMD ruby $APP_PATH/app.rb -o 0.0.0.0
