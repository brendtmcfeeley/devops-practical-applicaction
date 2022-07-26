FROM node

# Only necessary if we're running this for the first or outside of CI/CD environment
# Normally we could use copy in node_modules and other necessary to save space and time,
# but leaving this here so the build can work everytime
COPY . .
RUN npm install

CMD [ "npm", "start" ]