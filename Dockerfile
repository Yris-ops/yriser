#This file is part of Yriser.
#SPDX-License-Identifier: Apache-2.0

#Licensed to the Apache Software Foundation (ASF) under one
#or more contributor license agreements.  See the NOTICE file
#distributed with this work for additional information
#regarding copyright ownership.  The ASF licenses this file
#to you under the Apache License, Version 2.0 (the
#"License"); you may not use this file except in compliance
#with the License.  You may obtain a copy of the License at

#http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing,
#software distributed under the License is distributed on an
#"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#KIND, either express or implied.  See the License for the
#specific language governing permissions and limitations
#under the License.

FROM debian:11-slim

LABEL \ 
    maintainer="https://github.com/yris/yriser" \
    license="Apache-2.0"

RUN apt-get update && apt-get install -y

RUN apt-get install curl jq unzip bc -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
    
# Create nonroot user
RUN mkdir -p /home/yriser && \
    echo 'yriser:x:1000:1000:yriser:/home/yriser:' > /etc/passwd && \
    echo 'yriser:x:1000:' > /etc/group && \
    chown -R yriser:yriser /home/yriser
USER yriser

WORKDIR /home/yriser
COPY ./ /home/yriser/

USER yriser
ENTRYPOINT ["./yriser.sh"]