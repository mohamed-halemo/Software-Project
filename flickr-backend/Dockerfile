#Uses python image as a base, to use python & pip
FROM python

#Sets work directory
WORKDIR '/app'

#Installs project dependencies
#RUN apk add zlib-dev jpeg-dev gcc musl-dev
COPY requirements.txt ./
RUN pip install -r requirements.txt

#Copies project files - unnecessary due to volume
#but kept for easy migration to different deployment
COPY ./ ./
