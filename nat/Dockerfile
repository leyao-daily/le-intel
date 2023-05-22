FROM node:18

RUN useradd -ms /bin/bash cnapops
COPY ./cnap /cnap
RUN chown -R cnapops /cnap

USER cnapops
WORKDIR /cnap/ui/
RUN npm install
EXPOSE 3000
CMD ["npm", "run", "serve"]
