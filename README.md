# RDS/spec-id

[![Open in GitHub Codespaces](https://img.shields.io/badge/Open_In_GitHub_Codespaces-black?labelColor=grey&logo=github)](https://github.com/codespaces/new/RDS/spec-id)
[![GitHub Actions CI Status](https://github.com/RDS/spec-id/actions/workflows/nf-test.yml/badge.svg)](https://github.com/RDS/spec-id/actions/workflows/nf-test.yml)
[![GitHub Actions Linting Status](https://github.com/RDS/spec-id/actions/workflows/linting.yml/badge.svg)](https://github.com/RDS/spec-id/actions/workflows/linting.yml)[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com)

[![Nextflow](https://img.shields.io/badge/version-%E2%89%A525.10.4-green?style=flat&logo=nextflow&logoColor=white&color=%230DC09D&link=https%3A%2F%2Fnextflow.io)](https://www.nextflow.io/)
[![nf-core template version](https://img.shields.io/badge/nf--core_template-4.0.0-green?style=flat&logo=nfcore&logoColor=white&color=%2324B064&link=https%3A%2F%2Fnf-co.re)](https://github.com/nf-core/tools/releases/tag/4.0.0)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/RDS/spec-id)

## Introduction

## Usage

```bash
nextflow run main.nf \
   -profile apptainer \
   --input samplesheet.csv \
   --outdir <OUTDIR>
```

Or with slurm

```bash
nextflow run main.nf --slurm_p true --slurm_arguments "-p NMLResearch -A enterics"\
   -profile apptainer \
   --input samplesheet.csv \
   --outdir <OUTDIR>
```

Sample sheet layout currently requires only a sample and assembly field, assemblies can be gzipped or plain text. An example sample sheet can be found in the `tests/data/samplesheet.csv` directory.

An schematic of the sample sheet is also provided below:

| sample      | assembly                  |
| ----------- | ------------------------- |
| cool_sample | tests/data/tests_fasta.fa |

The following databases are required for using the program:

kraken 2 database (8GB preferred), set via cli as `--kraken2.db /DATABASE/gg` or in the config file
Gambit database, set via cli as `--gambit.db /DATABASE/gg` or in the config file
LexicMap database, set via cli as `--lexicmap.db /DATABASE/gg` or in the config file

> [!NOTE]
> Ganon is a bit special so you need to pass the database path, and the prefix used for the ganon database. If any field is missed an error will be raised.
> Ganon database, set via cli as `--ganon.db /DATABASE/gg --ganon.db_prefix ganon_test` or in the config file

## Credits

The crew.

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](docs/CONTRIBUTING.md).

## Citations

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/main/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
