# NICA Framework: Neuro-Inspired Computational Architecture for Behavioral Decision Modeling

**Version:** 1.0 (Internal Draft - "Hardcore" Technical Specification)
**Date:** 2026-03-29
**Lead Architect:** Yichao Jin
**Objective:** To formalize the recursive integration of biological neural constraints into agent-based choice models (MNL/MXL/ABM).

---

## 1. Core Neural Circuits & Functional Mapping
The NICA framework maps specific behavioral parameters derived from Essay 1 & 2 to discrete functional neural substrates:

### A. Valuation & Integration (Ventromedial Prefrontal Cortex - vmPFC)
- **Model Parameter:** $\beta_{waiting\_time}$, $V_{ij}$ (Systematic Utility).
- **Neural Correlate:** Encodes the "Relative Subjective Value" (RSV).
- **NICA Constraint:** Implements a **Stochastic Decision Threshold**. Instead of a fixed utility cutoff, the integration process follows a **Drift-Diffusion Model (DDM)** where the drift rate $\nu$ is proportional to $\Delta V$, and the threshold $a$ is modulated by cognitive load (measured via proxy in Essay 2).

### B. Time-Discounting & Intertemporal Choice (Ventral Striatum vs. dlPFC)
- **Model Parameter:** $\delta$ (Discount factor), $\kappa$ (Hyperbolic parameter).
- **Neural Correlate:** 
    - **Ventral Striatum (VS):** Immediate reward processing ("Now" bias).
    - **Dorsolateral Prefrontal Cortex (dlPFC):** Executive control and delayed gratification.
- **NICA Constraint:** **Dual-System Competition Model**. We replace the standard $\delta$ with a dynamic ratio $R_{comp} = \frac{\phi_{VS}}{\phi_{dlPFC} + \epsilon}$, where $\phi$ represents simulated neural firing rates. This explains why "Waiting Time" acts as a physical barrier triggering VS-driven rejection.

### C. Uncertainty & Risk Processing (Anterior Insula & Amygdala)
- **Model Parameter:** $\sigma$ (Error term variance/Scale parameter), Trust interaction terms.
- **Neural Correlate:** 
    - **Anterior Insula:** Salience and "Aversive Prediction Error".
    - **Amygdala:** Fear-conditioned responses to institutional distrust.
- **NICA Constraint:** **Predictive Coding Engine**. The model updates the scale parameter $\lambda$ (inverse of $\sigma$) based on the "Entropy of Institutional Cues." High distrust = High Insula activation = High choice stochasticity.

---

## 2. Mathematical Formalization (The "Hardcore" Layer)

### 2.1 The NICA-Augmented Logit (NAL)
The probability of choosing option $i$ is no longer just $P_i = \frac{e^{V_i}}{\sum e^{V_j}}$, but:

$$P_i(t) = \int_0^T f(t; \nu(V, \text{Neural\_State}), a, z) dt$$

Where:
- $\nu$ (Drift rate) $= \sum \beta_k X_k \cdot \Omega_{\text{attentional\_gain}}$
- $\Omega$ is a gain control factor derived from simulated **Locus Coeruleus (LC)** Norepinephrine activity (linked to the "Waiting Stress" identified in Wuhan data).

### 2.2 Adaptive Parameter Tuning (Hebbian Learning Rule)
For longitudinal ABM simulations (Essay 3), agent preferences evolve via a pseudo-Hebbian rule:
$$\Delta \beta_{ij} = \eta \cdot (R_{actual} - R_{predicted}) \cdot \text{Neural\_Sensitivity}$$
This ensures that agents in the smart grid simulation don't just "calculate"—they "habituate" to peak-shaving signals.

---

## 3. Implementation Parameters (Based on Dissertation Data)

| NICA Component | Associated Parameter | Empirical Grounding (N=1,027) | Simulated Neural Variable |
| :--- | :--- | :--- | :--- |
| **Patience Buffer** | $\kappa$ (Hyperbolic) | 0.225 | Dopaminergic Decay Constant |
| **Trust Filter** | Interaction (Trust x Wait) | $p=0.021$ | Amygdala-vmPFC Connectivity |
| **Value Floor** | MWTA | 44.8 RMB/month | Basal Ganglia "Go/No-Go" Threshold |
| **Time Sensitivity** | $\delta$ (Discounting) | 0.160 | Serotonergic Modulation Rate |

---

## 4. Next Steps for "Minor Thinker" IP
1.  **Quantization:** Convert these neural differential equations into lookup tables for local 30B LLM inference.
2.  **Validation:** Run the "CellCog" audit against `main_text_7_.pdf` to see if the dissertation's "Ethical Considerations" section needs to address simulated neural privacy.

---
# [Methodology]: Validating NICA framework via discrete choice modeling
