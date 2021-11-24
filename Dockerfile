FROM tlc_tp1 AS builder
RUN apt remove -y git
RUN apt remove -y maven
RUN rm -rf src/ 
