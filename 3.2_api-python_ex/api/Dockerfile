FROM alpine:3.10 

WORKDIR /app
COPY . /app

RUN apk add --no-cache python3-dev \
    && pip3 install --upgrade pip 


RUN pip3 --no-cache-dir install -r requirements.txt

CMD ["python3","route.py"]



# FROM python:3.7-alpine

# WORKDIR /app
# COPY . /app



# RUN python3 -m venv api_py

# #RUN apk add --upgrade py3-virtualenv

# RUN source api_py/bin/activate 

# RUN pip3 install --upgrade pip 

# #RUN  python3 -m pip install --upgrade pip

# RUN pip3 install -r  requirements.txt


# CMD [ "python3","route.py" ]
