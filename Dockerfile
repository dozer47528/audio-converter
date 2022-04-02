FROM ubuntu:20.04

ENV TARGET=/video
ENV SOURCE_VIDEO_FORMATS=mp4,mkv,avi,mov
ENV TARGET_AUDIO_FORMAT=ac3
ENV DEBUG=0
ENV INTERVAL=60

RUN apt update && apt -y install ffmpeg && apt clean autoclean -y && apt autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/

ADD audio-converter.sh /audio-converter.sh

CMD /audio-converter.sh