FROM python:3.8.5-alpine


RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apk add gettext

COPY locales locales/
RUN cd locales && /bin/sh compile.sh
RUN rm locales/**/**/*.po

COPY images images/
COPY test test/
COPY *.py Pipfile Pipfile.lock requirements.txt ./

RUN pip install -r requirements.txt

ARG admin_list=[0]
ARG open_lobby=true
ARG enable_translations=false
ARG workers=32
ARG default_gamemode=fast
ARG waiting_time=120
ARG time_removal_after_skip=20
ARG min_fast_turn_time=15
ARG min_players=2
RUN echo "{\"admin_list\": $admin_list,\"open_lobby\": $open_lobby,\"enable_translations\": $enable_translations,\"workers\": $workers,\"default_gamemode\": \"$default_gamemode\",\"waiting_time\": $waiting_time,\"time_removal_after_skip\": $time_removal_after_skip,\"min_fast_turn_time\": $min_fast_turn_time,\"min_players\": $min_players}" > config.json

CMD ["python3", "bot.py"]