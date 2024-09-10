FROM nginx:latest

COPY ./website /usr/share/nginx/html

EXPOSE 3333

CMD ["nginx", "-g", "daemon off;"]
