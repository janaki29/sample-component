FROM registry.access.redhat.com/ubi8/ubi:latest

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR  /opt/app-root/src
RUN npm install yarn --global


COPY src src
COPY package.json package.json


RUN yarn install
RUN yarn build


COPY --from=builder /opt/app-root/src/dist/* /opt/app-root/src/

# USER 0
# # Disable IPv6 since it's not enabled on all systems
# RUN sed -i '/\s*listen\s*\[::\]:8080 default_server;/d' /etc/nginx/nginx.conf
# USER 1001

CMD ["nginx", "-g", "daemon off;"]
