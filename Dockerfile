FROM python:3.6.13-buster

RUN apt-get update
RUN apt-get install libtool automake virtualenv git -y

RUN git clone https://github.com/chokkan/liblbfgs
RUN cd liblbfgs && \
    ./autogen.sh && \
    ./configure --enable-sse2 && \
    make && \
    make install

RUN git clone https://bitbucket.org/rtaylor/pylbfgs /opt/pylbfgs
RUN rm /opt/pylbfgs/requirements.txt
RUN echo "numpy==1.19.5" > /opt/pylbfgs/requirements.txt

RUN virtualenv -p python3.6 --prompt="(pylbfgs) " .venv
RUN . .venv/bin/activate && \
    python -m pip install jupyterlab matplotlib scipy scikit-image && \
    cd /opt/pylbfgs && \
    python -m pip install -r requirements.txt && \
    python setup.py install

CMD . .venv/bin/activate && jupyter lab --ip 0.0.0.0 --allow-root
