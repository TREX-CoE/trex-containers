# TREX-CoE Software Containers

Welcome to the official GitHub repository for Apptainer (formerly Singularity)
containers of the TREX Center of Excellence (TREX-CoE) software suite. This
repository provides the necessary tools and recipes to create containers
encapsulating the TREX software environment, allowing for easy deployment and
scalability across various computing architectures including x86_64 (with AVX2
support) and aarch64 (ARM).

## About TREX-CoE

TREX-CoE aims to advance the field of quantum chemistry and computational
materials science by developing and optimizing Quantum Monte Carlo (QMC) and
wave function theory (WFT) codes for exascale computing applications. The
center focuses on creating an ecosystem of interoperable QMC codes that achieve
ultimate accuracy and performance on pre-exascale and exascale systems.

## Repository Contents

This repository includes Apptainer recipes for creating:
- A unified container that contains all the TREX-CoE software, facilitating easy access and deployment of the entire suite.
- Individual containers for each code within the TREX-CoE suite, allowing users to deploy specific tools as needed.

### Supported Architectures
- **x86_64 with AVX2 Support:** Optimized for modern Intel and AMD processors
- **ARM (aarch64):** Ensures compatibility and high performance on ARM-based architectures

### Download SIF files

- [All software](https://cloud.sylabs.io/library/scemama/trex/all)
- [Quantum Package + QMC=Chem](https://cloud.sylabs.io/library/scemama/trex/qp2-qmcchem)
- [Turbo RVB](https://cloud.sylabs.io/library/scemama/trex/turborvb)
- [CHAMP](https://cloud.sylabs.io/library/scemama/trex/champ)
- [GammCor](https://cloud.sylabs.io/library/scemama/trex/gammcor)
- [NECI](https://cloud.sylabs.io/library/scemama/trex/neci)


## Getting Started

### Prerequisites
- Apptainer (Singularity) installed on your system. Visit the [Apptainer documentation](https://apptainer.org/docs/) for installation instructions.

### Clone the Repository
To get started, clone this repository to your local machine:
```bash
git clone https://github.com/TREX-CoE/trex-containers.git
cd trex-containers
```

### Building Containers
To build a container, navigate to the directory of the desired software or
architecture version and use the Apptainer build command. For example, to build
the container for the entire TREX-CoE suite on x86_64 architecture:

```bash
cd champ
sudo apptainer build champ.sif champ.def
```

```bash
cd all
sudo apptainer build trex.sif all.def
```

### Running Containers
Once built, you can run your container using Apptainer. For example:
```bash
apptainer run all.sif
```

## Contributing

Contributions to the TREX-CoE containers project are welcome. Please refer to
the [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on how to
contribute.

## Support

For support and questions, please open an issue in the GitHub repository or
contact the TREX-CoE team.

## License

This project is licensed under the GPL License - see the [LICENSE](LICENSE)
file for details.

## Acknowledgments

This work is supported by the TREX Center of Excellence, part of the European
Union's Horizon 2020 research and innovation program.


