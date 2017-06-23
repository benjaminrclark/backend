FROM alpine
RUN apk add --no-cache ruby make gcc g++ ruby-dev
RUN gem install sinatra --no-document
RUN gem install json --no-document

ENV APP_PATH /var/opt/sinatra/src

RUN mkdir -p $APP_PATH
COPY app.rb $APP_PATH/app.rb
COPY backend.conf /etc/backend.conf 

EXPOSE 4567

CMD ruby $APP_PATH/app.rb -o 0.0.0.0
