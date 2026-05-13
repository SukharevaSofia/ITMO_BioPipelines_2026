FROM continuumio/miniconda3:latest

COPY environment.local.yaml /tmp/environment.local.yaml
RUN conda env create -f /tmp/environment.local.yaml && conda clean -a -y

ENV PATH=/opt/conda/envs/hw3-pipeline/bin:$PATH

WORKDIR /hw3/
#COPY /hw3
#COPY ggal_ref.fna.zst ggal_gut_1.fq ggal_gut_2.fq entrypoint.sh /hw3
#COPY modules/ /hw3/modules/
#RUN chmod +x entrypoint.sh

#ENTRYPOINT ["/hw3/entrypoint.sh"]
#CMD ["nextflow", "run", "main.nf", "--help"]
