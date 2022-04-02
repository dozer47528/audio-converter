FROM ubuntu:20.04

ENV TARGET=/video
ENV SOURCE_VIDEO_FORMATS=mp4,mkv,avi,mov
ENV TARGET_AUDIO_FORMAT=ac3
ENV DEBUG=0
ENV CRONTAB="0 * * * *"

RUN apt update && apt -y install cron ffmpeg && apt clean autoclean -y && apt autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/

ADD audio-converter.sh /audio-converter.sh
RUN touch /var/log/cron.log

RUN echo "\"$CRONTAB\" root DEBUG=\"$DEBUG\" TARGET=\"$TARGET\" SOURCE_VIDEO_FORMATS=\"$SOURCE_VIDEO_FORMATS\" TARGET_AUDIO_FORMAT=\"$TARGET_AUDIO_FORMAT\" /audio-converter.sh >> /var/log/cron.log 2>&1" >> /etc/cron.d/audio-converter-cron
RUN echo "# Don't remove the empty line at the end of this file. It is required to run the cron job" >> /etc/cron.d/audio-converter-cron
RUN chmod 0644 /etc/cron.d/audio-converter-cron

CMD cron && tail -f /var/log/cron.log