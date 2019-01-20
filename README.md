# RadX (VK-1.1.98)

> You asked question, but how can be fast radix sort in NVIDIA Turing GPU's?

GPU sorting shaders dedication from vRt project.

## What to be want to do

- Optimized sorting for NVIDIA RTX GPU's (and, probably, Volta GPU's)
- Remove outdated or extra codes
- Add new experimental features without rendering backend
- In future, add support for other possible architectures (Radeon VII, Navi, Ampere)
- Add support for Intel UHD Graphics 630 (if we will have time)
- CUDA compute cabability 7.5 interporability

## To do in test code (C++)

- Make headless sorting test
- Make C++ headers for sort
- Add simple benchmark
- Backdrop vendor detection

## Preview results

- Radix sort in RTX 2070 can reach speed, equally non-overclocked Intel Core i7-8700K with some optimizations
- Performance tested in Windows 10 Build 18317 (Insiders) and Visual Studio 2019 
- Can build by GCC-8 in Linux systems (tested in Ubuntu 18.10)

