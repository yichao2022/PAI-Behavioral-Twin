# NICA: Perspective-Aware Causal Engine for Behavioral Digital Twins

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview
This repository contains the core analytical components and perspective-aware causal engines developed for the study of behavioral digital twins. The primary focus is on **NICA (Non-Invasive Causal Audit)**, which identifies high-sensitivity swing groups (neutral trusters) and quantifies their behavior costs to optimize predictive digital twin models.

This architecture is "sAIpien-Ready," designed for the next generation of perspective-aware AI.

## Core Components
- **NICA (Analytical Core)**: Advanced causal inference and auditing algorithms (e.g., `run_trust_interaction_v7.R`).
- **DCE (Discrete Choice Experiment)**: Mixed logit and intertemporal choice analysis scripts.
- **Analytical Data**: Clean datasets containing coefficients and interaction results for behavioral modeling.

## 🏗 Architecture & Data Flow
The engine is designed to operate within a hybrid, multi-modal data environment:

1.  **Distributed 5TB Data Core**: The high-resolution behavioral data is stored on a distributed Google Drive (5TB), synchronized using custom automation (`XHS_Automator`).
2.  **Multimodal Sync**: Real-time synchronization of behavioral signals from social platforms (Xiaohongshu) to the staging area.
3.  **Local Execution (NICA)**: Causal auditing and model refinement are performed locally on the Mac Studio M4 Max computational stack for maximum throughput.
4.  **Perspective-Aware Synthesis**: The NICA engine processes distributed data to refine the "Perspective-Aware" behavioral twins.

## Usage
- The scripts in `scripts/` provide the baseline DCE modeling.
- The `core/` folder contains the auditing logic for trust heterogeneity and intertemporal discounting.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Maintained by Yichao Jin, PhD Candidate at the University of Texas at Dallas.

