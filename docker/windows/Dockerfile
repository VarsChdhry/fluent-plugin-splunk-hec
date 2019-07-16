FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL maintainer="Splunk Inc. <DataEdge@splunk.com>"

# skip runtime bundler installation
ENV FLUENTD_DISABLE_BUNDLER_INJECTION 1
COPY *.gem /tmp/

RUN powershell -Command \
  Set-ExecutionPolicy Bypass -Scope Process -Force; \
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install -y ruby --version 2.4.2.2 --params "'/InstallDir:C:\'" \
  && choco install -y msys2 --params "'/NoPath /NoUpdate /InstallDir:C:\ruby24\msys64'" \
  && refreshenv \
  && ridk install 2 3

RUN echo gem: --no-document >> C:\ProgramData\gemrc \
  && gem install -N fluentd -v "1.4.0" \
  && gem install -N fluent-plugin-concat -v "2.2.2" \
  && gem install -N fluent-plugin-prometheus -v "1.3.0" \
  && gem install -N oj -v "3.5.1" \
  && gem install -N /tmp/*.gem \
  && gem sources --clear-all

# plugin hardfails when using net-http-persistent 3.0.0+ on windows
# https://github.com/drbrain/net-http-persistent/issues/79
# downgrade net-http-persistent to 2.9.4
RUN gem uninstall net-http-persistent --ignore-dependencies \
  && gem install -N net-http-persistent --version 2.9.4

# Remove gem cache
RUN powershell -Command del C:\ruby24\lib\ruby\gems\2.4.0\cache\*.gem;

ENTRYPOINT ["cmd", "/k", "fluentd"]
CMD ["-h"]
