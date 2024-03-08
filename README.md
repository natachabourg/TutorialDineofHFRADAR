# dineof_summer_school

This is a DINEOF (Data Interpolating Empirical Orthogonal Functions) algorithm tutorial! DINEOF, developed by Alvera-Azcarate et al. (2005), is a powerful tool for filling gappy surface water velocity data obtained from high-frequency radars.

## Overview

This tutorial provides a step-by-step guide on how to use DINEOF to fill your HF-RADAR data. Below are the key folders in this repository:

- **dineof-3.0:** Contains all the codes for the DINEOF algorithm itself.
- **input_data:** This is where you should place your HF-RADAR data that needs filling.
- **my_result_folder:** The filled HF-RADAR maps will be stored here.
- **scripts:** Houses all the necessary scripts for running the DINEOF process.

## Usage Instructions

Follow these steps to utilize the DINEOF algorithm effectively:

1. **Pre-processing:**
   - Run `pre_processing.m` to create preprocessed .nc files containing the data you wish to fill.

2. **Execute DINEOF:**
   - Execute `run_dineof.sh` to run the DINEOF algorithm on your preprocessed data.

3. **Reconstruct Total Current Velocity:**
   - Use `vector_map_results.m` to reconstruct the total current velocity based on the filled data.

4. **Plotting Comparison:**
   - Run `plot_results.m` to generate plots comparing the true and reconstructed values.
For more detailed information about the DINEOF algorithm, please refer to the [official DINEOF repository](https://github.com/aida-alvera/DINEOF).
